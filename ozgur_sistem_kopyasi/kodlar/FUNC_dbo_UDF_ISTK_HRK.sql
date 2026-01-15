-- Function: dbo.UDF_ISTK_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.731294
================================================================================

CREATE FUNCTION [dbo].UDF_ISTK_HRK(
@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@ISTK_KOD VARCHAR(30),
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@SAAT1 VARCHAR(8),
@SAAT2 VARCHAR(8),
@ORDER VARCHAR(20),
@DEVIR INT)
RETURNS
  @TB_ISTK_EKSTRE TABLE (
    Firmano     int,
    CARI_KOD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)   COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(30)  COLLATE Turkish_CI_AS,
    KRS_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
    KRS_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KRS_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK       INT,
    RAPID		INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8),
    FAT_ID      INT,
    FIS_ID      INT,
    IRS_ID      INT,
    MARSAT_ID	INT,
    SAYIM_ID    INT,
    REMOTE_ID	INT,
    KASAHRK_ID  INT,
    POSHRK_ID   INT,
    BANKAHRK_ID INT,
    CEK_ID		INT,
    ISTHRK_ID   INT    
    )
AS
BEGIN
 
 
  DECLARE @ONDA_HANE       INT
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)
  DECLARE @HRK_POS_KOD    VARCHAR(30)
  DECLARE @HRK_POS_UNVAN  VARCHAR(150) 


  select @ONDA_HANE=para_ondalik  from sistemtanim

  SET @KUM_BAKIYE = 0

  select @HRK_POS_UNVAN=ist.ad from istkart as ist
  where kod=@ISTK_KOD




  /* Devir atanıyor */
  IF @DEVIR=1
   BEGIN
  IF @ORDER='tarih'
  begin
  INSERT @TB_ISTK_EKSTRE
  (Firmano,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,
  ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,YERTIP,
  KULAD,ISLTIP,ISLHRK,
  KRS_TIP,KRS_KOD,KRS_UNVAN,
  VADETAR,VARNO,VAROK,
  RAPID,HRKID,MASID,BORC,ALACAK,BAKIYE,
  FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAYIM_ID,
  REMOTE_ID,KASAHRK_ID,POSHRK_ID,
  BANKAHRK_ID,CEK_ID,ISTHRK_ID)
    SELECT
      @firmano,
      @ISTK_KOD, /* ISTK_KOD */
      @HRK_POS_UNVAN, /* carı_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',
      '-','-','-',
      max(vadetar),0,0,0,0,0,
      ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
      ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
      ISNULL(SUM(ROUND( (borc-alacak),@ONDA_HANE)),0) ,/* BAKIYE */
       0,0,0,
       0,0,0,
       0,0,0,
       0,0
    FROM istkhrk
    WHERE istkkod=@ISTK_KOD and sil=0
     AND tarih < @TARIH1
    end

     IF @ORDER='vadetar'
     begin
     INSERT @TB_ISTK_EKSTRE
     (Firmano,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,
     ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,YERTIP,
     KULAD,ISLTIP,ISLHRK,
     KRS_TIP,KRS_KOD,KRS_UNVAN,
     VADETAR,VARNO,VAROK,
     RAPID,HRKID,MASID,BORC,ALACAK,BAKIYE,
     FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAYIM_ID,
     REMOTE_ID,KASAHRK_ID,POSHRK_ID,
     BANKAHRK_ID,CEK_ID,ISTHRK_ID)
     SELECT
      @firmano,
      @ISTK_KOD, /* ISTK_KOD */
      @HRK_POS_UNVAN, /* carı_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',
      '-','-','-',
      max(vadetar),0,0,0,0,0,
      ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
      ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
      ISNULL(SUM(ROUND( (borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
       0,0,0,
       0,0,0,
       0,0,0,
       0,0
    FROM istkhrk
    WHERE istkkod=@ISTK_KOD and sil=0
     AND vadetar < @TARIH1
    end

      SELECT @KUM_BAKIYE = isnull(BAKIYE,0) FROM @TB_ISTK_EKSTRE
     if @KUM_BAKIYE=0
     delete from @TB_ISTK_EKSTRE
   END
  /* Hareketler işleniyor */
  /*---------------------------------------------------------------------------- */
  
   IF @ORDER='tarih'
    begin
    INSERT @TB_ISTK_EKSTRE
    (Firmano,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,
     ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,YERTIP,
     KULAD,ISLTIP,ISLHRK,
     KRS_TIP,KRS_KOD,KRS_UNVAN,
     VADETAR,VARNO,VAROK,
     RAPID,HRKID,MASID,BORC,ALACAK,BAKIYE,
     FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAYIM_ID,
     REMOTE_ID,KASAHRK_ID,POSHRK_ID,
     BANKAHRK_ID,CEK_ID,ISTHRK_ID)
    SELECT
       @firmano,
       @ISTK_KOD,@HRK_POS_UNVAN,
       tarih,saat,belno,
       ack, /* AÇIKLAMA, */
       islmtipad,islmhrkad,yerad,yertip,
       olususer,islmtip,islmhrk,
       cartip,carkod,'',
       vadetar,varno,varok,belrap_id,
       istkhrkid,masterid,
       round(borc,@ONDA_HANE),
       round(alacak,@ONDA_HANE),
       round((borc-alacak),@ONDA_HANE) AS BAKIYE,
       0,0,0,
       0,0,0,
       0,0,0,
       0,0
    FROM istkhrk
    WHERE istkkod=@ISTK_KOD and sil=0
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND tarih >= @TARIH1 AND tarih <= @TARIH2
     ORDER BY tarih,saat
   end
  
  
    IF @ORDER='vadetar'
    begin
    INSERT @TB_ISTK_EKSTRE
    (Firmano,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,
     ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,YERTIP,
     KULAD,ISLTIP,ISLHRK,
     KRS_TIP,KRS_KOD,KRS_UNVAN,
     VADETAR,VARNO,VAROK,
     RAPID,HRKID,MASID,BORC,ALACAK,BAKIYE,
     FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAYIM_ID,
     REMOTE_ID,KASAHRK_ID,POSHRK_ID,
     BANKAHRK_ID,CEK_ID,ISTHRK_ID)
    SELECT
       @firmano,
       @ISTK_KOD,@HRK_POS_UNVAN,
       tarih,saat,belno,
       ack, /* AÇIKLAMA, */
       islmtipad,islmhrkad,yerad,yertip,
       olususer,islmtip,islmhrk,
       cartip,carkod,'',
       vadetar,varno,varok,belrap_id,
       istkhrkid,masterid,
       round(borc,@ONDA_HANE),
       round(alacak,@ONDA_HANE),
       round((borc-alacak),@ONDA_HANE) AS BAKIYE,
       0,0,0,
       0,0,0,
       0,0,0,
       0,0
    FROM istkhrk
    WHERE istkkod=@ISTK_KOD and sil=0
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     and vadetar >= @TARIH1 AND vadetar <= @TARIH2
     ORDER BY vadetar,saat
   end

   update @TB_ISTK_EKSTRE set KRS_UNVAN=dt.AD
   FROM @TB_ISTK_EKSTRE AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KRS_TIP and dt.kod=t.KRS_KOD
   
    
   update @TB_ISTK_EKSTRE set KRS_KOD='-',KRS_UNVAN='-'
   WHERE (KRS_KOD is null)


  RETURN

END

================================================================================
