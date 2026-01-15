-- Function: dbo.UDF_VAR_NAKIT_TES
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.785938
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_NAKIT_TES] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_NAKIT_TES TABLE (
    KASKOD              VARCHAR(30) COLLATE Turkish_CI_AS,
    KASAAD     			VARCHAR(100) COLLATE Turkish_CI_AS,
    PARABRIM			VARCHAR(30) COLLATE Turkish_CI_AS,
    YTLTUTAR        	FLOAT,
    KUR             	FLOAT,
    TUTAR        		FLOAT)
AS
BEGIN
 
   insert into @TB_NAKIT_TES
   SELECT  P.kaskod,S.ad,p.parabrm,
      sum(p.kur*p.giren),avg(P.kur),
      sum(P.giren) 
      FROM  kasahrk AS P INNER JOIN kasakart AS S ON 
       (P.kaskod=S.kod and p.varno in (select * from CsvToInt(@VARNIN))
       and p.sil=0 and 
       yertip=@TIP and islmhrk='TES') 
       group by P.kaskod,S.ad,p.parabrm 
   


  RETURN

end

================================================================================
