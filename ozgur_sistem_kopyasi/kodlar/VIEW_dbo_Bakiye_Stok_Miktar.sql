-- View: dbo.Bakiye_Stok_Miktar
-- Tarih: 2026-01-14 20:06:08.466649
================================================================================

CREATE VIEW [dbo].[Bakiye_Stok_Miktar] AS
CREATE VIEW [dbo].Bakiye_Stok_Miktar
AS
  select k.tip,k.kod,
  k.grp1,k.grp2,k.grp3,
  k.sil,
  isnull(ortals_fiykdvli,0) ortals_fiykdvli,
  isnull(ortals_fiykdvsiz,0) ortals_fiykdvsiz,
  isnull( round(alsiade_mik,Tip.ondalik_hane),0) alsiade_mik,
  isnull(alsiade_topkdvli,0) alsiade_topkdvli,
  isnull(round(satiade_mik,Tip.ondalik_hane),0) satiade_mik,
  isnull(satiade_topkdvli,0) satiade_topkdvli,
  isnull(round(mev_miktar,Tip.ondalik_hane),0) mev_miktar,
  isnull(round(gir_miktar,Tip.ondalik_hane),0) gir_miktar,
  isnull(gir_topkdvli,0) gir_topkdvli,
  isnull(gir_topkdvsiz,0) gir_topkdvsiz,
  isnull(round(cik_miktar,Tip.ondalik_hane),0) cik_miktar,
  isnull(cik_topkdvli,0) cik_topkdvli,
  isnull(cik_topkdvsiz,0) cik_topkdvsiz ,
  isnull(round(har_miktar,Tip.ondalik_hane),0) har_miktar
  from stokkart as k WITH (NOLOCK)
  left join _Bakiye_Stok_Miktar as h  WITH (NOLOCK)
  on h.stktip=k.tip and h.stkod=k.kod
  left join Stk_Tip as Tip WITH (NOLOCK) on k.tip=tip.kod

================================================================================
