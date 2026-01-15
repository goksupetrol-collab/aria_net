-- Function: dbo.Fn_StokFifo
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.660394
================================================================================

CREATE FUNCTION [dbo].Fn_StokFifo (
@Firmano    int,
@Stok_Tip VARCHAR(20),
@Stok_KodIn VARCHAR(8000),
@Tarih DATETIME)
/*@SonTarih DATETIME) */
RETURNS
   @FIFO_MALSTK TABLE (
    STOK_GRUP         VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_TIP          VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD          VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD           VARCHAR(150)  COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BRMTUT             FLOAT)
AS
BEGIN

DECLARE @STOKMALIYET_TEMP TABLE (
    STOK_GRUP          	VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_KOD    		VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD    			VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_TIP    		VARCHAR(20)  COLLATE Turkish_CI_AS,
    ONCEKIMIKTAR      	FLOAT,
    ONCEKITUTAR       	FLOAT,
    ALISMIKTAR        	FLOAT,
    ALISTUTAR         	FLOAT,
    SATISMIKTAR        	FLOAT,
    SATISTUTAR         	FLOAT,
    MALIYETYUZDE       	FLOAT,
    SATISKAR           	FLOAT,
    ALISKAR            	FLOAT,
    DONEMSONUMIKTAR    	FLOAT,
    DONEMSONUTUTAR     	FLOAT,
    BRMTUT             	FLOAT)

/*FÄ°FO Ä°Ã‡Ä°N GIRIS TABLOSU */
DECLARE @STOKHRK_TEMP TABLE (
    ID           FLOAT,
    STOK_KOD     VARCHAR(30),
    STOK_AD      VARCHAR(150),
    STOK_TIP     VARCHAR(20),
    DEPOKOD      VARCHAR(20),
    HRKTIP       VARCHAR(1),
    MIKTAR       FLOAT,
    BRMTUT       FLOAT,
    CIKMIK       FLOAT,
    TARIH        DATETIME)


  DECLARE @ID              FLOAT
  DECLARE @HRK_ID          FLOAT
  DECLARE @HRK_STOK_KOD    VARCHAR(30)
  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_HRKTIP      VARCHAR(30)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_MIKTAR      FLOAT
  DECLARE @HRK_BRMTUT      FLOAT
  DECLARE @HRK_CIKMIK      FLOAT
  DECLARE @KALANMIK        FLOAT
  DECLARE @DUSMIK          FLOAT


  /*---Stok kartlarÄ± gecici tabloya atÄ±ldÄ± */
  INSERT @STOKMALIYET_TEMP (STOK_GRUP,STOK_KOD,STOK_AD,STOK_TIP)
  SELECT ST.tip,st.kod,ST.ad,ST.tip
  from stokkart st with (NOLOCK)
  where st.sil=0 and st.drm='Aktif' and st.tip=@Stok_Tip
  and st.Kod in (select * from CsvToSTR(@Stok_KodIn) )
  /*---Stok kartlarÄ± gecici tabloya atÄ±ldÄ± */

/*---stokhrk kartlarÄ± gecici tabloya atÄ±ldÄ± */
/*-GIRISLER */
  INSERT @STOKHRK_TEMP (ID,STOK_KOD,STOK_TIP,DEPOKOD,TARIH,HRKTIP,MIKTAR,BRMTUT,CIKMIK)
  SELECT S.id,s.stkod,S.stktip,S.depkod,S.tarih+cast(saat as datetime),'G',S.giren,S.brmfiykdvli,0
  FROM stkhrk as s with (NOLOCK) 
  inner join @STOKMALIYET_TEMP as stkt on s.stkod=stkt.STOK_KOD
  AND S.stktip=stkt.STOK_TIP and s.sil=0 and s.firmano in (0,@Firmano)
  where s.giren>0 and (s.tarih <= @Tarih)
  ORDER BY S.tarih+cast(saat as datetime)

    /*----CIKISLAR */
    DECLARE STM_HRK CURSOR FAST_FORWARD FOR
    SELECT  S.id,s.stkod,S.stktip,'C',S.tarih+cast(saat as datetime),S.cikan
    FROM stkhrk as s with (NOLOCK) inner join @STOKMALIYET_TEMP as stkt on s.stkod=stkt.STOK_KOD
    AND S.stktip=stkt.STOK_TIP and s.sil=0 and s.firmano in (0,@Firmano)
    where S.cikan>0 and (s.tarih <= @Tarih)
    ORDER BY (S.tarih+cast(saat as datetime))

   OPEN STM_HRK

   FETCH NEXT FROM STM_HRK INTO
   @HRK_ID,@HRK_STOK_KOD,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIK
   WHILE @@FETCH_STATUS = 0
   BEGIN


     WHILE @HRK_CIKMIK>0 
     BEGIN
     SET @HRK_BRMTUT=0
     SET @KALANMIK=0

     SELECT top 1 @ID=ID,@KALANMIK=ISNULL(MIKTAR-CIKMIK,0),@HRK_BRMTUT=ISNULL(BRMTUT,0)
     FROM @STOKHRK_TEMP WHERE STOK_TIP=@HRK_STOK_TIP AND STOK_KOD=@HRK_STOK_KOD
     AND (MIKTAR-CIKMIK)>0 AND HRKTIP='G' ORDER BY TARIH

    
     IF @KALANMIK=0
     BEGIN
       SET @DUSMIK=@HRK_CIKMIK
     END
     ELSE
     BEGIN
     IF @HRK_CIKMIK>@KALANMIK
       SET @DUSMIK=@KALANMIK
     ELSE
       SET @DUSMIK=@HRK_CIKMIK
     END
    
     /*-SET @DUSMIK=@HRK_CIKMIK */
      INSERT @STOKHRK_TEMP (ID,STOK_KOD,STOK_TIP,HRKTIP,TARIH,MIKTAR,BRMTUT)
      VALUES (@HRK_ID,@HRK_STOK_KOD,@HRK_STOK_TIP,'C',@HRK_TARIH,-1*@DUSMIK,@HRK_BRMTUT)

      /*-------------------------------- */
      UPDATE @STOKHRK_TEMP SET CIKMIK=CIKMIK+@DUSMIK WHERE ID=@ID

      SET @HRK_CIKMIK=@HRK_CIKMIK-@DUSMIK

    END;

   FETCH NEXT FROM STM_HRK INTO
   @HRK_ID,@HRK_STOK_KOD ,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIK
  END

  CLOSE STM_HRK
  DEALLOCATE STM_HRK


 

  INSERT @FIFO_MALSTK (STOK_KOD,STOK_TIP,MIKTAR,BRMTUT)
   select STOK_KOD,STOK_TIP,SUM(MIKTAR),
   ISNULL( (CASE when SUM(MIKTAR)>0 then SUM(MIKTAR*BRMTUT)/sum(MIKTAR)  
    ELSE 0 END  )  ,0) from @STOKHRK_TEMP
    GROUP BY STOK_KOD,STOK_TIP
    
   
    
RETURN


END

================================================================================
