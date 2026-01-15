-- Function: dbo.FATURA_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.654619
================================================================================

CREATE FUNCTION dbo.FATURA_HRK(@fatid float)
RETURNS TABLE AS
RETURN(select fhrk.stkod AS STOK_KOD,fhrk.barkod,
gstk.ad as STOK_AD,gstk.Gtip AS GTIP,
(fhrk.mik) MIKTAR,(fhrk.kdvyuz*100) as KDV,
fhrk.brim AS STOK_BIRIM,
(fhrk.brmfiy) BIRIM_FIYAT,
fhrk.satiskyuz as ISKONTO_YUZDE,
(fhrk.brmfiy)*(1+fhrk.kdvyuz) BIRIM_FIYATKDVLI,
((fhrk.brmfiy*fhrk.mik)+otvtut) TUTAR,
((fhrk.brmfiy*fhrk.mik)+otvtut)*(1+fhrk.kdvyuz) TUTARKDVLI
from faturahrk AS fhrk WITH (NOLOCK) 
inner join gelgidlistok as gstk WITH (NOLOCK) 
on gstk.kod=fhrk.stkod
and fhrk.stktip=gstk.tip where fhrk.fatid=@fatid and fhrk.sil=0 )

================================================================================
