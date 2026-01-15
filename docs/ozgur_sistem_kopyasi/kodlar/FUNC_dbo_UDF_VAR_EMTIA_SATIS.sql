-- Function: dbo.UDF_VAR_EMTIA_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.779311
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_EMTIA_SATIS (
@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_EMTIA_SATIS TABLE (
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(150)  COLLATE Turkish_CI_AS,
    SATISMIKTAR      FLOAT,
    SATISTUTAR        FLOAT,
    KDV               FLOAT,
    KDVTUTAR          FLOAT,
    BIRIMFIYAT        FLOAT)
AS
BEGIN
  
  INSERT @TB_EMTIA_SATIS (STOK_KOD,STOK_AD,SATISMIKTAR,SATISTUTAR,
  KDV,KDVTUTAR,BIRIMFIYAT)
  select EM.stkod,st.ad,sum(em.mik),sum(em.brmfiy*em.mik),avg(em.kdvyuz*100),
  sum(   (em.brmfiy*em.mik)-  ((em.brmfiy*em.mik)/  (1+em.kdvyuz))   ),AVG(brmfiy)
  FROM  emtiasat as em with (nolock) 
  inner join stokkart as st with (nolock) on st.kod=em.stkod and st.tip=em.stktip
  where em.varno in (select * from CsvToInt_Max(@VARNIN)) and em.sil=0
  group by EM.stkod,st.ad

  RETURN

end

================================================================================
