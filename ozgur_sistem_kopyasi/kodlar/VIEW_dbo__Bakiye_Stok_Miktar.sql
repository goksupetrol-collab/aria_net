-- View: dbo._Bakiye_Stok_Miktar
-- Tarih: 2026-01-14 20:06:08.452996
================================================================================

CREATE VIEW [dbo].[_Bakiye_Stok_Miktar] AS
CREATE VIEW [dbo]._Bakiye_Stok_Miktar
AS
  select h.stktip,h.stkod,
  isnull( case when 
  sum(h.giren)>0 then
  (sum(h.giren*h.brmfiykdvli)) / sum(h.giren)
  else 0 end , 0)  ortals_fiykdvli,
  isnull(case when sum(h.giren)>0 then
  (sum(h.giren*(h.brmfiykdvli /  case when kdvyuz>0 then (1.00+kdvyuz) else 1 end   ) )) / sum(h.giren)
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
  isnull(sum(giren*(brmfiykdvli/ case when kdvyuz>0 then (1.00+kdvyuz) else 1 end   )),0) as gir_topkdvsiz,
  isnull(sum(h.cikan),0) as cik_miktar,
  isnull(sum(cikan*brmfiykdvli),0) as cik_topkdvli,
  isnull(sum(cikan*(brmfiykdvli/ case when kdvyuz>0 then (1.00+kdvyuz) else 1 end  )),0) as cik_topkdvsiz,

  isnull(Sum(case when h.islmtip='HARGIRCIK' then 
  (h.giren-h.cikan) else 0 end),0)
   as har_miktar
  from stkhrk as h  WITH (NOLOCK)   where h.sil=0
  group by h.stktip,h.stkod

================================================================================
