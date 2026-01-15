-- Function: dbo.UDF_STOK_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.769858
================================================================================

CREATE FUNCTION [dbo].UDF_STOK_HRK (
@FIRMANO	      INT,
@HRK_KRITER       VARCHAR(4000),
@DEPO_KOD         VARCHAR(50),
@STOK_TIP         VARCHAR(20),
@STOK_KOD         VARCHAR(30),
@ALSATTIP         INT,
@STOK_DEPKOD      VARCHAR(30),
@TARIH1 		  DATETIME,
@TARIH2 		  DATETIME,
@SAAT1 			  VARCHAR(10),
@SAAT2 			  VARCHAR(10),
@DEVIR 			  INT)
RETURNS
  @TB_STOK_HRK TABLE (
    id          int,
    FIRMANO     INT,
    STOK_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100) COLLATE Turkish_CI_AS,
    STOK_BARKOD VARCHAR(30)  COLLATE Turkish_CI_AS, 
    DEPO_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    DEPO_AD     VARCHAR(100) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(10)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(20)   COLLATE Turkish_CI_AS,
    KRS_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
    KRS_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KRS_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS,
    ISLID       FLOAT,
    BRMFIYKDVLI FLOAT,
    KDVYUZ      FLOAT,
    VARNO       FLOAT,
    GIREN       DECIMAL(18,8),
    CIKAN       DECIMAL(18,8),
    KALAN       DECIMAL(18,8),
    RAP_ID      INT DEFAULT 0,
    FIS_ID      INT,
    FAT_ID      INT,
    IRS_ID      INT,
    MARSAT_ID   INT,
    SAY_ID      INT,
    REMOTE_ID   INT)
