-- Function: dbo.FATURA_OTV_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.655438
================================================================================

CREATE FUNCTION dbo.[FATURA_OTV_HRK](@fatid float)
RETURNS TABLE AS
RETURN(select fhrk.stkod AS STOK_KOD,fhrk.barkod,
gstk.ad as STOK_AD,
(fhrk.mik) MIKTAR,
fhrk.Otv_Carpan as OTV_CARPAN,
(fhrk.kdvyuz*100) as KDV,
fhrk.brim AS STOK_BIRIM,
(fhrk.brmfiy) BIRIM_FIYAT,
(fhrk.brmfiy)*(1+fhrk.kdvyuz) BIRIM_FIYATKDVLI,
((fhrk.Otv_Carpan*fhrk.mik)) OTV_TUTAR
from faturahrk AS fhrk with (nolock) 
inner join gelgidlistok as gstk WITH (NOLOCK) 
on gstk.kod=fhrk.stkod
and fhrk.stktip=gstk.tip 
where fhrk.fatid=@fatid and fhrk.sil=0 and fhrk.Otv_Carpan>0 )

================================================================================
