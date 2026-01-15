-- Function: dbo.UDF_VAR_POS_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.788712
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_POS_TOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    BANKA_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_AD    VARCHAR(100)  COLLATE Turkish_CI_AS,
    POS_KOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
    POS_ADI     VARCHAR(100)  COLLATE Turkish_CI_AS,
    POSTUTAR    FLOAT,
    CARI_TIP		   VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_KOD		   VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_UNVAN		   VARCHAR(200)  COLLATE Turkish_CI_AS,
    CARITUTAR   FLOAT,
    KOMISYONTUTAR FLOAT,
    HESGECTUTAR   FLOAT,
    ISLEM_TARIHI    DATETIME,
    VARDIYAACTAR    DATETIME,
    VARDIYAKAPTAR    DATETIME,
    VADETARIHI       DATETIME,
    BELGENO       VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA      VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLEM         VARCHAR(50) COLLATE Turkish_CI_AS)
AS
BEGIN
 

  if @TIP='pomvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  CARI_TIP,CARI_KOD,CARI_UNVAN,CARITUTAR,
  KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VARDIYAACTAR,VARDIYAKAPTAR,VADETARIHI,
  BELGENO,ACIKLAMA,ISLEM)
  select h.bankod,bk.ad,h.poskod,pk.ad,h.giren,
  h.cartip,h.carkod,'',
  case when h.carslip=1 then h.giren else 0 end,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,pom.tarih,pom.kaptar,h.vadetar,
  h.belno,h.ack,h.islmhrkad
  FROM  poshrk as h  with (nolock)
  inner join poskart as pk  with (nolock) on pk.kod=h.poskod
  inner join pomvardimas as pom  with (nolock) on pom.varno=h.varno and pom.sil=0
  left join bankakart as bk  with (nolock) on bk.kod=pk.bankod
  where h.varno in (select * from CsvToInt_Max(@VARNIN)) 
  and h.sil=0 and h.yertip=@TIP
  end;
  
  if @TIP='marvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  CARI_TIP,CARI_KOD,CARI_UNVAN,CARITUTAR,
  KOMISYONTUTAR,HESGECTUTAR,ISLEM_TARIHI,VARDIYAACTAR,VARDIYAKAPTAR,VADETARIHI,
  BELGENO,ACIKLAMA,ISLEM)
  select h.bankod,bk.ad,h.poskod,pk.ad,h.giren,
  h.cartip,h.carkod,'',
  case when h.carslip=1 then h.giren else 0 end,
  ((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  h.tarih,pom.tarih,pom.kaptar,h.vadetar,
  h.belno,h.ack,h.islmhrkad
  FROM  poshrk as h with (nolock)
  inner join poskart as pk  with (nolock) on pk.kod=h.poskod
  inner join marvardimas as pom  with (nolock) on pom.varno=h.varno and pom.sil=0
  left join bankakart as bk  with (nolock) on  bk.kod=pk.bankod
  where h.varno in (select * from CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  end;
  
    
   update @TB_TAH_ODE_TOPLAM set CARI_UNVAN=DT.UNVAN FROM @TB_TAH_ODE_TOPLAM AS t 
   join (select cartip,kod,unvan from Genel_Cari_Kart with (nolock)) dt
   on dt.carTip=t.CARI_TIP and dt.kod=t.CARI_KOD
  
  

  RETURN

end

================================================================================
