-- Function: dbo.UDF_CARIFIS_TARIH_KM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.699485
================================================================================

CREATE FUNCTION dbo.[UDF_CARIFIS_TARIH_KM] (
@CARI_TIP VARCHAR(20),
@CARIKOD_IN  VARCHAR(8000),
@VERIDIN  VARCHAR(8000),
@TARINDEX  INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@AKTIPIN VARCHAR(30),
@PLAKA   VARCHAR(30))
RETURNS
    @TB_FIS_TARIH TABLE (
    Verid       INT,
    CARI_TIP		VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD		VARCHAR(50) COLLATE Turkish_CI_AS,
    STK_KOD     VARCHAR(20) COLLATE Turkish_CI_AS,
    STK_AD      VARCHAR(150) COLLATE Turkish_CI_AS,
    STK_BRM     VARCHAR(10) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(10) COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(100) COLLATE Turkish_CI_AS,
    ONCEKI_KM    FLOAT,    
    KM          FLOAT,
    FARK_KM     FLOAT DEFAULT 0,
    LITRE_KM    FLOAT DEFAULT 0,
    FISNO       VARCHAR(40) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30) COLLATE Turkish_CI_AS,
    YKFISNO     VARCHAR(30) COLLATE Turkish_CI_AS,
    ACK			VARCHAR(200) COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BRMFIY      FLOAT,
    TUTAR       FLOAT,
    VADTAR      DATETIME)
