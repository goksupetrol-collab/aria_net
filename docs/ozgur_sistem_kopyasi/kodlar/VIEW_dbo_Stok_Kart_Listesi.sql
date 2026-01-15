-- View: dbo.Stok_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.482308
================================================================================

CREATE VIEW [dbo].[Stok_Kart_Listesi] AS
create VIEW [dbo].Stok_Kart_Listesi
AS
  select
  k.id,k.remote_id,
  'S'+convert(varchar,k.id) UniqueId,
  k.firmano, 
  K.tip_id,
  k.tip,
  k.kod AS kod,
  k.ad AS ad,
  k.sil,
  k.grp1,k.grp2,k.grp3,
  mk.mev_miktar,
  k.alskdv,
  k.sat1kdv,
  k.sat2kdv,
  k.sat3kdv,
  k.sat4kdv,
  case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end sat1fiykdvli,
  case when sat1kdvtip='Hariç' then sat1fiy else sat1fiy/(1+(sat1kdv/100)) end sat1fiykdvsiz,
  case when sat2kdvtip='Dahil' then sat2fiy else sat2fiy*(1+(sat1kdv/100)) end sat2fiykdvli,
  case when sat2kdvtip='Hariç' then sat2fiy else sat2fiy/(1+(sat1kdv/100)) end sat2fiykdvsiz,
  case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end  alsfiykdvli,
  case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end  alsfiykdvsiz
  from stokkart as k with (nolock)
  inner join Bakiye_Stok_Miktar as mk with (nolock) on mk.kod=k.kod and mk.tip=k.tip
  
  UNION
  select 
  k.id,k.remote_id,
  'G'+convert(varchar,k.id) UniqueId,
  k.firmano,
  K.tip_id,
  'gelgid' as tip,
  k.kod AS kod,
  k.ad AS ad,
  k.sil,
  k.grp1,
  k.grp2,
  k.grp3,
  0 mev_miktar,
  0 alskdv,
  k.kdv as sat1kdv,
  0 sat2kdv,
  0 sat3kdv,
  0 sat4kdv,
  case when k.kdvtip='Dahil' then k.fiyat else fiyat*(1+(k.kdv/100)) end sat1fiykdvli,
  case when k.kdvtip='Hariç' then k.fiyat else k.fiyat/(1+(k.kdv/100)) end sat1fiykdvsiz,
  0  sat2fiykdvli,
  0  sat2fiykdvsiz,
  0  alsfiykdvli,
  0  alsfiykdvsiz
  from gelgidkart as k with (nolock)

================================================================================
