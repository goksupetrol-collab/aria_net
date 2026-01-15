-- Function: dbo.UDF_VAR_NAK_TES_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.785075
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_NAK_TES_HRK] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_NAK_TES_HRK TABLE (
    PER_KODU            VARCHAR(50) COLLATE Turkish_CI_AS,
    PER_UNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    PARABRIM			VARCHAR(50) COLLATE Turkish_CI_AS,
    TLTUTAR        	    FLOAT,
    KUR        			FLOAT,
    TUTAR               FLOAT,
    ACIKLAMA         	VARCHAR(150) )
AS
BEGIN
 
  
   insert into @TB_NAK_TES_HRK
   SELECT  P.perkod AS PER_KODU,s.ad+' '+s.soyad AS PER_UNVAN,
    p.parabrm as PARABRIM,
    (p.kur*p.giren) AS TLTUTAR,(P.kur) AS KUR,(P.giren) AS TUTAR,
    p.ack ACIKLAMA FROM kasahrk AS P INNER JOIN perkart AS S ON 
    (P.perkod=S.kod and P.varno in  (select * from CsvToInt(@VARNIN)) 
    and p.sil=0 and yertip=@TIP and islmhrk='TES') 
 
 
    
   
  RETURN

end

================================================================================
