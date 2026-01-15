-- Function: dbo.UDF_CARILITRE_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.701537
================================================================================

CREATE FUNCTION [dbo].UDF_CARILITRE_HRK (
@FIRMANO   INT,
@DEVIR     INT,
@CARI_TIP  VARCHAR(30),
@CARI_KOD  VARCHAR(8000),
@STK_TIP   VARCHAR(30),
@STK_KOD   VARCHAR(30),
@FISTIP    VARCHAR(30),
@PLAKA     VARCHAR(50),
@TARIH1    DATETIME,
@TARIH2    DATETIME,
@FISDRMIN  VARCHAR(50))
RETURNS
  @TB_STOKLITRE_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20)    COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(50)    COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(100)    COLLATE Turkish_CI_AS,
    STOK_TIP    VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(50)    COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100)    COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)    COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)   COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30)   COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    FISAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    FISTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    BRMFIY      FLOAT,
    BIRIM       VARCHAR(10)   COLLATE Turkish_CI_AS,
    ALCAKMIK    FLOAT,
    VERILENMIK  FLOAT,
    ALACAKTUT   FLOAT,
    VERILENTUT  FLOAT,
    BAKIYE      DECIMAL(18,8),
    DEVIR       TINYINT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)    COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(50)    COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(100)    COLLATE Turkish_CI_AS,
    STOK_TIP    VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(50)    COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100)    COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)      COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)     COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30)     COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)     COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)    COLLATE Turkish_CI_AS,
    FISAD       VARCHAR(50)     COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)     COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)     COLLATE Turkish_CI_AS,
    FISTIP      VARCHAR(10)     COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    BRMFIY      FLOAT,
    BIRIM       VARCHAR(10)     COLLATE Turkish_CI_AS,
    ALCAKMIK    FLOAT,
    VERILENMIK  FLOAT,
    ALACAKTUT   FLOAT,
    VERILENTUT  FLOAT,
    BAKIYE      DECIMAL(18,8),
    DEVIR       TINYINT)

  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_STOK_KOD    VARCHAR(50)
  DECLARE @HRK_STOK_AD     VARCHAR(100)
  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(50)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(100)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_YKNO        VARCHAR(30)
  DECLARE @HRK_PLAKA       VARCHAR(50)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_FISAD       VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(50)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_FISTIP      VARCHAR(10)
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_BRMFIY      FLOAT
  DECLARE @HRK_BIRIM       VARCHAR(10)
  DECLARE @HRK_ALCAKMIK    FLOAT
  DECLARE @HRK_VERILENMIK  FLOAT
  DECLARE @HRK_ALACAKTUT   FLOAT
  DECLARE @HRK_VERILENTUT  FLOAT
  DECLARE @HRK_BAKIYE      DECIMAL(18,8)
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)
  DECLARE @HRK_DEVIR       TINYINT
  DECLARE @HRK_ONSTOK_TIP    VARCHAR(20)
  DECLARE @HRK_ONSTOK_KOD    VARCHAR(20)
  set @KUM_BAKIYE=0


  /* Devir atanıyor */
  /*---------------------------------------------------------------------------- */
  if @DEVIR=1
    begin
    
  
      if (@CARI_KOD<>'') and (@STK_KOD='') and (@FIRMANO=0)  /* tum stok kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))

        end
        
        
        
      if (@CARI_KOD<>'') and (@STK_KOD='') and (@FIRMANO>0)  /* tum stok kartları */
      begin
       INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h 
           inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           and m.firmano in (@FIRMANO,0)
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))

        end
        
        

    
      if (@STK_KOD<>'') and (@FISTIP='') and (@FIRMANO=0) /* tek stok kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
              
        end
        
        
      if (@STK_KOD<>'') and (@FISTIP='') and (@FIRMANO>0) /* tek stok kartları */
       begin
        INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h 
           inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           and m.firmano in (@FIRMANO,0)
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
              
        end
        
        
        
        
        
        
      if (@FISTIP<>'') and (@PLAKA='') and (@FIRMANO=0) /* TEK FISTIP kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
           AND m.fistip=@FISTIP
       end
        
       
       
      if (@FISTIP<>'') and (@PLAKA='') and (@FIRMANO>0) /* TEK FISTIP kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h 
           inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           and m.firmano in (@FIRMANO,0)
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
           AND m.fistip=@FISTIP
       end
       
       
       
        
      if (@PLAKA<>'') and (@FIRMANO=0) /* TEK FISTIP kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
           and m.fistip=@FISTIP AND m.plaka=@PLAKA
           /*group by m.cartip,m.carkod, */
           /*h.stktip,h.stkod,k.ad */
           
        end 
        
        
        
        if (@PLAKA<>'') and (@FIRMANO>0) /* TEK FISTIP kartları */
      begin
      INSERT @EKSTRE_TEMP
        SELECT
           '','','','','','',/*m.cartip,m.carkod,'',   */
           /*stktip,stkod,k.ad, */
           @TARIH1,
           '00:00:00',
           'DEVIR',/*SERİNO */
           'DEVIR',/*YKNO */
           '', /*PLAKA */
           CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA, */
           'DEVIR','DEVIR','DEVIR','-',0,0,'-',
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISVERSAT' THEN  mik*brmfiy else 0 end),0),
           ISNULL(SUM(CASE WHEN fistip='FISALCSAT' THEN  mik else -1*mik end),0),
           1
           FROM veresihrk as h 
           inner join veresimas as m on h.verid=m.verid
           and m.sil=0 and h.sil=0
           and m.firmano in (@FIRMANO,0)
           inner join stokkart as k on k.kod=h.stkod
           and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
           WHERE cartip=@CARI_TIP and carkod in (select * from CsvToSTR(@CARI_KOD) )
           AND (m.tarih < @TARIH1) and m.aktip in (select * from CsvToSTR(@FISDRMIN))
           and m.fistip=@FISTIP AND m.plaka=@PLAKA
            
        end 
        
        
        
        
     end/*--devir int */
    

   SET @HRK_ONSTOK_TIP=''
   SET @HRK_ONSTOK_KOD=''



   if (@CARI_KOD<>'') and (@STK_KOD='') and (@FIRMANO=0) /* tum stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
       m.cartip,m.carkod,'',
       stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h 
       inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2) 
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,tarih,saat
    end
    
    
    
    if (@CARI_KOD<>'') and (@STK_KOD='') and (@FIRMANO>0) /* tum stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
       m.cartip,m.carkod,'',
       stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h 
       inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       and m.firmano in (@FIRMANO,0)
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2) 
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,tarih,saat
    end

    
    
    

   if (@STK_KOD<>'') and (@FISTIP='')  and (@FIRMANO=0)/* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,tarih,saat
    end
    
   
    if (@STK_KOD<>'') and (@FISTIP='')  and (@FIRMANO>0)/* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h 
       inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       and m.firmano in (@FIRMANO,0)
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,tarih,saat
    end
    
   
   
   
   if (@FISTIP<>'') and (@PLAKA='') and (@FIRMANO=0) /* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
       AND m.fistip=@FISTIP
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,m.fistip,tarih,saat
    end  
    
    if (@FISTIP<>'') and (@PLAKA='') and (@FIRMANO>0) /* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h 
       inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       and m.firmano in (@FIRMANO,0)
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
       AND m.fistip=@FISTIP
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,m.fistip,tarih,saat
    end  
    
    
   if (@PLAKA<>'')  and (@FIRMANO=0)/* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD 
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
       AND m.fistip=@FISTIP 
       AND m.plaka=@PLAKA 
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,m.fistip,m.plaka,tarih,saat
    end 
    
    
   if (@PLAKA<>'')  and (@FIRMANO>0)/* tek stok kartları */
   begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      m.cartip,m.carkod,'',
      stktip,stkod,k.ad,
       tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      fisad,yerad,h.olususer,fistip,
      m.verid,brmfiy,h.brim,
       CASE WHEN fistip='FISALCSAT' THEN  mik else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*mik else mik end,
       0
       FROM veresihrk as h 
       inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       and m.firmano in (@FIRMANO,0)
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip and k.tip=@STK_TIP and k.kod=@STK_KOD 
       WHERE cartip=@CARI_TIP 
       and carkod in (select * from CsvToSTR(@CARI_KOD) )
       AND (tarih >= @TARIH1)
       AND (tarih <= @TARIH2)
       and m.aktip in (select * from CsvToSTR(@FISDRMIN))
       AND m.fistip=@FISTIP 
       AND m.plaka=@PLAKA 
     ORDER BY m.cartip,m.carkod,
     h.stktip,h.stkod,m.fistip,m.plaka,tarih,saat
    end  
     
 
  OPEN CRS_HRK

  SET @KUM_BAKIYE=0

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
   @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,
   @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,@HRK_PLAKA,@HRK_ACIKLAMA,
   @HRK_FISAD,@HRK_YERAD,@HRK_KULAD,@HRK_FISTIP,@HRK_HRKID,@HRK_BRMFIY,
   @HRK_BIRIM,@HRK_ALCAKMIK,@HRK_VERILENMIK,@HRK_BAKIYE,
   @HRK_DEVIR

  WHILE @@FETCH_STATUS = 0
  BEGIN

     if @DEVIR=1
       begin
       
        SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP where
         HRKID=0
       
        /*
         if (@HRK_ONSTOK_TIP<>@HRK_STOK_TIP) and
         (@HRK_ONSTOK_KOD<>@HRK_STOK_KOD)
         begin
         SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP where
         STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
         and HRKID=0
         set @HRK_ONSTOK_TIP=@HRK_STOK_TIP
          set @HRK_ONSTOK_KOD=@HRK_STOK_KOD
         end
        */ 
       end
       




       
    SET @KUM_BAKIYE = @KUM_BAKIYE - @HRK_BAKIYE

    SET @HRK_ALACAKTUT=@HRK_ALCAKMIK*@HRK_BRMFIY
    SET @HRK_VERILENTUT=@HRK_VERILENMIK*@HRK_BRMFIY


    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,
       @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,
       @HRK_PLAKA,@HRK_ACIKLAMA,
       @HRK_FISAD,@HRK_YERAD,@HRK_KULAD,@HRK_FISTIP,
       @HRK_HRKID,@HRK_BRMFIY,@HRK_BIRIM,@HRK_ALCAKMIK,@HRK_VERILENMIK,
       @HRK_ALACAKTUT,@HRK_VERILENTUT,@KUM_BAKIYE,@HRK_DEVIR

    FETCH NEXT FROM CRS_HRK INTO
      @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
      @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,
      @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,
      @HRK_PLAKA,@HRK_ACIKLAMA,
      @HRK_FISAD,@HRK_YERAD,@HRK_KULAD,@HRK_FISTIP,
      @HRK_HRKID,@HRK_BRMFIY,@HRK_BIRIM,@HRK_ALCAKMIK,@HRK_VERILENMIK,
      @HRK_BAKIYE,@HRK_DEVIR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */


   UPDATE @EKSTRE_TEMP SET
   CARI_UNVAN=DT.unvan FROM @EKSTRE_TEMP AS T 
   JOIN (SELECT cartip,kod,unvan FROM Genel_Cari_Kart )
   dt on dt.cartip=t.CARI_TIP and dt.kod=t.CARI_KOD


  INSERT @TB_STOKLITRE_EKSTRE
    SELECT 
    CARI_TIP,CARI_KOD,CARI_UNVAN,
    STOK_TIP,STOK_KOD,STOK_AD,
    TARIH,SAAT,BELGENO,YKNO,PLAKA,ACIKLAMA,
    FISAD,YERAD,KULAD,FISTIP,HRKID,BRMFIY,BIRIM,ALCAKMIK,
    VERILENMIK,ALACAKTUT,
    VERILENTUT,BAKIYE,DEVIR 
    FROM @EKSTRE_TEMP order by TARIH,SAAT


  RETURN

END

================================================================================
