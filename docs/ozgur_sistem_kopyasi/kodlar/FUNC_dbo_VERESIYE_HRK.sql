-- Function: dbo.VERESIYE_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.800869
================================================================================

CREATE FUNCTION dbo.VERESIYE_HRK 
(@verid float)
RETURNS TABLE AS
RETURN(select h.stkod AS STOK_KOD,gstk.ad as STOK_AD,
(h.mik) MIKTAR,h.brim AS STOK_BIRIM,
(h.brmfiy) BIRIM_FIYAT,
(h.brmfiy/(1+h.kdvyuz)) BIRIM_KDVSIZ,
round((h.brmfiy*h.mik),2) TUTAR,
round( ((h.brmfiy*h.mik)/(1+h.kdvyuz)),2) TUTAR_KDVSIZ,
(h.kdvyuz*100) KDV_ORAN

from veresihrk AS h WITH (NOLOCK) inner join gelgidlistok as gstk on gstk.kod=h.stkod
and h.stktip=gstk.tip where h.verid=@verid and h.sil=0 )

================================================================================
