-- Function: dbo.POS_DETAY_RAPOR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.665814
================================================================================

CREATE FUNCTION [dbo].POS_DETAY_RAPOR
(@firmano int,
@POS_IN VARCHAR(4000),@TARINDEX INT,@TARIH1 DATETIME,@TARIH2 DATETIME,
@AKTIPIN VARCHAR(20))
RETURNS
  @TB_POS_RAPOR_TOPLAM TABLE (
    BANKA_KOD         VARCHAR(50) COLLATE Turkish_CI_AS,
    BANKA_AD          VARCHAR(150)  COLLATE Turkish_CI_AS,
    POS_KOD           VARCHAR(50)  COLLATE Turkish_CI_AS,
    POS_ADI           VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_TIP		   VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_KOD		   VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_UNVAN		   VARCHAR(200)  COLLATE Turkish_CI_AS,
    POSTUTAR          FLOAT,
    KOMISYONTUTAR     FLOAT,
    HESGECTUTAR       FLOAT,
    ISLEM_TARIHI      DATETIME,
    VADETARIHI        DATETIME)
AS
BEGIN
 DECLARE @EKSTRE_TEMP TABLE (
 pos_kod      varchar(50) COLLATE Turkish_CI_AS )

declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@POS_IN)) > 0)
 BEGIN
  set @POS_IN = @POS_IN + ','
 END

 while patindex('%,%' , @POS_IN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @POS_IN)
   select @array_value = left(@POS_IN, @separator_position - 1)

  Insert @EKSTRE_TEMP
  Values (@array_value)

   select @POS_IN = stuff(@POS_IN, 1, @separator_position, '')
 end


  IF @TARINDEX=0 /*islem tarihi */
  begin
  if @firmano<=0
  INSERT @TB_POS_RAPOR_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,
  CARI_TIP,CARI_KOD,CARI_UNVAN,
  POSTUTAR,KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VADETARIHI)
  select h.bankod,bk.ad,h.poskod,pk.ad,
  h.cartip,h.carkod,'',h.giren,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,h.vadetar
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and h.PosIsle=1
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.tarih>=@TARIH1 and h.tarih <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
  
  if @firmano>0
  INSERT @TB_POS_RAPOR_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,
  CARI_TIP,CARI_KOD,CARI_UNVAN,
  POSTUTAR,KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VADETARIHI)
  select h.bankod,bk.ad,h.poskod,pk.ad,
  h.cartip,h.carkod,'',h.giren,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,h.vadetar
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and h.PosIsle=1 and h.firmano=@firmano
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.tarih>=@TARIH1 and h.tarih <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
  
  
  end
  
  IF @TARINDEX=1 /*vade tarihi */
  begin
  if @firmano<=0
  INSERT @TB_POS_RAPOR_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,
  CARI_TIP,CARI_KOD,CARI_UNVAN,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VADETARIHI)
  select h.bankod,bk.ad,h.poskod,pk.ad,
    h.cartip,h.carkod,'',h.giren,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,h.vadetar
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and h.PosIsle=1
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.vadetar>=@TARIH1 and h.vadetar <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
  
  if @firmano>0
  INSERT @TB_POS_RAPOR_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,
  CARI_TIP,CARI_KOD,CARI_UNVAN,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VADETARIHI)
  select h.bankod,bk.ad,h.poskod,pk.ad,
    h.cartip,h.carkod,'',h.giren,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,h.vadetar
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and h.PosIsle=1 and h.firmano=@firmano
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.vadetar>=@TARIH1 and h.vadetar <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN)) 
  
  end
  
  
  
  
   update @TB_POS_RAPOR_TOPLAM set CARI_UNVAN=DT.UNVAN FROM @TB_POS_RAPOR_TOPLAM AS t 
   join (select cartip,kod,unvan from Genel_Cari_Kart with (nolock)) dt
   on dt.carTip=t.CARI_TIP and dt.kod=t.CARI_KOD
  
  


  RETURN

end

================================================================================
