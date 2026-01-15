-- View: dbo.Stok_Kart_Akaryakit_Listesi
-- Tarih: 2026-01-14 20:06:08.481628
================================================================================

CREATE VIEW [dbo].[Stok_Kart_Akaryakit_Listesi] AS
create VIEW [dbo].Stok_Kart_Akaryakit_Listesi
AS

 select s.id,s.remote_id,s.tip,s.kod,s.grp1,s.grp2,s.grp3,
    s.firmano,
    s.ad,s.sat1fiy,s.sat1kdv,s.sat1kdvtip,
    s.sat2fiy,s.sat2kdv,s.sat2kdvtip,
    s.alsfiy,s.alskdv,s.alskdvtip,
    s.kesft,s.brim,s.otv,s.eksat,
    s.minmik,s.drm,s.zrapor,
    s.muhgrskod,s.muhckskod,
    s.muhonkod,
    s.muh_als_iad_kod,s.muh_sat_iad_kod,
    s.muh_als_isk_kod,s.muh_sat_isk_kod,
    s.muh_als_otv_kod,s.muh_sat_otv_kod,
    s.muh_sat_mal_kod,
    s.brmcarp,s.brmust,s.ykno,
    s.alsmik,s.satmik,s.sil,s.olususer,s.olustarsaat,
    s.deguser,s.degtarsaat,s.dataok,
    s.acmik,s.karoran1,s.karoran2,s.grpkdvoran,
    s.sat1pbrm,s.sat2pbrm,s.sat3pbrm,
    s.sat4pbrm,s.alspbrm,s.sat3fiy,
    s.sat3kdv,s.sat3kdvtip,s.sat4fiy,
    s.sat4kdv,s.sat4kdvtip,s.alsiademik,s.satiademik,
    s.brmust2,s.brmcarp2,S.Epdk_Tur,
    
    
     mk.har_miktar,
     mk.gir_miktar,
     mk.cik_miktar,
     mk.gir_topkdvli,
     mk.gir_topkdvsiz,
     mk.cik_topkdvli,
     mk.cik_topkdvsiz,
     mk.mev_miktar,

     mk.alsiade_mik, /*alsiademik */
     mk.satiade_mik,  /*satiademik */
     mk.alsiade_topkdvli,
     mk.satiade_topkdvli,
     mk.ortals_fiykdvli,
     mk.ortals_fiykdvsiz,

 
 case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end satfiykdvli,
 case when sat1kdvtip='Hariç' then sat1fiy else sat1fiy/(1+(sat1kdv/100)) end satfiykdvsiz,
 case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end alsfiykdvli,
 case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end alsfiykdvsiz,

 case when sat1kdvtip='Hariç' then (mk.mev_miktar)*sat1fiy
 else (mk.mev_miktar)*(sat1fiy/(1+(sat1kdv/100))) end kalsattopkdvsiz,
 case when sat1kdvtip='Dahil' then (mk.mev_miktar)*sat1fiy
 else (mk.mev_miktar)*(sat1fiy*(1+(sat1kdv/100))) end kalsattopkdvli,
 case when alskdvtip='Hariç' then (mk.mev_miktar)*alsfiy
 else (mk.mev_miktar)*(alsfiy/(1+(alskdv/100))) end kalalstopkdvsiz,
 case when alskdvtip='Dahil' then (mk.mev_miktar)*alsfiy
 else (mk.mev_miktar)*(alsfiy*(1+(alskdv/100))) end kalalstopkdvli
 from stokkart as s  with (nolock)
 inner join Bakiye_Stok_Miktar as mk with (nolock) on mk.kod=s.kod and mk.tip=s.tip
 where s.tip='akykt'

================================================================================
