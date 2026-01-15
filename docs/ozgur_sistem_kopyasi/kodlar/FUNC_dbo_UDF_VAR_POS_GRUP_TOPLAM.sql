-- Function: dbo.UDF_VAR_POS_GRUP_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.788336
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_POS_GRUP_TOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    BANKA_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_AD    VARCHAR(100)  COLLATE Turkish_CI_AS,
    POS_KOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
    POS_ADI     VARCHAR(100)  COLLATE Turkish_CI_AS,
    POSTUTAR    FLOAT,
    KOMISYONTUTAR FLOAT,
    HESGECTUTAR   FLOAT)
AS
BEGIN
 
  if @TIP='pomvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM
  (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,KOMISYONTUTAR,
  HESGECTUTAR)
  select h.bankod,bk.ad,h.poskod,pk.ad,SUM(h.giren),
  SUM((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  SUM(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)))
  FROM  poshrk as h with (nolock)
  inner join poskart as pk  with (nolock) on pk.kod=h.poskod
  inner join pomvardimas as pom with (nolock) on pom.varno=h.varno and pom.sil=0
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.varno in (select * from CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  group by h.bankod,bk.ad,h.poskod,pk.ad
  end
  

  if @TIP='marvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR)
  select h.bankod,bk.ad,h.poskod,pk.ad,SUM(h.giren),
  sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)))
  FROM  poshrk as h
  inner join poskart as pk with (nolock) on pk.kod=h.poskod
  inner join marvardimas as pom with (nolock) on pom.varno=h.varno and pom.sil=0
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.varno in (select * from CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  group by h.bankod,bk.ad,h.poskod,pk.ad
  end
  
  
  
  if @TIP='resvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR)
  select h.bankod,bk.ad,h.poskod,pk.ad,SUM(h.giren),
  sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)))
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod
  inner join resvardimas as pom with (nolock) on pom.varno=h.varno and pom.sil=0
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.varno in (select * from CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  group by h.bankod,bk.ad,h.poskod,pk.ad
  end;
  
  
  

  RETURN

end

================================================================================
