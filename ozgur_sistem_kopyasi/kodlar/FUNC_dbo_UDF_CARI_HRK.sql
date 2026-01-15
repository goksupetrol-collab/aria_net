-- Function: dbo.UDF_CARI_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.694529
================================================================================

CREATE FUNCTION UDF_CARI_HRK (
@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(30),
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@SAAT1 VARCHAR(8),
@SAAT2 VARCHAR(8),
@ORDER  VARCHAR(20),
@DEVIR          INT,
@AVANS          INT)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    Firmano     int,
    CARI_TIP    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50)  COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(50)  COLLATE Turkish_CI_AS,
    KRS_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
    KRS_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KRS_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK		INT,
    RAPID		INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT,
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
    ISTHRK_ID   INT,
    DEVIR		INT)
AS
BEGIN


  DECLARE @KUM_BAKIYE      FLOAT
  DECLARE @HRK_CARI_TIP    VARCHAR(30)
  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(150)
  
  DECLARE @ONDA_HANE       INT

  SET @KUM_BAKIYE = 0
  
  
  set @TARIH1=(@TARIH1+cast(@SAAT1 as datetime)) 
  set @TARIH2=(@TARIH2+cast(@SAAT2 as datetime)) 
  
  select @ONDA_HANE=Para_Ondalik from sistemtanim


 select @HRK_CARI_UNVAN=gk.ad from Genel_Kart as gk
  where kod=@CARI_KOD and gk.cartp=@CARI_TIP

  /* Devir atanıyor */
  
 
    IF @DEVIR=1/*------------------- */
    BEGIN
      
      IF @ORDER='tarih' and @firmano=0
      begin
        INSERT @TB_CARI_EKSTRE
       (Firmano,CARI_TIP,CARI_KOD,
        CARI_UNVAN,TARIH,SAAT,BELGENO,
        PLAKA,ACIKLAMA,
        ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
        KULAD,ISLTIP,ISLHRK,
        KRS_TIP,KRS_KOD,KRS_UNVAN,
        VADETAR,VARNO,VAROK,RAPID,HRKID,
        MASID,BORC,ALACAK,BAKIYE,
        FAT_ID,FIS_ID,IRS_ID,
        MARSAT_ID,SAYIM_ID,REMOTE_ID,
        KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
        CEK_ID,ISTHRK_ID,DEVIR)
        SELECT
          @firmano,    
          @CARI_TIP,/* CARI TIP */
          @CARI_KOD, /*CARI_KOD  */
          @HRK_CARI_UNVAN, /* CARI_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          '', /*PLAKA */
          convert(VARCHAR(30),max(tarih),104)+' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(borc),0), /* BORC */
          ISNULL(SUM(alacak),0), /* ALACAK */
          ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0,1
        FROM carihrk as h  with (nolock)
        WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
         and sil=0 and isnull(CariAvans,0)=@AVANS 
         AND (h.tarih+cast(h.saat as datetime)) < @TARIH1
       end
       
       
      IF @ORDER='tarih' and @firmano>0
      begin
        INSERT @TB_CARI_EKSTRE
       (Firmano,CARI_TIP,CARI_KOD,
        CARI_UNVAN,TARIH,SAAT,BELGENO,
        PLAKA,ACIKLAMA,
        ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
        KULAD,ISLTIP,ISLHRK,
        KRS_TIP,KRS_KOD,KRS_UNVAN,
        VADETAR,VARNO,VAROK,RAPID,HRKID,
        MASID,BORC,ALACAK,BAKIYE,
        FAT_ID,FIS_ID,IRS_ID,
        MARSAT_ID,SAYIM_ID,REMOTE_ID,
        KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
        CEK_ID,ISTHRK_ID,DEVIR)
        SELECT
          @firmano,    
          @CARI_TIP,/* CARI TIP */
          @CARI_KOD, /*CARI_KOD  */
          @HRK_CARI_UNVAN, /* CARI_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          '', /*PLAKA */
          convert(VARCHAR(30),max(tarih),104)+' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',
          max(vadetar),0,0,0,0,0,
          ISNULL(SUM(borc),0), /* BORC */
          ISNULL(SUM(alacak),0), /* ALACAK */
          ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0,1
        FROM carihrk as h with (nolock)
        WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
         and Firmano in (0,@firmano)
         and sil=0 and isnull(CariAvans,0)=@AVANS 
         AND (h.tarih+cast(h.saat as datetime)) < @TARIH1
       end 
       
       
       

      IF @ORDER='vadetar' and @firmano=0
      begin
        INSERT @TB_CARI_EKSTRE
        (Firmano,CARI_TIP,CARI_KOD,
        CARI_UNVAN,TARIH,SAAT,BELGENO,
        PLAKA,ACIKLAMA,
        ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
        KULAD,ISLTIP,ISLHRK,
        KRS_TIP,KRS_KOD,KRS_UNVAN,
        VADETAR,VARNO,VAROK,RAPID,HRKID,
        MASID,BORC,ALACAK,BAKIYE,
        FAT_ID,FIS_ID,IRS_ID,
        MARSAT_ID,SAYIM_ID,REMOTE_ID,
        KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
        CEK_ID,ISTHRK_ID,DEVIR)
         SELECT 
          @firmano,
          @CARI_TIP,/* CARI TIP */
          @CARI_KOD, /*CARI_KOD  */
          @HRK_CARI_UNVAN, /* CARI_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          '', /*PLAKA */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',max(vadetar),0,0,0,0,0,
          ISNULL(SUM(borc),0), /* BORC */
          ISNULL(SUM(alacak),0), /* ALACAK */
          ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0,1
        FROM carihrk as h  with (nolock)
        WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
         and sil=0 and isnull(CariAvans,0)=@AVANS 
         AND vadetar < @TARIH1
     
     end
     
     
      IF @ORDER='vadetar' and @firmano>0
      begin
        INSERT @TB_CARI_EKSTRE
        (Firmano,CARI_TIP,CARI_KOD,
        CARI_UNVAN,TARIH,SAAT,BELGENO,
        PLAKA,ACIKLAMA,
        ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
        KULAD,ISLTIP,ISLHRK,
        KRS_TIP,KRS_KOD,KRS_UNVAN,
        VADETAR,VARNO,VAROK,RAPID,HRKID,
        MASID,BORC,ALACAK,BAKIYE,
        FAT_ID,FIS_ID,IRS_ID,
        MARSAT_ID,SAYIM_ID,REMOTE_ID,
        KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
        CEK_ID,ISTHRK_ID,DEVIR)
         SELECT 
          @firmano,
          @CARI_TIP,/* CARI TIP */
          @CARI_KOD, /*CARI_KOD  */
          @HRK_CARI_UNVAN, /* CARI_UNVAN */
          max(tarih),
          @SAAT1,
          'DEVİR', /* BELGE NO */
          '', /*PLAKA */
          CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
          '-','-','-','-','-','-','-',
          '-','-','-',max(vadetar),0,0,0,0,0,
          ISNULL(SUM(borc),0), /* BORC */
          ISNULL(SUM(alacak),0), /* ALACAK */
          ISNULL(SUM(round((borc-alacak),@ONDA_HANE)),0), /* BAKIYE */
          0,0,0,
          0,0,0,
          0,0,0,
          0,0,1
        FROM carihrk with (nolock)
        WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
         and Firmano in (0,@firmano)
         and sil=0 and isnull(CariAvans,0)=@AVANS AND vadetar < @TARIH1
     
     end
     
     
     
     
   
     SELECT @KUM_BAKIYE = isnull(BAKIYE,0) FROM @TB_CARI_EKSTRE

     if @KUM_BAKIYE=0
      delete from @TB_CARI_EKSTRE 
  
   
   END/*-------Devir */


  IF @ORDER='tarih' and @firmano=0
  begin
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    VADETAR,VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,
      olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,
      varok,belrap_id,
      carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 and isnull(CariAvans,0)=@AVANS
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND ( (h.tarih+cast(h.saat as datetime))  >= @TARIH1 )
     AND ( (h.tarih+cast(h.saat as datetime)) <= @TARIH2)
    ORDER BY tarih,saat
   end
   
   
  IF @ORDER='tarih' and @firmano>0
  begin
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    VADETAR,VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,
      olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,
      varok,belrap_id,
      carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h  with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 and isnull(CariAvans,0)=@AVANS 
     and Firmano in (0,@firmano)
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND ( (h.tarih+cast(h.saat as datetime)) >= @TARIH1 )
     AND ( (h.tarih+cast(h.saat as datetime)) <= @TARIH2)
    ORDER BY tarih,saat
   end

   
   

  IF @ORDER='vadetar' and @Firmano=0
  begin
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    VADETAR,
    VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,varok,belrap_id,carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0 and isnull(CariAvans,0)=@AVANS
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND (vadetar >= @TARIH1)
     AND (vadetar <= @TARIH2)
    ORDER BY vadetar,saat
   end



  IF @ORDER='vadetar' and @Firmano>0
  begin
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    VADETAR,
    VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,olususer,islmtip,islmhrk,
      Karsi_KartTip,Karsi_KartKod,'',
      vadetar,varno,varok,belrap_id,carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and sil=0  and isnull(CariAvans,0)=@AVANS
     and Firmano in (0,@firmano)
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND (vadetar >= @TARIH1)
     AND (vadetar <= @TARIH2)
    ORDER BY vadetar,saat
   end


  



   update @TB_CARI_EKSTRE set KRS_UNVAN=dt.AD
   FROM @TB_CARI_EKSTRE AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KRS_TIP and dt.kod=t.KRS_KOD
   
    
   update @TB_CARI_EKSTRE set KRS_KOD='-',KRS_UNVAN='-'
   WHERE (KRS_KOD is null)




   RETURN

END

================================================================================
