-- Function: dbo.UDF_VAR_BANKYATCEK_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.775252
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_BANKYATCEK_TOPLAM (
@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_KOD     VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_ADI     VARCHAR(40)  COLLATE Turkish_CI_AS,
    CARI_GRUP    VARCHAR(30)  COLLATE Turkish_CI_AS,
    CEKILEN         FLOAT,
    YATIRILAN       FLOAT)
AS
BEGIN
  
  INSERT @TB_TAH_ODE_TOPLAM (CARI_KOD,CARI_ADI,CARI_GRUP,YATIRILAN,CEKILEN)
  select h.bankod,ck.ad,gp.ad,sum(h.borc),sum(h.alacak)
  FROM  bankahrk as h with (nolock)
  inner join bankakart as ck with (nolock) on ck.kod=h.bankod
  inner join grup as gp  with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from CsvToInt_Max(@VARNIN) )
  and h.sil=0 and h.yertip=@TIP
  group by h.bankod,ck.ad,gp.ad

  RETURN

end

================================================================================