AS
BEGIN
    DECLARE     @TB_FIS TABLE (
    Verid       INT,
    CARI_TIP		VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD		VARCHAR(50) COLLATE Turkish_CI_AS,
    STK_KOD     VARCHAR(20) COLLATE Turkish_CI_AS,
    STK_AD      VARCHAR(150) COLLATE Turkish_CI_AS,
    STK_BRM     VARCHAR(10) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(10) COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(100) COLLATE Turkish_CI_AS,
    ONCEKI_KM    FLOAT,  
    KM          FLOAT,
    FARK_KM     FLOAT DEFAULT 0,
    LITRE_KM    FLOAT DEFAULT 0,
    FISNO       VARCHAR(40) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30) COLLATE Turkish_CI_AS,
    YKFISNO     VARCHAR(30) COLLATE Turkish_CI_AS,
    ACK			VARCHAR(200) COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BRMFIY      FLOAT,
    TUTAR       FLOAT,
    VADTAR      DATETIME,
    AKTIP       VARCHAR(10) COLLATE Turkish_CI_AS)
    
    
    

  if (@TARINDEX=0) AND (@VERIDIN<>'') and  (@CARIKOD_IN<>'') 
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,
  fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis with (nolock) 
  inner join veresihrk as fishrk with (nolock) 
  on fishrk.verid=fis.verid
  and fishrk.sil=0 and cartip=@CARI_TIP 
  and carkod IN (SELECT * FROM CsvNokVirToSTR(@CARIKOD_IN))
  and (fis.tarih+cast(fis.saat as datetime))>=@TARIH1 
  and (fis.tarih+cast(fis.saat as datetime))<=@TARIH2
  and fis.verid in (select * from dbo.CsvToInt(@VERIDIN))
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
  order by tarih
  end
  
  
  if (@TARINDEX=0) AND (@VERIDIN='') and  (@CARIKOD_IN<>'')
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
   case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,
  fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis with (nolock) 
  inner join veresihrk as fishrk with (nolock) 
  on fishrk.verid=fis.verid
  and fishrk.sil=0 and cartip=@CARI_TIP 
  and carkod IN (SELECT * FROM CsvNokVirToSTR(@CARIKOD_IN))
  and (fis.tarih+cast(fis.saat as datetime))>=@TARIH1 
  and (fis.tarih+cast(fis.saat as datetime))<=@TARIH2
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
  order by tarih
  end
  
  

  if (@TARINDEX=1) AND (@VERIDIN<>'') and  (@CARIKOD_IN<>'')
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis with (nolock)
  inner join veresihrk as fishrk with (nolock)
  on fishrk.verid=fis.verid
  and fishrk.sil=0 and cartip=@CARI_TIP 
   and carkod IN (SELECT * FROM CsvNokVirToSTR(@CARIKOD_IN))
  and fis.vadtar>=@TARIH1 and fis.vadtar<=@TARIH2
  and fis.verid in (select * from dbo.CsvToInt(@VERIDIN))
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
    order by tarih
  end
  
  
  
  if (@TARINDEX=1) AND (@VERIDIN='') and  (@CARIKOD_IN<>'')
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis with (nolock)
  inner join veresihrk as fishrk with (nolock)
  on fishrk.verid=fis.verid
  and fishrk.sil=0 and cartip=@CARI_TIP 
   and carkod IN (SELECT * FROM CsvNokVirToSTR(@CARIKOD_IN))
  and fis.vadtar>=@TARIH1 and fis.vadtar<=@TARIH2
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
    order by tarih
  end
  
  
  if (@TARINDEX=0) AND (@VERIDIN='') and  (@CARIKOD_IN='')
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
   case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,
  fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis with (nolock)
  inner join veresihrk as fishrk with (nolock)
  on fishrk.verid=fis.verid
  and fishrk.sil=0 
  and (fis.tarih+cast(fis.saat as datetime))>=@TARIH1 
  and (fis.tarih+cast(fis.saat as datetime))<=@TARIH2
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
  order by tarih
  end
  
  
  
  if (@TARINDEX=1) AND (@VERIDIN='') and  (@CARIKOD_IN='')
  begin
  insert @TB_FIS (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,AKTIP,ACK)
  SELECT fis.verid,fis.cartip,fis.carkod,fishrk.stkod,gstk.ad,fishrk.brim,
  fis.plaka,fis.surucu,fis.OncekiKm,fis.km,fis.tarih,fis.saat,
  fis.ykno AS YKNO,fis.YkFisNo,
  seri+cast([no] as varchar) AS FISNO,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik else
  -1*(fishrk.mik) end,fishrk.brmfiy,
  case WHEN Fistip='FISVERSAT' then
  fishrk.mik*fishrk.brmfiy else
  -1*(fishrk.mik*fishrk.brmfiy) end,
  fis.vadtar,
  fis.aktip,fis.ack from veresimas as fis
  inner join veresihrk as fishrk
  on fishrk.verid=fis.verid
  and fishrk.sil=0 
  and fis.vadtar>=@TARIH1 and fis.vadtar<=@TARIH2
  inner join gelgidlistok as gstk
  on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip
    order by tarih
  end
  


  if (@AKTIPIN<>'') AND (@PLAKA='')
  insert @TB_FIS_TARIH (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK)
  select Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK FROM @TB_FIS
  WHERE AKTIP in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))

  if (@AKTIPIN<>'') AND (@PLAKA<>'')
  insert @TB_FIS_TARIH (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK)
  select Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
  YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK FROM @TB_FIS
  WHERE PLAKA=@PLAKA AND AKTIP in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))


   if (@AKTIPIN='') AND (@PLAKA='')
   insert @TB_FIS_TARIH (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
   YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK)
   select Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
   YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK FROM @TB_FIS

   if (@AKTIPIN='') AND (@PLAKA<>'')
   insert @TB_FIS_TARIH (Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
   YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK)
   select Verid,CARI_TIP,CARI_KOD,STK_KOD,STK_AD,STK_BRM,PLAKA,SURUCU,ONCEKI_KM,KM,TARIH,SAAT,
   YKNO,YKFISNO,FISNO,MIKTAR,BRMFIY,TUTAR,VADTAR,ACK FROM @TB_FIS
   WHERE PLAKA=@PLAKA
   
   
   update  @TB_FIS_TARIH set FARK_KM=isnull(KM,0)-isnull(ONCEKI_KM,0)
   update  @TB_FIS_TARIH set LITRE_KM=
   CASE WHEN FARK_KM>0 THEN MIKTAR/FARK_KM ELSE 0 END
   
   
  



 RETURN


end

================================================================================