AS
BEGIN
  
  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_STOK_KOD    VARCHAR(30)
  DECLARE @HRK_STOK_AD     VARCHAR(100)
  DECLARE @HRK_STOK_BARKOD VARCHAR(30)
  DECLARE @KUM_KALAN       DECIMAL(18,8)
  
  DECLARE @ONDA_HANE       INT
  

  SET @KUM_KALAN = 0

 select @HRK_STOK_AD=k.ad,
 @HRK_STOK_BARKOD=K.BARKOD from stokkart as k
  where k.kod=@STOK_KOD 
  and k.tip=@STOK_TIP

 SET @ONDA_HANE=2

  SELECT @ONDA_HANE=isnull(Ondalik_Hane,2) from Stk_Tip  where kod=@STOK_TIP

  /* Devir atanıyor */
  IF @DEVIR=1
   BEGIN

    IF @ALSATTIP=0 /*TUMU */
     INSERT @TB_STOK_HRK (id,FIRMANO,
     STOK_TIP,STOK_KOD,STOK_AD,
     STOK_BARKOD,DEPO_KOD,DEPO_AD,
     TARIH,SAAT,BELGENO,ACIKLAMA,
     ISLTIPAD,YERAD,KULAD,ISLTIP,
     KRS_TIP,KRS_KOD,KRS_UNVAN,
     ISLID,BRMFIYKDVLI,
     KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
     FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
     REMOTE_ID)
     SELECT
      0,/*id */
      @FIRMANO, 
      '',/*STOK TIP */
      @STOK_KOD, /* STOK_KOD */
      @HRK_STOK_AD, /* STOK_AD */
      @HRK_STOK_BARKOD,
      '-', /* STOK_DEPO */
      '-',/*DEPOKOD */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-',
      '-','-','-',
      0,0,0,0,
      ISNULL(SUM(round(giren,@ONDA_HANE)),0), /* giren */
      ISNULL(SUM(round(cikan,@ONDA_HANE)),0), /* cikan */
      ISNULL(SUM( round((giren-cikan),@ONDA_HANE) ),0), /* kalan */
      0,0,0,0,0,0
    FROM stkhrk with (nolock) 
    WHERE stktip=@STOK_TIP and stkod=@STOK_KOD and sil=0
    and depkod in (select * from Depo_Kodin_str(@DEPO_KOD) )
    AND tarih < @TARIH1
    
  IF @ALSATTIP=1 /*GIRISLER */
   INSERT @TB_STOK_HRK (id,FIRMANO,
    STOK_TIP,STOK_KOD,STOK_AD,
    STOK_BARKOD,DEPO_KOD,DEPO_AD,
    TARIH,SAAT,BELGENO,ACIKLAMA,
    ISLTIPAD,YERAD,KULAD,ISLTIP,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    ISLID,BRMFIYKDVLI,
    KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
    FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
    REMOTE_ID)
    SELECT
      0,/*id */
      @FIRMANO,
      '',/*STOK TIP */
      @STOK_KOD, /* STOK_KOD */
      @HRK_STOK_AD, /* STOK_AD */
      @HRK_STOK_BARKOD,
      '-', /* STOK_DEPO */
      '-',/*DEPOKOD */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-',
      '-','-','-',0,0,0,0,
      ISNULL(SUM(round(giren,@ONDA_HANE)),0), /* giren */
      ISNULL(SUM(round(cikan,@ONDA_HANE)),0), /* cikan */
      ISNULL(SUM(round((giren-cikan),@ONDA_HANE)),0), /* kalan */
      0,0,0,0,0,0
    FROM stkhrk with (nolock) 
    WHERE cikan=0 and stktip=@STOK_TIP and stkod=@STOK_KOD and sil=0
    and depkod in (select * from Depo_Kodin_str(@DEPO_KOD) )
    AND tarih < @TARIH1


  IF @ALSATTIP=2 /*CIKISLAR */
  INSERT @TB_STOK_HRK (id,FIRMANO,
    STOK_TIP,STOK_KOD,STOK_AD,
    STOK_BARKOD,DEPO_KOD,DEPO_AD,
    TARIH,SAAT,BELGENO,ACIKLAMA,
    ISLTIPAD,YERAD,KULAD,ISLTIP,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    ISLID,BRMFIYKDVLI,
    KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
    FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
    REMOTE_ID)
    SELECT
      0,/*id */
      @FIRMANO,
      '',/*STOK TIP */
      @STOK_KOD, /* STOK_KOD */
      @HRK_STOK_AD, /* STOK_AD */
      @HRK_STOK_BARKOD,
      '-', /* STOK_DEPO */
      '-',/*DEPOKOD */
      max(tarih),
      @SAAT1,
      'DEVİR', /* BELGE NO */
      CONVERT(VARCHAR(10), max(tarih), 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
      '-','-','-','-',
      '-','-','-',
      0,0,0,0,
      ISNULL(SUM(round(giren,@ONDA_HANE)),0), /* giren */
      ISNULL(SUM(round(cikan,@ONDA_HANE)),0), /* cikan */
      ISNULL(SUM(round((giren-cikan),@ONDA_HANE)),0), /* kalan */
      0,0,0,0,0,0
      FROM stkhrk with (nolock) 
      WHERE giren=0 and stktip=@STOK_TIP and stkod=@STOK_KOD and sil=0
      and depkod in (select * from Depo_Kodin_str(@DEPO_KOD) )
       AND tarih < @TARIH1
    
      SELECT @KUM_KALAN = isnull(KALAN,0) FROM @TB_STOK_HRK
      if (SELECT COUNT(*) FROM @TB_STOK_HRK WHERE (GIREN>0 OR CIKAN>0))=0 
       delete from @TB_STOK_HRK 
    
   END

  IF @ALSATTIP=0 /*TUMU */
  begin
  INSERT @TB_STOK_HRK (id,FIRMANO,
    STOK_TIP,STOK_KOD,STOK_AD,
    STOK_BARKOD,DEPO_KOD,DEPO_AD,
    TARIH,SAAT,BELGENO,ACIKLAMA,
    ISLTIPAD,YERAD,KULAD,ISLTIP,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    ISLID,BRMFIYKDVLI,
    KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
    FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
    REMOTE_ID)
    SELECT
      h.id,
      h.firmano,
      @STOK_TIP,@STOK_KOD,@HRK_STOK_AD,
      h.barkod,depkod,(dep.ad) as depoad,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,yerad,olususer,islmtip,
      Karsi_KartTip,Karsi_KartKod,'',
      stkhrkid,
      brmfiykdvli,kdvyuz,h.varno,
      round(giren,@ONDA_HANE),
      round(cikan,@ONDA_HANE),
      round((giren-cikan),@ONDA_HANE) AS KALAN,
      h.fatid,h.fisid,h.irid,h.marsatid,h.sayid,h.remote_id
    FROM stkhrk as h with (nolock)  inner join Depo_Kart_Listesi as dep on
    dep.kod=h.depkod
    WHERE h.stktip=@STOK_TIP and h.stkod=@STOK_KOD and h.sil=0
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      and h.depkod in (select * from Depo_Kodin_str(@DEPO_KOD) ) 
     AND tarih >= @TARIH1  AND tarih <= @TARIH2
    ORDER BY tarih,saat
   end

  IF @ALSATTIP=1 /*GIRISLER */
  begin
  INSERT @TB_STOK_HRK (id,FIRMANO,
    STOK_TIP,STOK_KOD,STOK_AD,
    STOK_BARKOD,DEPO_KOD,DEPO_AD,
    TARIH,SAAT,BELGENO,ACIKLAMA,
    ISLTIPAD,YERAD,KULAD,ISLTIP,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    ISLID,BRMFIYKDVLI,
    KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
    FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
    REMOTE_ID)
    SELECT
      h.id,
      h.firmano,
      @STOK_TIP,@STOK_KOD,@HRK_STOK_AD,
      h.barkod,depkod,(dep.ad) as depoad,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,yerad,olususer,islmtip,
      Karsi_KartTip,Karsi_KartKod,'',
      stkhrkid,
      brmfiykdvli,kdvyuz,h.varno,
      round(giren,@ONDA_HANE),
      round(cikan,@ONDA_HANE),
      round((giren-cikan),@ONDA_HANE) AS KALAN,
      h.fatid,h.fisid,h.irid,h.marsatid,h.sayid,h.remote_id
    FROM stkhrk as h with (nolock)  inner join Depo_Kart_Listesi as dep on
     dep.kod=h.depkod
    WHERE h.cikan=0 and h.stktip=@STOK_TIP and h.stkod=@STOK_KOD and h.sil=0
     and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER)) 
      and h.depkod in (select * from Depo_Kodin_str(@DEPO_KOD) )
    AND tarih >= @TARIH1  AND tarih <= @TARIH2
    ORDER BY tarih,saat
   end

  IF @ALSATTIP=2 /*CIKISLAR */
  begin
  INSERT @TB_STOK_HRK (id,FIRMANO,
    STOK_TIP,STOK_KOD,STOK_AD,
    STOK_BARKOD,DEPO_KOD,DEPO_AD,
    TARIH,SAAT,BELGENO,ACIKLAMA,
    ISLTIPAD,YERAD,KULAD,ISLTIP,
    KRS_TIP,KRS_KOD,KRS_UNVAN,
    ISLID,BRMFIYKDVLI,
    KDVYUZ,VARNO,GIREN,CIKAN,KALAN,
    FAT_ID,FIS_ID,IRS_ID,MARSAT_ID,SAY_ID,
    REMOTE_ID)
    SELECT
      h.id,
      h.firmano,
      @STOK_TIP,@STOK_KOD,@HRK_STOK_AD,
      h.barkod,depkod,(dep.ad) as depoad,
       tarih,saat,belno,
      ack, /* AÇIKLAMA, */
      islmtipad,yerad,olususer,islmtip,
      Karsi_KartTip,Karsi_KartKod,'',
      stkhrkid,
      brmfiykdvli,kdvyuz,h.varno,
      round(giren,@ONDA_HANE),
      round(cikan,@ONDA_HANE),
      round((giren-cikan),@ONDA_HANE) AS KALAN,
      h.fatid,h.fisid,h.irid,h.marsatid,h.sayid,h.remote_id
    FROM stkhrk as h with (nolock)  inner join Depo_Kart_Listesi as dep on
     dep.kod=h.depkod
    WHERE h.giren=0 and h.stktip=@STOK_TIP and h.stkod=@STOK_KOD and h.sil=0
     and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      and h.depkod in (select * from Depo_Kodin_str(@DEPO_KOD) ) 
    AND tarih >= @TARIH1  AND tarih <= @TARIH2
    ORDER BY tarih,saat
   end



   if @FIRMANO>0
    delete from  @TB_STOK_HRK where FIRMANO NOT IN (0,@FIRMANO)



    update @TB_STOK_HRK set RAP_ID=dt.fatrap_id
   FROM @TB_STOK_HRK AS T join
   (select fatid,fatrap_id from faturamas with (nolock)) dt
   on t.FAT_ID=dt.fatid 


   update @TB_STOK_HRK set KRS_UNVAN=dt.AD
   FROM @TB_STOK_HRK AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KRS_TIP and dt.kod=t.KRS_KOD
   
    
   update @TB_STOK_HRK set KRS_KOD='-',KRS_UNVAN='-'
   WHERE (KRS_KOD is null)



  RETURN

END

================================================================================
