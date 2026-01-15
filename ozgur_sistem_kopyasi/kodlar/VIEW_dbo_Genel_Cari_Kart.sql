-- View: dbo.Genel_Cari_Kart
-- Tarih: 2026-01-14 20:06:08.471876
================================================================================

CREATE VIEW [dbo].[Genel_Cari_Kart] AS
CREATE VIEW Genel_Cari_Kart
AS
  SELECT k.id,k.sil,k.kod as kod,
  K.Ad as Ad,K.Soyad as Soyad,
  k.unvan as Unvan,
  k.grp1,k.grp2,k.grp3,
  k.fatunvan as fatunvan,
  'carikart' as cartip,1 CarTip_id,k.per_id,
  '1-'+CAST(k.id as varchar(50)) Uniq_id,
  k.muhkod,k.muhonkod,(1) as crno,k.tcno,g.ad as grupad1,
  k.tel,k.fax,k.cep,k.mail,K.AdresPostaKod, 
  k.vergikimlikno As VergiKNo,K.VergiEposta,K.Efatura,
  k.EfaturaTip,k.TicSicilNo,k.webadres,
  ('CARİ KARTLAR') as tip,
  k.adres,k.adres2,k.evil,k.evilce,
  k.vergidaire,k.vergino,k.fisisk as fis_iskonto,k.fatisk as fat_iskonto,
  k.Oto_FisVadeFark,k.fisvadtip,k.fisvadsur
  from Carikart as k with (nolock)
  left join grup as g with (nolock) on g.id=k.grp1
  UNION all
  
  SELECT k.id,k.sil,k.kod,
  K.Ad as Ad,K.Soyad as Soyad,
  k.ad+' '+k.soyad as Unvan,k.grp1,k.grp2,k.grp3,
   ''as fatunvan,'perkart' as cartip,2 CarTip_id,0 per_id,
  '2-'+CAST(k.id as varchar(50)) Uniq_id,
  k.muhkod,k.muhonkod,(1) as crno,('')tcno,g.ad as grupad1,
  k.tel,k.fax,k.cep,k.mail,'' AdresPostaKod,'' As VergiKNo,'' As VergiEposta,0 Efatura,
  0 EfaturaTip,'' TicSicilNo,'' webadres,
  ('PERSONEL KARTLARI') as tip,
  ('') as adres,('') as adres2,evil,evilce,('') as vergidaire,('') as vergino,
  (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
  ('') fisvadtip,(0) fisvadsur
  from Perkart as k with (nolock)
  left join grup as g with (nolock) on g.id=k.grp1
  UNION all
   
   SELECT k.id,k.sil,k.kod,
   K.Ad as Ad,'' as Soyad,k.ad Unvan,
   k.grp1,k.grp2,k.grp3,
   ''as fatunvan,'gelgidkart' as cartip,3 CarTip_id,0 per_id,
   '3-'+CAST(k.id as varchar(50)) Uniq_id,
   k.muhkod,k.muhonkod,(1) as crno,('')tcno,g.ad as grupad1,
   '' tel,'' fax,'' cep,'' mail,'' AdresPostaKod,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('GELİR-GİDER KARTLARI') as tip,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,('') as vergidaire,
   ('') as vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   ('') fisvadtip,(0) fisvadsur
   from GelGidKart as k with (nolock)
   left join grup as g with (nolock) on g.id=k.grp1
   UNION all 
   
 
  SELECT k.id,k.sil,k.kod,
  K.Ad as Ad,K.Soyad as Soyad,k.unvan,
  k.grp1,k.grp2,k.grp3,
  ''as fatunvan,'perakendekart' as cartip,7 CarTip_id,0 per_id,
  '7-'+CAST(k.id as varchar(50)) Uniq_id,
  k.muhkod,k.muhonkod,(6) as crno,k.tcno,g.ad as grupad1,
  k.tel,k.fax,k.cep,k.mail,'' AdresPostaKod,
  k.vergino As VergiKNo,K.VergiEposta,K.Efatura,
  k.EfaturaTip,k.TicSicilNo,('')webadres, 
  ('PERAKENDE KARTLAR') as tip,
  k.adres,k.adres2,evil,evilce,k.vergidaire,k.vergino,
  (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
  ('') fisvadtip,(0) fisvadsur
  from PerakendeKart as k with (nolock)
  left join grup as g with (nolock) on g.id=k.grp1

================================================================================
