-- Function: dbo.IRSALIYE_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.663098
================================================================================

CREATE FUNCTION dbo.IRSALIYE_HRK(@irid float)
RETURNS TABLE AS
RETURN(select fhrk.stkod AS STOK_KOD,gstk.ad as STOK_AD,
(fhrk.mik) MIKTAR,(fhrk.kdvyuz*100) as KDV,
fhrk.brim AS STOK_BIRIM,
(fhrk.brmfiy) BIRIM_FIYAT,((fhrk.brmfiy*fhrk.mik)) TUTAR
from irsaliyehrk AS fhrk
inner join gelgidlistok as gstk on gstk.kod=fhrk.stkod
and fhrk.stktip=gstk.tip where fhrk.irid=@irid and fhrk.sil=0 )

================================================================================
