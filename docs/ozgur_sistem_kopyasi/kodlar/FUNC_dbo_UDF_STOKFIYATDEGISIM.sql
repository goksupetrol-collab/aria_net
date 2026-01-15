-- Function: dbo.UDF_STOKFIYATDEGISIM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.772092
================================================================================

CREATE FUNCTION [dbo].UDF_STOKFIYATDEGISIM (@STOK_DEPKOD VARCHAR(20),
@STOK_TIP VARCHAR(20),
@STOKBRIMTIP INT,
@KDVTIP VARCHAR(10),
@TARIH1 DATETIME, @TARIH2 DATETIME)
RETURNS

  @TB_STOKTAR_HRK TABLE (
    STOK_TIP    VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEPO_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    DEPO_AD     VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEVIRMIKTAR     FLOAT,
    DEVIRTUTAR      FLOAT,
    GIRENMIKTAR      FLOAT,
    GIRENTUTAR       FLOAT,
    CIKANMIKTAR      FLOAT,
    CIKANTUTAR       FLOAT,
    KALANMIKTAR      FLOAT,
    KALANTUTAR       FLOAT,
    BRIM             VARCHAR(20)   COLLATE Turkish_CI_AS,
    BRMFIYKDVLI     FLOAT,
    KDVYUZ      FLOAT)
AS
BEGIN
  DECLARE @STKHRKTAR_TEMP TABLE (
    STOK_TIP    VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEPO_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    DEPO_AD     VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEVIRMIKTAR     FLOAT,
    DEVIRTUTAR      FLOAT,
    GIRENMIKTAR      FLOAT,
    GIRENTUTAR       FLOAT,
    CIKANMIKTAR      FLOAT,
    CIKANTUTAR       FLOAT,
    KALANMIKTAR      FLOAT,
    KALANTUTAR       FLOAT,
    BRIM             VARCHAR(20)  COLLATE Turkish_CI_AS,
    BRMFIYKDVLI     FLOAT,
    KDVYUZ      FLOAT)

  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_STOK_AD     VARCHAR(50)
  DECLARE @HRK_DEPO_KOD    VARCHAR(20)
  DECLARE @HRK_DEPO_AD     VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_DEVIRMIK    FLOAT
  DECLARE @HRK_DEVIRTUT    FLOAT
  DECLARE @HRK_GIRENMIK    FLOAT
  DECLARE @HRK_GIRENTUT    FLOAT
  DECLARE @HRK_CIKANMIK    FLOAT
  DECLARE @HRK_CIKANTUT    FLOAT
  DECLARE @HRK_KALANMIK    FLOAT
  DECLARE @HRK_KALANTUT    FLOAT

  DECLARE @HRK_BRIM        VARCHAR(50)
  DECLARE @HRK_BRMFIYKDVLI FLOAT
  DECLARE @HRK_KDVYUZ      FLOAT

