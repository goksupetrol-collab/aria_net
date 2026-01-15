-- Function: dbo.STOKMALIYETFIFO
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.681068
================================================================================

CREATE FUNCTION [dbo].STOKMALIYETFIFO (@STOK_AKTIPIN VARCHAR(8000),
@STOK_MARIN VARCHAR(8000),
@STOK_GGTIPIN VARCHAR(8000),
@TARIH1 DATETIME,@TARIH2 DATETIME)
RETURNS
   @FIFO_MALSTK TABLE (
    STOK_GRUP         VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_KOD          VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD           VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_TIP          VARCHAR(20) COLLATE Turkish_CI_AS,
    ONCEKIMIKTAR      FLOAT,
    ONCEKITUTAR       FLOAT,
    ALISMIKTAR        FLOAT,
    ALISTUTAR         FLOAT,
    SATISMIKTAR        FLOAT,
    SATISTUTAR         FLOAT,
    MALIYETYUZDE       FLOAT,
    SATISKAR           FLOAT,
    ALISKAR            FLOAT,
    DONEMSONUMIKTAR    FLOAT,
    DONEMSONUTUTAR     FLOAT,
    BRMTUT             FLOAT,
    TARIH              DATETIME)
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

/*FİFO İÇİN GIRIS TABLOSU */
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

/*-------------STOK KARTLARI AKARYAKIT */

DECLARE @IN_TEMP TABLE (
    id      FLOAT)
 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@STOK_AKTIPIN)) > 0)
 BEGIN
  set @STOK_AKTIPIN = @STOK_AKTIPIN + ','
 END

 while patindex('%,%' , @STOK_AKTIPIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @STOK_AKTIPIN)
   select @array_value = left(@STOK_AKTIPIN, @separator_position - 1)

  Insert @IN_TEMP
  Values (Cast(@array_value as float))
  select @STOK_AKTIPIN = stuff(@STOK_AKTIPIN, 1, @separator_position, '')
 end

/*---akaryakıt kartları gecici tabloya atıldı */
INSERT @STOKMALIYET_TEMP (STOK_GRUP,STOK_KOD,STOK_AD,STOK_TIP)
SELECT 'Akaryakıt',st.kod,ST.ad,ST.tip
from stokkart st with (NOLOCK)
where st.sil=0 and st.drm='Aktif' and st.id in (select id from @IN_TEMP)
/*---akaryakıt kartları gecici tabloya atıldı */

/*---stokhrk kartları gecici tabloya atıldı */
/*-GIRISLER */
INSERT @STOKHRK_TEMP (ID,STOK_KOD,STOK_TIP,DEPOKOD,TARIH,HRKTIP,MIKTAR,BRMTUT,CIKMIK)
SELECT S.id,s.stkod,S.stktip,S.depkod,S.tarih+cast(saat as datetime),'G',S.giren,S.brmfiykdvli,0
FROM stkhrk as s with (NOLOCK) inner join @STOKMALIYET_TEMP as stkt on s.stkod=stkt.STOK_KOD
AND S.stktip=stkt.STOK_TIP
where s.giren>0 and (s.tarih <= @TARIH2)
ORDER BY S.tarih+cast(saat as datetime)

    /*----CIKISLAR */
    DECLARE STM_HRK CURSOR FAST_FORWARD FOR
    SELECT  S.id,s.stkod,S.stktip,'C',S.tarih+cast(saat as datetime),S.cikan
    FROM stkhrk as s with (NOLOCK) inner join @STOKMALIYET_TEMP as stkt on s.stkod=stkt.STOK_KOD
    AND S.stktip=stkt.STOK_TIP
    where S.cikan>0 and (s.tarih <= @TARIH2)
    ORDER BY (S.tarih+cast(saat as datetime))

   OPEN STM_HRK

   FETCH NEXT FROM STM_HRK INTO
   @HRK_ID,@HRK_STOK_KOD,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIK
   WHILE @@FETCH_STATUS = 0
   BEGIN


     WHILE @HRK_CIKMIK>0 BEGIN
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



  INSERT @FIFO_MALSTK (STOK_KOD,STOK_TIP,ONCEKIMIKTAR,ONCEKITUTAR,ALISMIKTAR,TARIH)
   select STOK_KOD,HRKTIP,MIKTAR,BRMTUT,CIKMIK,TARIH from @STOKHRK_TEMP
RETURN


END

================================================================================
