-- View: dbo.Stok_Kart_Market
-- Tarih: 2026-01-14 20:06:08.482658
================================================================================

CREATE VIEW [dbo].[Stok_Kart_Market] AS
create VIEW [dbo].Stok_Kart_Market
AS
  select s.id,s.remote_id,s.tip,s.kod,s.grp1,s.grp2,s.grp3,
    s.firmano,s.ad,s.sat1fiy,s.sat1kdv,s.sat1kdvtip,
    s.sat2fiy,s.sat2kdv,s.sat2kdvtip,s.alsfiy,
    s.alskdv,s.alskdvtip,
    s.kesft,s.brim,s.otv,s.eksat,
    s.minmik,s.drm,s.muhgrskod,s.muhckskod,
    s.brmcarp,s.brmust,s.ykno,
    s.alsmik,s.satmik,s.sil,s.olususer,s.olustarsaat,
    s.deguser,s.degtarsaat,s.dataok,
    s.acmik,s.karoran1,s.karoran2,s.grpkdvoran,
    s.sat1pbrm,s.sat2pbrm,s.sat3pbrm,
    s.sat4pbrm,s.alspbrm,s.sat3fiy,
    s.sat3kdv,s.sat3kdvtip,s.sat4fiy,
    s.sat4kdv,s.sat4kdvtip,s.alsiademik,s.satiademik,
    s.brmust2,s.brmcarp2,
  (g.ad) as grup,
  (case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end ) as satiadesiztoptut,
  case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end satfiykdvli,
  case when sat1kdvtip='Hariç' then sat1fiy else sat1fiy/(1+(sat1kdv/100)) end satfiykdvsiz,
  ((case when sat1kdvtip='Hariç' then satkdvlitoptut else satkdvlitoptut/(1+(sat1kdv/100)) end )) sattutkdvsiz,
  case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end alsfiykdvli,
  case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end alsfiykdvsiz
  from stokkart as s WITH (NOLOCK)
  left join grup as g WITH (NOLOCK) on g.id=case when s.grp3>0 then s.grp3
  when s.grp2>0 then s.grp2
  when s.grp1>0 then s.grp1 end
  where s.tip='markt'

================================================================================
