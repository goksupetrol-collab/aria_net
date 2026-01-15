-- Function: dbo.UDF_VAR_STOK_TURU_CARI
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.795179
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_STOK_TURU_CARI]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000))
RETURNS
    @TB_VAR_STOK_LITRE TABLE (
    STOK_TIP			VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_KOD		    VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_TUTAR		   	FLOAT,
    CARI_TUTAR     		FLOAT)
AS
BEGIN
   
   
   INSERT @TB_VAR_STOK_LITRE (STOK_TIP,STOK_KOD,STOK_TUTAR,CARI_TUTAR)
   select 'akykt',OT.stkod,sum(ot.miktar),
   sum(case when sattip='Veresiye' then ot.miktar else 0 end)
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   GROUP BY OT.stkod
   
   
   return


END

================================================================================
