-- Function: dbo.UDF_POS_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.761826
================================================================================

CREATE FUNCTION [dbo].UDF_POS_HRK(
@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@POS_KOD VARCHAR(30),
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@SAAT1 VARCHAR(8),
@SAAT2 VARCHAR(8),
@ORDER VARCHAR(20),
@DEVIR  INT)
RETURNS
  @TB_POS_EKSTRE TABLE (
    Firmano     int,
    CARI_KOD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)   COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)   COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(30)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(30)   COLLATE Turkish_CI_AS,
    KRS_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
    KRS_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KRS_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK		INT,
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
    ISTHRK_ID   INT)
AS
BEGIN


  DECLARE @ONDA_HANE       INT
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)
  DECLARE @HRK_POS_KOD    VARCHAR(30)
  DECLARE @HRK_POS_UNVAN  VARCHAR(150)


  SET @KUM_BAKIYE = 0
  
  SELECT @ONDA_HANE=para_ondalik FROM sistemtanim

select @HRK_POS_UNVAN=poskart.ad from poskart
where kod=@POS_KOD

  /* Devir atanıyor */
  IF @DEVIR=1
   BEGIN
  IF @ORDER='tarih'
  begin
  INSERT @TB_POS_EKSTRE
    SELECT
      @firmano,
      @POS_KOD, /* POS_KOD */
      @HRK_POS_UNVAN, /* carı_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',
      '-','-','-',max(vadetar),0,0,0,0,0,
      ISNULL(SUM(round(giren,@ONDA_HANE)),0), /* BORC */
      ISNULL(SUM(round(cikan,@ONDA_HANE)),0), /* ALACAK */
      ISNULL(SUM(ROUND((giren-cikan),@ONDA_HANE)),0), /* BAKIYE */
      0,0,0,
      0,0,0,
      0,0,0,
      0,0      
    FROM poshrk
    WHERE PosIsle=1 and poskod=@POS_KOD and sil=0 and aktip in ('BK')
     AND tarih < @TARIH1
   END

  IF @ORDER='vadetar'
  begin
  INSERT @TB_POS_EKSTRE
    SELECT
      @firmano,
      @POS_KOD, /* POS_KOD */
      @HRK_POS_UNVAN, /* carı_UNVAN */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-','-','-','-',
      '-','-','-',max(vadetar),0,0,0,0,0,
      ISNULL(SUM(round(giren,@ONDA_HANE)),0), /* BORC */
      ISNULL(SUM(round(cikan,@ONDA_HANE)),0), /* ALACAK */
      ISNULL(SUM(ROUND((giren-cikan),@ONDA_HANE)),0), /* BAKIYE */
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM poshrk
    WHERE PosIsle=1 and poskod=@POS_KOD and sil=0 and aktip in ('BK')
     AND (vadetar < @TARIH1)
   END


    SELECT @KUM_BAKIYE = isnull(BAKIYE,0) FROM @TB_POS_EKSTRE
     if @KUM_BAKIYE=0
     delete from @TB_POS_EKSTRE
   END
     
     
     
  /* Hareketler işleniyor */
  /*---------------------------------------------------------------------------- */
   IF @ORDER='tarih'
    begin
     INSERT @TB_POS_EKSTRE
     SELECT
       @firmano,
       @POS_KOD,@HRK_POS_UNVAN,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,yertip,
      olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,
      varok,belrap_id,
      poshrkid,masterid,
      round(giren,@ONDA_HANE),
      round(cikan,@ONDA_HANE),
      round(giren-cikan,@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM poshrk
    WHERE PosIsle=1 and poskod=@POS_KOD and sil=0 and aktip in ('BK')
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND tarih >= @TARIH1 AND tarih <= @TARIH2
     ORDER BY tarih,saat
    END
  
     IF @ORDER='vadetar'
    begin
     INSERT @TB_POS_EKSTRE
     SELECT
       @firmano,
       @POS_KOD,@HRK_POS_UNVAN,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,yertip,
      olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,
      varok,belrap_id,
      poshrkid,masterid,
      round(giren,@ONDA_HANE),
      round(cikan,@ONDA_HANE),
      round(giren-cikan,@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM poshrk
    WHERE PosIsle=1 and poskod=@POS_KOD and sil=0 and aktip in ('BK')
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     and vadetar >= @TARIH1 AND vadetar <= @TARIH2
     ORDER BY vadetar,saat
    END
  
  
   update @TB_POS_EKSTRE set KRS_UNVAN=dt.AD
   FROM @TB_POS_EKSTRE AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KRS_TIP and dt.kod=t.KRS_KOD
   
    
   update @TB_POS_EKSTRE set KRS_KOD='-',KRS_UNVAN='-'
   WHERE (KRS_KOD is null)

  RETURN

END

================================================================================
