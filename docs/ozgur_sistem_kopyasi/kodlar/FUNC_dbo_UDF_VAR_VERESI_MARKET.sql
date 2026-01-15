-- Function: dbo.UDF_VAR_VERESI_MARKET
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.796916
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_VERESI_MARKET] (
@VARNIN VARCHAR(4000),@TIP VARCHAR(30))
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
  select h.stkod,st.ad,
  sum(h.mik),sum(h.brmfiy*h.mik),
  avg(h.kdvyuz*100),
  sum( (h.brmfiy*h.mik)-  ((h.brmfiy*h.mik)/  (1+h.kdvyuz))   ),
  AVG(brmfiy)
  FROM  veresimas as m
  inner join veresihrk as h 
  on h.verid=m.verid and m.sil=0
  and h.sil=0
  inner join stokkart as st 
  on st.kod=h.stkod and st.tip=h.stktip
  and h.stktip='markt'
  where m.varno in (select * from CsvToInt(@VARNIN)) 
  group by h.stkod,st.ad

  RETURN

end

================================================================================
