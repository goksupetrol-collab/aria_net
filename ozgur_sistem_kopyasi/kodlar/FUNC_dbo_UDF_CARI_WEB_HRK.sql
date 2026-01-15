-- Function: dbo.UDF_CARI_WEB_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.697811
================================================================================

CREATE FUNCTION [dbo].[UDF_CARI_WEB_HRK] (
@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(30),
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@SAAT1 VARCHAR(8),
@SAAT2 VARCHAR(8),
@ORDER  VARCHAR(20),
@DEVIR          INT)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)  COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK		INT,
    RAPID		INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)    COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)   COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,    
    YERAD       VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK		INT,
    RAPID		INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT)
    

  

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_PLAKA       VARCHAR(50)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_ISLTIPAD    VARCHAR(30)
  DECLARE @HRK_ISLHRKAD    VARCHAR(30)
  DECLARE @HRK_YERTIP      VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(30)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_ISLTIP      VARCHAR(10)
  DECLARE @HRK_ISLHRK      VARCHAR(10)
  DECLARE @HRK_VADETAR     DATETIME
  DECLARE @HRK_VARNO       FLOAT
  DECLARE @HRK_VAROK       INT
  DECLARE @HRK_RAPID       INT
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_MASID       FLOAT
  DECLARE @HRK_BORC        FLOAT
  DECLARE @HRK_ALACAK      FLOAT
  DECLARE @HRK_BAKIYE      FLOAT
  DECLARE @KUM_BAKIYE      FLOAT
  
  DECLARE @ONDA_HANE       INT

  SET @KUM_BAKIYE = 0
  
  
  select @ONDA_HANE=Para_Ondalik from sistemtanim


 select @HRK_CARI_UNVAN=gk.ad from Genel_Kart as gk
  where kod=@CARI_KOD and gk.cartp=@CARI_TIP

  /* Devir atanıyor */
  IF @DEVIR=1/*------------------- */
   BEGIN
  IF @ORDER='tarih'
  begin
  INSERT @EKSTRE_TEMP
    SELECT
      '',/*CARI TIP */
      '', /* CARI_KOD */
      @HRK_CARI_UNVAN, /* CARI_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      '', /*PLAKA */
      convert(VARCHAR(30),max(tarih),104)+' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',max(vadetar),0,0,0,0,0,
      0,/*ISNULL(SUM(borc),0), -- BORC */
      0,/*ISNULL(SUM(alacak),0), -- ALACAK */
      ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0) /* BAKIYE */
    FROM carihrk
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 AND (tarih < @TARIH1)  
    end

  IF @ORDER='vadetar'
  begin
  INSERT @EKSTRE_TEMP
    SELECT
      '',/*CARI TIP */
      '', /* CARI_KOD */
      @HRK_CARI_UNVAN, /* CARI_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      '', /*PLAKA */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',max(vadetar),0,0,0,0,0,
      0,/*ISNULL(SUM(borc),0), -- BORC */
      0,/*ISNULL(SUM(alacak),0), -- ALACAK */
      ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0) /* BAKIYE */
    FROM carihrk
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 AND (vadetar < @TARIH1)
 
    end
   
     SELECT @KUM_BAKIYE = isnull(BAKIYE,0) FROM @EKSTRE_TEMP

     if @KUM_BAKIYE=0
      delete from @EKSTRE_TEMP 
  
   
   END/*------------------------------- */


  IF @ORDER='tarih'
  begin
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,
      olususer,islmtip,islmhrk,vadetar,varno,
      varok,belrap_id,
      carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE
    FROM carihrk
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 AND (tarih >= @TARIH1 )
     AND (tarih <= @TARIH2)
    ORDER BY tarih,saat
   end

  IF @ORDER='vadetar'
  begin
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,olususer,islmtip,islmhrk,
      vadetar,varno,varok,belrap_id,carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE
    FROM carihrk
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 AND (vadetar >= @TARIH1)
     AND (vadetar <= @TARIH2)
    ORDER BY vadetar,saat
   end



  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
   @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
   @HRK_VARNO,@HRK_VAROK,@HRK_RAPID,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @KUM_BAKIYE = @KUM_BAKIYE + @HRK_BAKIYE

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
       @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
       @HRK_VARNO,@HRK_VAROK,@HRK_RAPID,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @KUM_BAKIYE

    FETCH NEXT FROM CRS_HRK INTO
      @HRK_CARI_TIP,@HRK_CARI_KOD, @HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
      @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
      @HRK_VARNO,@HRK_VAROK,@HRK_RAPID,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT CARI_TIP,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,KULAD,ISLTIP,ISLHRK,VADETAR,
    VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
