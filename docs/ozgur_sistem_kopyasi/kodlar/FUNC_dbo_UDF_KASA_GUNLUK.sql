-- Function: dbo.UDF_KASA_GUNLUK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.733926
================================================================================

CREATE FUNCTION [dbo].UDF_KASA_GUNLUK (
@FIRMANO			int,
@KOD 				VARCHAR(20),
@TARIH1 			DATETIME,
@TARIH2				DATETIME)
RETURNS
  @TB_KASA_GUNLUK TABLE (
    Firmano     int,
    Firma_Ad    VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    KASA_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    KASA_AD     VARCHAR(70) COLLATE Turkish_CI_AS,
    DEVREDEN    FLOAT,
    GIREN       FLOAT,
    CIKAN       FLOAT,
    BAKIYE      FLOAT,
    KUR			FLOAT,
    KUR_GIREN	FLOAT,
    KUR_CIKAN	FLOAT,
    KUR_BAKIYE  FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    Firmano    int,
    Firma_Ad    VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    KASA_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    KASA_AD     VARCHAR(70) COLLATE Turkish_CI_AS,
    DEVREDEN    FLOAT,
    GIREN       FLOAT,
    CIKAN       FLOAT,
    BAKIYE      FLOAT,
    KUR			FLOAT,
    KUR_GIREN	FLOAT,
    KUR_CIKAN	FLOAT,
    KUR_BAKIYE  FLOAT)

  DECLARE @HRK_FIRMANO          INT
  DECLARE @HRK_TAR         DATETIME
  DECLARE @HRK_KASA_KOD    VARCHAR(30)
  DECLARE @HRK_PARABRM     VARCHAR(30)
  DECLARE @SIS_PARABRM     VARCHAR(30)
  DECLARE @HRK_KASA_AD     VARCHAR(70)
  DECLARE @HRK_DEVREDEN    FLOAT
  DECLARE @HRK_GIREN       FLOAT
  DECLARE @HRK_CIKAN       FLOAT
  DECLARE @HRK_BAKIYE      FLOAT
  
  DECLARE @HRK_KUR         FLOAT

/*---------------------------------------------------------------------------- */

 SELECT @SIS_PARABRM=sistem_parabrm from sistemtanim


 if @KOD<>''
 DECLARE M_HRK CURSOR FAST_FORWARD FOR
 SELECT KOD,AD,PARABRM FROM kasakart WHERE sil=0 AND KOD=@KOD
 

 if @KOD='' and (@FIRMANO=0)
 DECLARE M_HRK CURSOR FAST_FORWARD FOR
 SELECT KOD,AD,PARABRM FROM kasakart WHERE sil=0 


 if @KOD='' and (@FIRMANO>0)
 DECLARE M_HRK CURSOR FAST_FORWARD FOR
 SELECT KOD,AD,PARABRM FROM kasakart WHERE sil=0 
 and (firmano=@FIRMANO or firmano=0)


  OPEN M_HRK

   FETCH NEXT FROM M_HRK INTO
    @HRK_KASA_KOD,@HRK_KASA_AD,@HRK_PARABRM

   WHILE @@FETCH_STATUS = 0
   BEGIN
    
 /*---------------------------------------------------------------------------- */
  if @FIRMANO=0
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      h.tarih
      FROM kasahrk as h where h.kaskod=@HRK_KASA_KOD
      and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
      and h.sil=0
      group by h.tarih  order by h.tarih
      
  
    if @FIRMANO>0
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      h.tarih
      FROM kasahrk as h where (h.firmano=@FIRMANO or h.firmano=0) 
      and h.kaskod=@HRK_KASA_KOD
      and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
      and h.sil=0
      group by h.tarih  order by h.tarih
  
  
      
      

   OPEN CRS_HRK

   FETCH NEXT FROM CRS_HRK INTO
   @HRK_TAR

   WHILE @@FETCH_STATUS = 0
   BEGIN
   
   
   set @HRK_KUR=1

    if @HRK_PARABRM<>@SIS_PARABRM
    set @HRK_KUR=dbo.UDF_CAPRAZ_KUR (@HRK_TAR,@HRK_PARABRM,@SIS_PARABRM)


    INSERT @EKSTRE_TEMP
     SELECT @FIRMANO,'',@HRK_TAR,@HRK_KASA_KOD,@HRK_KASA_AD,
     DEVREDEN,GIREN,CIKAN,(DEVREDEN+GIREN-CIKAN),
     @HRK_KUR,GIREN*@HRK_KUR,CIKAN*@HRK_KUR,
     (DEVREDEN+GIREN-CIKAN)*@HRK_KUR
     
    FROM UDF_KASA_TAR_SONDURUM (@FIRMANO,@HRK_KASA_KOD,@HRK_TAR,@HRK_TAR)


    FETCH NEXT FROM CRS_HRK INTO
    @HRK_TAR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
 /*---------------------------------------------------------------------------- */
 


   FETCH NEXT FROM M_HRK INTO
   @HRK_KASA_KOD,@HRK_KASA_AD,@HRK_PARABRM
   END

   CLOSE M_HRK
   DEALLOCATE M_HRK
 
 
  update @EKSTRE_TEMP set firma_ad=dt.ad 
  from @EKSTRE_TEMP as t join 
  (select id,ad from Firma) dt on dt.id=t.firmano
 
 

  INSERT @TB_KASA_GUNLUK
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
