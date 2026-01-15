-- Function: dbo.FATURA_GRS_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.654314
================================================================================

CREATE FUNCTION dbo.FATURA_GRS_HRK (@fatid float)
RETURNS TABLE AS
RETURN(
select TOP 100 PERCENT
fhrk.*,
sk.stktur as stktur,
(sk.ad) stkad,
(mik*
case when kesafet>0 then kesafet else 1 end) mikkg,
(kdvyuz*100) as kdv,
 (case when kesafet>0 then brmfiy/kesafet 
 else brmfiy end) as brmfiykg,
((brmfiy*mik)+otvtut) tutar,
((brmfiy*mik)+otvtut)*(1+kdvyuz) tutarkdv,
dep.ad as depad from faturahrk as fhrk
inner join gelgidlistok as sk on sk.kod=stkod and stktip=tip
left join Depo_Kart_Listesi as dep on dep.kod=depkod
where fhrk.fatid=@fatid and fhrk.sil=0 order by fhrk.id )

================================================================================
