-- Function: dbo.UDF_VAR_STOK_TURU
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.794695
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_STOK_TURU]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000))
RETURNS
    @TB_VAR_STOK_LITRE TABLE (
    STOK_TIP			VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_KOD		    VARCHAR(50) COLLATE Turkish_CI_AS,
    LITRE		      	FLOAT,
    ARAC_SAYI          	FLOAT)
AS
BEGIN
   
   
   INSERT @TB_VAR_STOK_LITRE (STOK_TIP,STOK_KOD,LITRE,ARAC_SAYI)
   select 'akykt',OT.stkod,round( sum(ot.miktar),3),
   count(ot.miktar)
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   GROUP BY OT.stkod
   
   
  
   
   
   
   return


END

================================================================================
