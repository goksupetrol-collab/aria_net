-- Function: dbo.FATURA_HRK_SATIS
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.655102
================================================================================

CREATE FUNCTION dbo.[FATURA_HRK_SATIS](@fatid float)
RETURNS TABLE AS
RETURN(
select fhrk.stkod AS STOK_KOD,fhrk.barkod,
gstk.ad as STOK_AD,
(fhrk.mik) MIKTAR,(fhrk.kdvyuz*100) as KDV,
fhrk.brim AS STOK_BIRIM,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut)) BIRIM_FIYAT,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz) BIRIM_FIYATKDVLI,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*fhrk.mik TUTAR,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz)*fhrk.mik TUTARKDVLI,
case when gstk.sat1kdvtip='Dahil' then  sat1fiy 
else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END SAT_BIRIM_FIYATKDVLI,

fhrk.mik*case when gstk.sat1kdvtip='Dahil' then  sat1fiy 
else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END SAT_TUTARKDVLI,



 -1*round( (1-((case when gstk.sat1kdvtip='Dahil' then  sat1fiy else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END) / 
 (case when ((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz)=0 then
 1 else ((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz) end)))*100,2) KAR_YUZDE


from faturahrk AS fhrk WITH (NOLOCK) 
inner join gelgidlistok as gstk WITH (NOLOCK) 
on gstk.kod=fhrk.stkod
and fhrk.stktip=gstk.tip 
where fhrk.fatid=@fatid and fhrk.sil=0 )

================================================================================