/*
0=ALIS FIYAT
1=SATIS FIYAT 1
2=SATIS FIYAT 2
3=FIFO ALIS ORT
4=FIFO ALIS ORT
*/


 /*---------------------------------------------------------------------------- */
 INSERT @STKHRKTAR_TEMP (STOK_TIP,STOK_KOD,STOK_AD,DEPO_KOD,DEPO_AD,BRIM,KDVYUZ,BRMFIYKDVLI,
 DEVIRMIKTAR,DEVIRTUTAR,GIRENMIKTAR,GIRENTUTAR,CIKANMIKTAR,CIKANTUTAR,
 KALANMIKTAR,KALANTUTAR)
 SELECT k.tip,k.kod,k.ad,d.kod,D.ad,k.brim,0,0,
 /*---------devır mıktar */
   (SELECT isnull(SUM(giren-cikan),0) from stkhrk as s
   WHERE s.stktip=k.tip and s.stkod=k.kod and s.depkod=sd.depkod
   AND tarih < @TARIH1),
 /*--------------- */
  0,0,0,0,0,
 0,0 from stokkart as k
 inner join stkdrm as sd on sd.stktip=k.tip and sd.stkod=k.kod
 inner join Depo_Kart_Listesi  as d on d.kod=sd.depkod
 WHERE k.tip=@STOK_TIP and k.sil=0


  DECLARE STKTAR_HRK CURSOR FAST_FORWARD FOR
   SELECT
      k.tip,k.kod,k.ad,d.kod,D.ad,K.brim,S.kdvyuz,
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      
      FROM stkhrk as s inner join stokkart as k on s.stktip=k.tip
      and s.stkod=k.kod and k.sil=0
      inner join Depo_Kart_Listesi as d on d.kod=s.depkod
      WHERE s.stktip=@STOK_TIP
      AND (tarih >= @TARIH1 and tarih <= @TARIH2 )
      GROUP BY k.tip,k.kod,k.ad,d.kod,D.ad,kdvyuz,k.brim


  OPEN STKTAR_HRK

  FETCH NEXT FROM STKTAR_HRK INTO
   @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,@HRK_DEPO_KOD,@HRK_DEPO_AD,@HRK_BRIM,
   @HRK_KDVYUZ,@HRK_GIRENMIK,@HRK_CIKANMIK

  WHILE @@FETCH_STATUS = 0
  BEGIN

  
   IF @STOKBRIMTIP=0
   SELECT  @HRK_KDVYUZ=alskdv/100,@HRK_BRMFIYKDVLI=case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end from stokkart
   where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD

   IF @STOKBRIMTIP=1
   select @HRK_KDVYUZ=sat1kdv/100,@HRK_BRMFIYKDVLI=case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end from stokkart
   where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD

   if @STOKBRIMTIP=2
   select @HRK_KDVYUZ=sat2kdv/100,@HRK_BRMFIYKDVLI=case when sat2kdvtip='Dahil' then sat2fiy else sat2fiy*(1+(sat2kdv/100))  end from stokkart
   where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD
   
   if @STOKBRIMTIP=3
   SELECT @HRK_BRMFIYKDVLI=MALIYET FROM STOKFIFO (1,@HRK_DEPO_KOD,@HRK_STOK_TIP,@HRK_STOK_KOD,@TARIH1,@TARIH2)
   
   if @STOKBRIMTIP=4
   SELECT @HRK_BRMFIYKDVLI=MALIYET FROM STOKFIFO (2,@HRK_DEPO_KOD,@HRK_STOK_TIP,@HRK_STOK_KOD,@TARIH1,@TARIH2)

   
   
   IF @KDVTIP='Harıç'
   set @HRK_BRMFIYKDVLI=@HRK_BRMFIYKDVLI/(1+@HRK_KDVYUZ)
   
   select @HRK_DEVIRMIK=DEVIRMIKTAR from @STKHRKTAR_TEMP where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
   and DEPO_KOD=@HRK_DEPO_KOD
   
   SET @HRK_DEVIRTUT=@HRK_DEVIRMIK*@HRK_BRMFIYKDVLI
   SET @HRK_GIRENTUT=@HRK_GIRENMIK*@HRK_BRMFIYKDVLI
   SET @HRK_CIKANTUT=@HRK_CIKANMIK*@HRK_BRMFIYKDVLI

   SET @HRK_KALANMIK=@HRK_DEVIRMIK+@HRK_GIRENMIK-@HRK_CIKANMIK
   SET @HRK_KALANTUT=@HRK_KALANMIK*@HRK_BRMFIYKDVLI
  
  

    update @STKHRKTAR_TEMP
       set KDVYUZ=@HRK_KDVYUZ,BRMFIYKDVLI=@HRK_BRMFIYKDVLI,
       DEVIRTUTAR=@HRK_DEVIRTUT,GIRENMIKTAR=@HRK_GIRENMIK,GIRENTUTAR=@HRK_GIRENTUT,
       CIKANMIKTAR=@HRK_CIKANMIK,CIKANTUTAR=@HRK_CIKANTUT,
       KALANMIKTAR=@HRK_KALANMIK,KALANTUTAR=@HRK_KALANTUT
       where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
       and DEPO_KOD=@HRK_DEPO_KOD
       

     FETCH NEXT FROM STKTAR_HRK INTO
   @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,@HRK_DEPO_KOD,@HRK_DEPO_AD,@HRK_BRIM,
   @HRK_KDVYUZ,@HRK_GIRENMIK,@HRK_CIKANMIK
  END

  CLOSE STKTAR_HRK
  DEALLOCATE STKTAR_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_STOKTAR_HRK
    SELECT * FROM @STKHRKTAR_TEMP

  RETURN

END

================================================================================
