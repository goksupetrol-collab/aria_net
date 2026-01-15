-- Function: dbo.UDF_VAR_STOK_TURU_CARI_KARSILASTIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.795590
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_STOK_TURU_CARI_KARSILASTIR]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000),
@ONCEVARIN    VARCHAR(8000))
RETURNS
    @TB_VAR_STOK_LITRE TABLE (
    STOK_TIP			VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_KOD		    VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_TUTAR     		FLOAT,
    ONCE_CARI_TUTAR     FLOAT)
AS
BEGIN
   
   
   INSERT @TB_VAR_STOK_LITRE (STOK_TIP,STOK_KOD,CARI_TUTAR,
   ONCE_CARI_TUTAR)
   select 'akykt',OT.stkod,
   sum(case when sattip='Veresiye' then ot.miktar else 0 end),
   0
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   GROUP BY OT.stkod
   
   
   UPDATE @TB_VAR_STOK_LITRE SET ONCE_CARI_TUTAR=DT.TUTAR
   from @TB_VAR_STOK_LITRE as t join 
   (select OT.stkod,
   sum(case when sattip='Veresiye' then ot.miktar else 0 end)
   as tutar
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@ONCEVARIN))
   GROUP BY OT.stkod ) dt 
   on  dt.stkod=t.STOK_KOD
   
   
   return


END

================================================================================
