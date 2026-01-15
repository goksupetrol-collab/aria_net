-- Function: dbo.UDF_VAR_PERTESLIMAT_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.787209
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_PERTESLIMAT_TOPLAM 
(@VARNIN VARCHAR(max),
@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_ADI        VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP       VARCHAR(30)  COLLATE Turkish_CI_AS,
    TUTAR           FLOAT,
    DOVIZ_TUTAR     FLOAT,
    KUR             FLOAT,
    PARABIRIM       VARCHAR(20) COLLATE Turkish_CI_AS,
    KASA_KOD        VARCHAR(20) COLLATE Turkish_CI_AS,
    KASA_AD         VARCHAR(40) COLLATE Turkish_CI_AS)
AS
BEGIN

  INSERT @TB_TAH_ODE_TOPLAM (CARI_KOD,CARI_ADI,CARI_GRUP,
  TUTAR,DOVIZ_TUTAR,
  KUR,PARABIRIM,KASA_KOD,KASA_AD)
  select h.perkod,ck.ad+' '+ck.soyad,gp.ad,
  sum(h.giren*h.kur),sum(h.giren),
  case when sum(h.giren*h.kur)>0 then 
   (sum(h.giren*h.kur)/sum(h.giren))
   else avg(h.kur) end,
   kk.parabrm,kk.kod,kk.ad
  FROM  kasahrk as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.perkod
  inner join kasakart as kk with (nolock) on kk.kod=h.kaskod
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from CsvToInt_Max(@VARNIN) ) 
  and h.islmhrk='TES' and h.masterid=0 and h.sil=0 and h.yertip=@TIP
  group by h.perkod,ck.ad+' '+ck.soyad,gp.ad,kk.parabrm,kk.kod,kk.ad




  RETURN

end

================================================================================
