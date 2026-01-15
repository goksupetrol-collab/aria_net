-- Function: dbo.UDF_VAR_MARKDV_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.784246
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_MARKDV_TOPLAM (
@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_EMTIA_SATIS TABLE (
    SATISMIKTAR      FLOAT,
    SATISTUTAR        FLOAT,
    IADEMIKTAR        FLOAT,
    IADETUTAR         FLOAT,
    KDV               FLOAT,
    KDVTUTAR          FLOAT)
AS
BEGIN
  

  INSERT @TB_EMTIA_SATIS (SATISMIKTAR,SATISTUTAR,
  IADEMIKTAR,IADETUTAR,KDV,KDVTUTAR)
  select 
  isnull(sum(case when em.islmtip='satis' then em.mik else 0 end),0),
  isnull(sum(case when em.islmtip='satis' then 
  em.mik*em.brmfiy*em.kur
  *(1-em.indyuz) else 0 end),0),
  isnull(sum(case when em.islmtip='iade' then 
  em.mik else 0 end),0),
  isnull(sum(case when em.islmtip='iade' then 
  em.mik*em.brmfiy*em.kur*(1-em.indyuz) else 0 end),0),
  (em.kdvyuz*100),sum( ( ((case when em.islmtip='satis' then 
  em.mik else -1*em.mik end)*em.brmfiy*em.kur*(1-em.indyuz)) / (1+em.kdvyuz) )*em.kdvyuz)
  FROM  marsathrk as em with (nolock)
  inner join stokkart as st with (nolock) on st.kod=em.stkod and st.tip=em.stktip
  where em.varno in (select * from CsvToInt_Max(@VARNIN) ) and em.sil=0
  group by em.kdvyuz

  RETURN

end

================================================================================
