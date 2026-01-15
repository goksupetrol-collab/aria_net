-- Function: dbo.UDF_BANKA_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.687657
================================================================================

CREATE FUNCTION [dbo].UDF_BANKA_HRK
(@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@BANK_KOD 		VARCHAR(20),
@TARIH1 		DATETIME,
@TARIH2 		DATETIME,
@SAAT1 			VARCHAR(8),
@SAAT2 			VARCHAR(8),
@ORDER 			VARCHAR(20),
@DEVIR 			INT)
RETURNS
  @TB_BANK_EKSTRE TABLE (
    Firmano     int,
    Firma_Ad    VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(30)  COLLATE Turkish_CI_AS,
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
  
  DECLARE @HRK_BANK_KOD    VARCHAR(30)
  DECLARE @HRK_BANK_UNVAN  VARCHAR(150)
 
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)
  
  DECLARE @ONDA_HANE       INT

  SET @KUM_BAKIYE = 0
  
  
  select @ONDA_HANE=Para_Ondalik from sistemtanim

  select @HRK_BANK_UNVAN=AD from bankakart 
    where kod=@BANK_KOD

  /* Devir atanıyor */
  IF @DEVIR=1
   BEGIN
      IF @ORDER='tarih'
      begin
      
      if @firmano=0
      INSERT @TB_BANK_EKSTRE
        SELECT @firmano,'',
          @BANK_KOD, /* BANK_KOD */
          @HRK_BANK_UNVAN, /* BANK_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
          ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
          ISNULL(SUM( round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0
        FROM bankahrk
        WHERE bankod=@BANK_KOD and sil=0
         AND tarih < @TARIH1
        
         if @firmano>0
          INSERT @TB_BANK_EKSTRE
           SELECT
           @firmano,'',
          @BANK_KOD, /* BANK_KOD */
          @HRK_BANK_UNVAN, /* BANK_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
          ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
          ISNULL(SUM( round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0
        FROM bankahrk
        WHERE (firmano=@firmano or firmano=0 ) and bankod=@BANK_KOD and sil=0
         AND tarih < @TARIH1
        
    end

      IF @ORDER='vadetar'
      begin
      
      if @firmano=0
      INSERT @TB_BANK_EKSTRE
        SELECT
          @firmano,'',
          @BANK_KOD, /* BANK_KOD */
          @HRK_BANK_UNVAN, /* BANK_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
          ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
          ISNULL(SUM( round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0
        FROM bankahrk
        WHERE bankod=@BANK_KOD and sil=0
         AND vadetar < @TARIH1
         
         
         
        if @firmano>0
        INSERT @TB_BANK_EKSTRE
         SELECT
           @firmano,'',
          @BANK_KOD, /* BANK_KOD */
          @HRK_BANK_UNVAN, /* BANK_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(round(borc,@ONDA_HANE)),0), /* BORC */
          ISNULL(SUM(round(alacak,@ONDA_HANE)),0), /* ALACAK */
          ISNULL(SUM( round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0
        FROM bankahrk
        WHERE  (firmano=@firmano or firmano=0 ) and bankod=@BANK_KOD and sil=0
         AND vadetar < @TARIH1  
       end

     SELECT @KUM_BAKIYE = isnull(BAKIYE,0) FROM @TB_BANK_EKSTRE
     if @KUM_BAKIYE=0
      delete from @TB_BANK_EKSTRE
   END



  IF @ORDER='tarih'
  begin
  if @firmano=0
   INSERT @TB_BANK_EKSTRE
    SELECT
       isnull(firmano,0),'',
       @BANK_KOD,@HRK_BANK_UNVAN,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,yertip,olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,
      varno,varok,belrap_id,bankhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      round((borc-alacak),@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM bankahrk
    WHERE bankod=@BANK_KOD and  sil=0
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND tarih >= @TARIH1 AND tarih <= @TARIH2
     ORDER BY tarih,saat
     
    if @firmano>0
   INSERT @TB_BANK_EKSTRE
    SELECT
       isnull(firmano,0),'',
       @BANK_KOD,@HRK_BANK_UNVAN,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,yertip,olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',vadetar,
      varno,varok,belrap_id,bankhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      round((borc-alacak),@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM bankahrk
    WHERE  (firmano=@firmano or firmano=0 ) and bankod=@BANK_KOD and  sil=0
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND tarih >= @TARIH1 AND tarih <= @TARIH2
     ORDER BY tarih,saat 
     
     
     
     
   end
   
   IF @ORDER='vadetar'
  begin
   if @firmano=0
   INSERT @TB_BANK_EKSTRE
    SELECT
       isnull(firmano,0),'',
       @BANK_KOD,@HRK_BANK_UNVAN,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,yertip,olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',vadetar,
      varno,varok,belrap_id,bankhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      round((borc-alacak),@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM bankahrk
    WHERE bankod=@BANK_KOD and  sil=0
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     and vadetar >= @TARIH1 AND vadetar <= @TARIH2
     ORDER BY vadetar,saat
     
     if @firmano>0
     INSERT @TB_BANK_EKSTRE
      SELECT
       isnull(firmano,0),'',
       @BANK_KOD,@HRK_BANK_UNVAN,
       tarih,saat,belno,
       ack, /* AÇIKLAMA, */
       islmtipad,islmhrkad,yerad,yertip,olususer,islmtip,islmhrk,
       Karsi_KartTip,Karsi_KartKod,'',vadetar,
       varno,varok,belrap_id,bankhrkid,masterid,
       round(borc,@ONDA_HANE),
       round(alacak,@ONDA_HANE),
       round((borc-alacak),@ONDA_HANE) AS BAKIYE,
      0,0,0,
      0,0,0,
      0,0,0,
      0,0
    FROM bankahrk
    WHERE  (firmano=@firmano or firmano=0 ) and bankod=@BANK_KOD and  sil=0
    and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     and vadetar >= @TARIH1 AND vadetar <= @TARIH2
     ORDER BY vadetar,saat 
     
     
   end
   
  
   
  update @TB_BANK_EKSTRE set KRS_UNVAN=dt.AD
   FROM @TB_BANK_EKSTRE AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KRS_TIP and dt.kod=t.KRS_KOD
   
    
   update @TB_BANK_EKSTRE set KRS_KOD='-',KRS_UNVAN='-'
   WHERE (KRS_KOD is null) 
   
  
  RETURN

END

================================================================================
