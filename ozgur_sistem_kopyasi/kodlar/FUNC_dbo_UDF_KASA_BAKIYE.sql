-- Function: dbo.UDF_KASA_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.732818
================================================================================

CREATE FUNCTION [dbo].UDF_KASA_BAKIYE (
@FIRMANO		    int,
@KASA_KOD 			VARCHAR(20),
@TARIH1 			DATETIME,
@TARIH2 			DATETIME,
@silin 				varchar(10))
RETURNS
  @TB_KASA_EKSTRE TABLE (
    Firmano       int,
    Firma_Ad       VARCHAR(150) COLLATE Turkish_CI_AS,
    KASA_BRM       VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_KOD       VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_AD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    KASA_TARIH     DATETIME,
    KASA_ISLEM     VARCHAR(30)  COLLATE Turkish_CI_AS,
    KASA_BELGENO   VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_ACIKLAMA  VARCHAR(100) COLLATE Turkish_CI_AS,
    KASA_UNVAN     VARCHAR(150)  COLLATE Turkish_CI_AS,
    GIREN          FLOAT,
    CIKAN          FLOAT,
    BAKIYE         FLOAT,
    KUR			   FLOAT,
    KUR_GIREN	   FLOAT,
    KUR_CIKAN	   FLOAT,
    KUR_BAKIYE     FLOAT  )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    Firmano       int,
    Firma_Ad       VARCHAR(150) COLLATE Turkish_CI_AS,
    KASA_BRM       VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_KOD       VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_AD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    KASA_TARIH     DATETIME,
    KASA_ISLEM     VARCHAR(30)   COLLATE Turkish_CI_AS,
    KASA_BELGENO   VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_ACIKLAMA  VARCHAR(100) COLLATE Turkish_CI_AS,
    KASA_UNVAN     VARCHAR(150)  COLLATE Turkish_CI_AS,
    GIREN          FLOAT,
    CIKAN          FLOAT,
    BAKIYE         FLOAT,
    KUR			   FLOAT,
    KUR_GIREN	   FLOAT,
    KUR_CIKAN	   FLOAT,
    KUR_BAKIYE     FLOAT )

  DECLARE @HRK_FIRMANO          INT
  DECLARE @HRK_KASA_BRM    		VARCHAR(20)
  DECLARE @HRK_KASA_KOD    		VARCHAR(20)
  DECLARE @HRK_KASA_AD     		VARCHAR(50)
  DECLARE @HRK_TARIH       		DATETIME
  DECLARE @HRK_KASA_ISLEM  		VARCHAR(30)
  DECLARE @HRK_KASA_BELGENO	 	VARCHAR(20)
  DECLARE @HRK_KASA_ACIKLAMA 	VARCHAR(100)
  DECLARE @HRK_KASA_UNVAN    	VARCHAR(150)
  DECLARE @HRK_GIREN          	FLOAT
  DECLARE @HRK_CIKAN          	FLOAT
  DECLARE @HRK_BAKIYE         	FLOAT
  DECLARE @HRK_GENELTOP        	FLOAT
  
  DECLARE @HRK_PARABRM     VARCHAR(30)
 
  DECLARE @ONDA_HANE           	INT 
  
  DECLARE @HRK_KUR         FLOAT
  
 DECLARE @SIS_PARABRM     VARCHAR(30)
  
  
  SELECT @ONDA_HANE=para_ondalik from sistemtanim

  SELECT @SIS_PARABRM=sistem_parabrm from sistemtanim


  SELECT @HRK_PARABRM=PARABRM from KASAKART WHERE KOD=@KASA_KOD
  
 
 
 
  /*devir atanıyorrrrr..... */
  /*
  SELECT @HRK_GIREN=isnull(sum(round(giren,@ONDA_HANE)),0),
  @HRK_CIKAN=isnull(sum(round(cikan,@ONDA_HANE)),0),
  @HRK_GENELTOP=isnull(sum(giren-cikan),0) from kasahrk as h
  where h.kaskod=@KASA_KOD
  and h.sil=0
  --and ((h.varno>0 and h.varok=1) or (h.varno=0))
  and h.tarih < @TARIH1
  */
  
  set  @TARIH1=@TARIH1-1
 
  SELECT @HRK_GIREN=isnull(sum(round(GIREN,@ONDA_HANE)),0),
  @HRK_CIKAN=isnull(sum(round(CIKAN,@ONDA_HANE)),0),
  @HRK_GENELTOP=isnull(sum(GIREN-CIKAN),0) 
  FROM UDF_KASA_TAR_SONDURUM (@FIRMANO,@KASA_KOD,0,@TARIH1)
  
  
  set @HRK_KUR=dbo.UDF_CAPRAZ_KUR 
   (@TARIH1,@HRK_PARABRM,@SIS_PARABRM)
  
  
  
   set @TARIH1=@TARIH1+1 
  
  
  
  
  INSERT @EKSTRE_TEMP
   SELECT @FIRMANO,'',k.parabrm,k.kod,k.ad,
   @TARIH1,'DEVİR','','DÜNDEN DEVİR','',
   @HRK_GIREN,@HRK_CIKAN,@HRK_GENELTOP,
   @HRK_KUR,
   @HRK_GIREN*@HRK_KUR,@HRK_CIKAN*@HRK_KUR,@HRK_GENELTOP*@HRK_KUR
   FROM kasakart as k where k.KOD=@KASA_KOD
  
  
    DECLARE KASA_HRK CURSOR FAST_FORWARD FOR
    select k.Firmano,k.parabrm,k.kaskod,k.kasaad,k.tarih,k.islmhrkad,k.belno,k.ack,
    k.unvan,k.giren,k.cikan
    from UDF_KASA_GENEL_HRK (@FIRMANO,@KASA_KOD,@TARIH1,@TARIH2,@silin) as k
    order by k.tarih,k.saat
    OPEN KASA_HRK

  FETCH NEXT FROM KASA_HRK INTO
   @FIRMANO,@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_TARIH,@HRK_KASA_ISLEM,@HRK_KASA_BELGENO,
   @HRK_KASA_ACIKLAMA,@HRK_KASA_UNVAN,@HRK_GIREN,@HRK_CIKAN

  WHILE @@FETCH_STATUS = 0
  BEGIN
  
   set @HRK_KUR=dbo.UDF_CAPRAZ_KUR 
   (@HRK_TARIH,@HRK_KASA_BRM,@SIS_PARABRM)
  
  
  
    SET @HRK_GENELTOP=@HRK_GENELTOP+@HRK_GIREN-@HRK_CIKAN

    INSERT @EKSTRE_TEMP
      SELECT
       @FIRMANO,'',@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_TARIH,@HRK_KASA_ISLEM,@HRK_KASA_BELGENO,
       @HRK_KASA_ACIKLAMA,@HRK_KASA_UNVAN,@HRK_GIREN,@HRK_CIKAN,@HRK_GENELTOP,
       @HRK_KUR,@HRK_GIREN*@HRK_KUR,@HRK_CIKAN*@HRK_KUR,@HRK_GENELTOP*@HRK_KUR
       
    FETCH NEXT FROM KASA_HRK INTO
    @FIRMANO,@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_TARIH,@HRK_KASA_ISLEM,@HRK_KASA_BELGENO,
   @HRK_KASA_ACIKLAMA,@HRK_KASA_UNVAN,@HRK_GIREN,@HRK_CIKAN
  END

  CLOSE KASA_HRK
  DEALLOCATE KASA_HRK

  /*---------------------------------------------------------------------------- */

      update @TB_KASA_EKSTRE set firma_ad=dt.ad
      from @TB_KASA_EKSTRE as t join
      (select id,ad from Firma) dt on dt.id=t.firmano



  INSERT @TB_KASA_EKSTRE
    SELECT * FROM @EKSTRE_TEMP 

  RETURN

END

================================================================================
