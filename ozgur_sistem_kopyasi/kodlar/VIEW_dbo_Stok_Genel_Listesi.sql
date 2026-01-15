-- View: dbo.Stok_Genel_Listesi
-- Tarih: 2026-01-14 20:06:08.480920
================================================================================

CREATE VIEW [dbo].[Stok_Genel_Listesi] AS
CREATE VIEW [dbo].Stok_Genel_Listesi
AS
  select k.kod AS kod,k.ad AS ad,
  (g.ad) as grup_ad,
  case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end sat1fiykdvli,
  case when sat1kdvtip='Hariç' then sat1fiy else sat1fiy/(1+(sat1kdv/100)) end sat1fiykdvsiz,
  case when sat2kdvtip='Dahil' then sat2fiy else sat2fiy*(1+(sat2kdv/100)) end sat2fiykdvli,
  case when sat2kdvtip='Hariç' then sat2fiy else sat2fiy/(1+(sat2kdv/100)) end sat2fiykdvsiz,
  case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end  alsfiykdvli,
  case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end  alsfiykdvsiz

  from stokkart as k with (nolock)
  left join Bakiye_Stok_Miktar as h with (nolock) on h.tip=k.tip and h.kod=k.kod
  left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end

================================================================================
