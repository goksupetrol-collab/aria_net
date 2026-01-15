-- View: dbo.Stok_iade_Miktar_Listesi
-- Tarih: 2026-01-14 20:06:08.481282
================================================================================

CREATE VIEW [dbo].[Stok_iade_Miktar_Listesi] AS
CREATE VIEW [dbo].Stok_iade_Miktar_Listesi
AS

  select k.tip,k.kod,
  /*-aide miktar */
  isnull(sum(aiademik),0) as alsiade_mik,
  isnull(sum(aiademik*brmfiykdvli),0) alsiade_topkdvli,
  isnull(sum(siademik),0) as satiade_mik,
  isnull(sum(siademik*brmfiykdvli),0) as satiade_topkdvli
  from stokkart as k with (nolock)
  left join stkhrk as h with (nolock)
  on h.stktip=k.tip and h.stkod=k.kod
  and h.sil=0
  group by k.tip,k.kod

================================================================================
