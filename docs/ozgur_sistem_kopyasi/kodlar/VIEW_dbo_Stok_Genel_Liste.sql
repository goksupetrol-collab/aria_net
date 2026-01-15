-- View: dbo.Stok_Genel_Liste
-- Tarih: 2026-01-14 20:06:08.480568
================================================================================

CREATE VIEW [dbo].[Stok_Genel_Liste] AS
CREATE VIEW [dbo].Stok_Genel_Liste 
 AS
 select 
  k.firmano,
  k.id,
  k.tip_id,
  k.tip,
  ('-') as Tipi,
  k.kod AS kod,
  k.ad AS ad,
  k.sil,
  k.grp1,k.grp2,k.grp3,
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
  case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end  alsfiykdvsiz,
  k.Prom,k.Puan_Tip,k.Puan_Brm,k.Puan_Nakit,k.Puan_KK,k.Puan_Fis
  from stokkart as k with (nolock)
  
  UNION
  select
  k.firmano, 
  k.id,
  (3) tip_id,
  'gelgid' as tip,
  ('gelgidkart') as Tipi,
  k.kod AS kod,
  k.ad AS ad,
  k.sil,
  k.grp1,
  k.grp2,
  k.grp3,
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
  0  alsfiykdvsiz,
  k.Prom,k.Puan_Tip,k.Puan_Brm,k.Puan_Nakit,k.Puan_KK,k.Puan_Fis
  from gelgidkart as k with (nolock)

================================================================================
