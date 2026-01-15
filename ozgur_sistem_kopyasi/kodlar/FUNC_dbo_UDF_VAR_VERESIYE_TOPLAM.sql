-- Function: dbo.UDF_VAR_VERESIYE_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.798154
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_VERESIYE_TOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_TIP     VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_ADI     VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP    VARCHAR(50)  COLLATE Turkish_CI_AS,
    GIREN        FLOAT,
    CIKAN        FLOAT)
AS
BEGIN


  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.carkod,ck.ad,ck.grupad1,
  sum(case when fistip='FISVERSAT' THEN (toptut-(fiyfarktop+vadfarktop)) else 0 END),
  sum(case when fistip='FISALCSAT' THEN (toptut-(fiyfarktop+vadfarktop)) else 0 END)
  FROM  veresimas as h with (nolock)
  inner join Genel_Kart as ck with (nolock) on ck.kod=h.carkod and h.cartip=ck.cartp
  where h.varno in (select * from CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  group by h.cartip,h.carkod,ck.ad,ck.grupad1

  RETURN

end

================================================================================
