-- Function: dbo.UDF_UDF_CARIFIS_BK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.772880
================================================================================

CREATE FUNCTION [dbo].UDF_UDF_CARIFIS_BK (@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@SAAT1 VARCHAR(8),
@SAAT2 VARCHAR(8),
@DEVIR INT)
RETURNS
    @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20) COLLATE Turkish_CI_AS,
    STOKKOD     VARCHAR(20) COLLATE Turkish_CI_AS,
    STOKAD      VARCHAR(50) COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BFIYAT      FLOAT,
    PLAKA       VARCHAR(20) COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8))
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD VARCHAR(20)     COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)   COLLATE Turkish_CI_AS,
    BELGENO    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOKKOD     VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOKAD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BFIYAT      FLOAT,
    PLAKA       VARCHAR(20)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8))

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_YKNO        VARCHAR(20)
  DECLARE @HRK_STOKKOD     VARCHAR(20)
  DECLARE @HRK_STOKAD      VARCHAR(50)
  DECLARE @HRK_MIKTAR      FLOAT
  DECLARE @HRK_BFIYAT      FLOAT
  DECLARE @HRK_PLAKA       VARCHAR(20)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_ISLTIPAD    VARCHAR(30)
  DECLARE @HRK_ISLHRKAD    VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(30)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_ISLTIP      VARCHAR(10)
  DECLARE @HRK_ISLHRK      VARCHAR(10)
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_MASID       FLOAT
  DECLARE @HRK_BORC        DECIMAL(18,8)
  DECLARE @HRK_ALACAK      DECIMAL(18,8)
  DECLARE @HRK_BAKIYE      DECIMAL(18,8)
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)

  SET @KUM_BAKIYE = 0

select @HRK_CARI_UNVAN=ck.ad from Genel_Kart as ck
where kod=@CARI_KOD and ck.cartp=@CARI_TIP

  /* Devir atanıyor */
  IF @DEVIR=1
   BEGIN
  INSERT @EKSTRE_TEMP
    SELECT
      '',/*CARI TIP */
      @CARI_KOD, /* CARI_KOD */
      @HRK_CARI_UNVAN, /* CARI_UNVAN */
      @TARIH1,
      @SAAT1,
      'DEVİR', /* BELGE NO */
      '',/*YKNO */
      '',/*STOKKOD */
      '',/*STOKAD */
      0,/*MİKTAR */
      0,/*BFIYAT */
      '', /*PLAKA */
      CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-',0,0,
      ISNULL(SUM(CASE WHEN borc>0 THEN borc ELSE 0 END),0), /* BORC */
      ISNULL(SUM(CASE WHEN alacak>0 THEN alacak ELSE 0 END),0), /* ALACAK */
      ISNULL(SUM((borc-alacak)),0) 
     FROM carihrk
     WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and islmhrk not in ('CAK','FATVERSAT')
     and sil=0  AND (tarih < @TARIH1 OR (tarih = @TARIH1 AND saat < @SAAT1))
     
      SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP
  
     
  /* veresiye hareketlerinden gelen bakiye alınıyor */
  SELECT
    @HRK_BORC   = ISNULL(SUM(case when fistip='FISVERSAT' THEN toptut else 0 end ),0),
    @HRK_ALACAK = ISNULL(SUM(case when fistip='FISALCSAT' THEN toptut else 0 end),0),
    @HRK_BAKIYE = ISNULL(SUM(case when fistip='FISVERSAT' then toptut else -toptut end  ),0)
  FROM veresimas
  WHERE cartip=@CARI_TIP and carkod=@CARI_KOD 
  and sil=0  AND (tarih < @TARIH1 OR (tarih = @TARIH1 AND saat < @SAAT1))

  /* Faturalardan gelen bakiye hareketlerden gelen bakiyeye ekleniyor */
  UPDATE @EKSTRE_TEMP SET
    BORC    = BORC    + @HRK_BORC,
    ALACAK  = ALACAK  + @HRK_ALACAK,
    BAKIYE  = BAKIYE  + @HRK_BAKIYE

  /* Kümülatif bakiye için kullanılacak değişkene devir bakiyesi atanıyor. */
   SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP
  END

  /* Hareketler işleniyor */
  /*---------------------------------------------------------------------------- */

  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    /* Cari Fişlerden gelen harektler */
    SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,belno,
       '',/*YKNO */
       '',/*STOKKOD */
       '',/*STOKAD */
       0,/*MİKTAR */
       0,/*BFIYAT */
       '', /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,olususer,islmtip,islmhrk,carhrkid,masterid,
      borc,
      alacak,
      borc-alacak AS BAKIYE
    FROM carihrk
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and islmhrk not in ('CAK','FATVERSAT')
     and sil=0 AND (tarih > @TARIH1 OR (tarih = @TARIH1 AND saat > @SAAT1))
     AND (tarih < @TARIH2 OR (tarih = @TARIH2 AND saat < @SAAT2))
     UNION
    /* veresiye Hareketleri */
     SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,
       seri+cast([no] as varchar),
       veresimas.ykno,/*YKNO */
       stkod,
       stokkart.ad,
       mik,
       brmfiy,/*BFIYAT */
       plaka, /*PLAKA */
       ack, /* AÇIKLAMA, */
       fisad,fisad,yerad,veresihrk.olususer,'-',fistip,0,0,
       CASE WHEN fistip='FISVERSAT' THEN  brmfiy*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN brmfiy*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*brmfiy*mik else brmfiy*mik end AS BAKIYE
    FROM veresihrk inner join veresimas on veresihrk.verid=veresimas.verid
    and veresimas.sil=0 and veresihrk.sil=0 inner join stokkart on stokkart.kod=veresihrk.stkod
    and stokkart.tip=veresihrk.stktip
     where cartip=@CARI_TIP and carkod=@CARI_KOD /*and aktip='BK' */
     AND (tarih > @TARIH1 OR (tarih = @TARIH1 AND saat > @SAAT1))
     AND (tarih < @TARIH2 OR (tarih = @TARIH2 AND saat < @SAAT2))

    ORDER BY tarih

  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
   @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_PLAKA,@HRK_ACIKLAMA,
   @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @KUM_BAKIYE = @KUM_BAKIYE + @HRK_BAKIYE

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
   @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_PLAKA,@HRK_ACIKLAMA,
       @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @KUM_BAKIYE

    FETCH NEXT FROM CRS_HRK INTO
      @HRK_CARI_TIP,@HRK_CARI_KOD, @HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
   @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_PLAKA,@HRK_ACIKLAMA,
      @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT CARI_TIP,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,YKNO,STOKKOD,
   STOKAD,MIKTAR,BFIYAT,PLAKA,ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,KULAD,ISLTIP,ISLHRK,
   HRKID,MASID,BORC,ALACAK,BAKIYE FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
