-- View: dbo.Bakiye_Stok_Miktar_Firma_Dep
-- Tarih: 2026-01-14 20:06:08.466976
================================================================================

CREATE VIEW [dbo].[Bakiye_Stok_Miktar_Firma_Dep] AS
CREATE VIEW [dbo].Bakiye_Stok_Miktar_Firma_Dep
AS
  select 
  /*TOP 100 Percent */
  h.stkod,h.stktip,
  h.firmano,h.depkod,

  isnull( case when sum(h.giren)>0 then
  (sum(h.giren*h.brmfiykdvli)) / sum(h.giren)
  else 0 end , 0)  ortals_fiykdvli,
  isnull(case when sum(h.giren)>0 then
  (sum(h.giren*(h.brmfiykdvli / (1+kdvyuz)) )) / sum(h.giren)
  else 0 end , 0)  ortals_fiykdvsiz,
  /*-iade listesi */
  isnull(sum(aiademik),0) as alsiade_mik,
  isnull(sum(aiademik*brmfiykdvli),0) alsiade_topkdvli,
  isnull(sum(siademik),0) as satiade_mik,
  isnull(sum(siademik*brmfiykdvli),0) as satiade_topkdvli,
  /*-miktarlar */
  isnull(sum(h.giren-h.cikan),0) as mev_miktar,
  isnull(sum(h.giren),0) as gir_miktar,
  isnull(sum(giren*brmfiykdvli),0) gir_topkdvli,
  isnull(sum(giren*(brmfiykdvli/(1+h.kdvyuz))),0) as gir_topkdvsiz,
  isnull(sum(h.cikan),0) as cik_miktar,
  isnull(sum(cikan*brmfiykdvli),0) as cik_topkdvli,
  isnull(sum(cikan*(brmfiykdvli/(1+h.kdvyuz))),0) as cik_topkdvsiz,

  isnull(Sum(case when h.islmtip='HARGIRCIK' then (h.giren-h.cikan) else 0 end),0)
  as har_miktar

  /*from stokkart as k  */
  from stkhrk as h WITH (NOLOCK)
  where h.sil=0
  group by h.stkod,h.stktip,
  h.firmano,h.depkod
   /*k.grp1,k.grp2,k.grp3,k.sil */
  /*order by k.id,h.firmano,h.depkod, */
  /*k.tip,k.kod,k.grp1,k.grp2,k.grp3,k.sil */

================================================================================
