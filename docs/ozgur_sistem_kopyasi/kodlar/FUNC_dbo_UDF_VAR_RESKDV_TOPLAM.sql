-- Function: dbo.UDF_VAR_RESKDV_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.789672
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_RESKDV_TOPLAM] (
@VARNIN VARCHAR(4000),@TIP VARCHAR(30))
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
  isnull(sum(case when m.Iade=0 then em.miktar else 0 end),0),
  isnull(sum(case when m.Iade=0 then em.miktar*em.birimfiyat*em.kur else 0 end),0),
  isnull(sum(case when m.Iade=1 then em.miktar else 0 end),0),
  isnull(sum(case when m.Iade=1 then em.miktar*em.birimfiyat*em.kur else 0 end),0),
  (em.kdvyuz*100),sum( ( ((case when m.Iade=0 then em.miktar else
   -1*em.miktar end)*em.birimfiyat*em.kur) / (1+em.kdvyuz) )*em.kdvyuz)
  FROM  ressathrk as em
  inner join  ressatmas as m on m.Id=em.ResSatId and m.Sil=0   
  inner join stokkart as st on st.id=em.stkId and st.tip_id=em.stktipId
  where em.varno in (select * from CsvToInt(@VARNIN) ) and em.sil=0
  group by em.kdvyuz

  RETURN

end

================================================================================
