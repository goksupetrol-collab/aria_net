-- Function: dbo.UDF_VAR_STOK_TURU_KARSILASTIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.795965
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_STOK_TURU_KARSILASTIR]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000),
@ONCEVARIN    VARCHAR(8000))
RETURNS
    @TB_VAR_STOK_LITRE TABLE (
    STOK_TIP			VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_KOD		    VARCHAR(50) COLLATE Turkish_CI_AS,
    LITRE		      	FLOAT,
    ONCE_LITRE         	FLOAT)
AS
BEGIN
   
   
   INSERT @TB_VAR_STOK_LITRE (STOK_TIP,STOK_KOD,LITRE,ONCE_LITRE)
   select 'akykt',OT.stkod,round( sum(ot.miktar),3),0
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   GROUP BY OT.stkod
   
   
   
   
   UPDATE @TB_VAR_STOK_LITRE SET ONCE_LITRE=DT.litre
   from @TB_VAR_STOK_LITRE as t join 
   (select OT.stkod,round( sum(ot.miktar),3)
   as litre
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@ONCEVARIN))
   GROUP BY OT.stkod ) dt 
   on  dt.stkod=t.STOK_KOD
   
   
   
  
   
   
   
   return


END

================================================================================
