-- View: dbo.Genel_Kart
-- Tarih: 2026-01-14 20:06:08.472324
================================================================================

CREATE VIEW [dbo].[Genel_Kart] AS
CREATE VIEW Genel_Kart
AS
  SELECT k.id,k.firmano,k.sil as sl,k.kod as kod,k.unvan as ad,k.grp1,k.grp2,k.grp3,
  k.Prom_Grp1,k.fatunvan as fatunvan,
  'carikart' as cartp,1 Tip_id,k.Per_id,
  k.muhkod,k.muhonkod,(1) as crno,k.tcno,k.tel,
  k.fax,k.cep,k.mail,
  k.vergikimlikno As VergiKNo,K.VergiEposta,K.Efatura,
  k.EfaturaTip,k.TicSicilNo,k.webadres,
  g.ad as grupad1,
  ('CARİ KARTLAR') as tip,K.TurId,
  k.adres,k.adres2,k.evil,k.evilce,
  k.vergidaire,k.vergino,k.fisisk as fis_iskonto,k.fatisk as fat_iskonto,
  K.Oto_FisVadeFark,
  k.BankaKod,K.BankaDbs,bk.Ad As BankaAd
  from Carikart as k with (nolock)
  left join bankakart as bk with (nolock) on bk.Kod=k.BankaKod
  left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end
  UNION all
  
  SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad+' '+k.soyad as ad,k.grp1,k.grp2,k.grp3,
  (0) as Prom_Grp1, ''as fatunvan,'perkart' as cartp,2 Tip_id,0 Per_id,
  k.muhkod,k.muhonkod,(1) as crno,('')tcno,k.tel,
  k.fax,k.cep,k.mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
  0 EfaturaTip,'' TicSicilNo,'' webadres,
  g.ad as grupad1,('PERSONEL KARTLARI') as tip,1 TurId,
  ('') as adres,('') as adres2,evil,evilce,('') as vergidaire,('') as vergino,
  (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
  '' BankaKod,'' BankaDbs,'' As BankaAd
  from Perkart as k with (nolock)
  left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end
  UNION all
   
  SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad,k.grp1,k.grp2,k.grp3,
   (0) as Prom_Grp1,''as fatunvan,'gelgidkart' as cartp,3 Tip_id,0 Per_id,
   k.muhkod,k.muhonkod,(1) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   g.ad as grupad1,('GELİR-GİDER KARTLARI') as tip,1 TurId,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,('') as vergidaire,
   ('') as vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd
   from GelGidKart as k with (nolock)
   left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
   when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end
   UNION all 
   
   SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad,k.grp1,k.grp2,k.grp3,
   (0) as Prom_Grp1,''as fatunvan,'bankakart' as cartp,4 Tip_id,0 Per_id,
   k.muhkod,k.muhonkod,(3) as crno,('')tcno,k.tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   g.ad as grupad1,('BANKA KARTLARI') as tip,1 TurId,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,
   ('') as vergidaire,('') as vergino,
   (0) fis_iskonto,(0) as fat_iskonto, 0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd
   from BankaKart as k with (nolock)
   left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
   when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end
   UNION all
   
   SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2,0 grp3,
  (0) as Prom_Grp1,''as fatunvan,'poskart' as cartp,5 Tip_id,0 Per_id,
  k.muhkod,k.muhonkod,(2) as crno,('')tcno,'' tel,
  '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
   0 EfaturaTip,'' TicSicilNo,'' webadres,
  ('') as grupad1,('POS KARTLARI') as tip,1 TurId,
  ('') as adres,('') as adres2,
  ('') as evil,('') as evilce,('') as vergidaire,('') as vergino,
  (0) fis_iskonto,(0) as fat_iskonto, 0 Oto_FisVadeFark,
  '' BankaKod,'' BankaDbs,'' As BankaAd
  from PosKart as k with (nolock)
  UNION all
  
  SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2,0 grp3,
   (0) as Prom_Grp1,''as fatunvan,'istkart' as cartp,6 Tip_id,0 Per_id,
   k.muhkod,k.muhonkod,(5) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('') as grupad1,('İŞLETME KREDI KARTLARI') as tip,1 TurId,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,('') as vergidaire,
   ('') as vergino,(0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd 
   from istkart as k with (nolock)
   UNION all
  
  SELECT k.id,k.firmano,k.sil as sl,k.kod,k.unvan as ad,k.grp1,k.grp2,k.grp3,
  k.Prom_Grp1,''as fatunvan,'perakendekart' as cartp,7 Tip_id,0 Per_id,
  k.muhkod,k.muhonkod,(6) as crno,('')tcno,k.tel,
  '' fax,cep,'' mail,k.vergino As VergiKNo,'' As VergiEposta,0 Efatura,
   0 EfaturaTip,'' TicSicilNo,'' webadres,
  g.ad as grupad1,('PERAKENDE KARTLAR') as tip,1 TurId,
  k.adres,k.adres2,evil,evilce,k.vergidaire,k.vergino,
  (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
  '' BankaKod,'' BankaDbs,'' As BankaAd 
  from PerakendeKart as k with (nolock)
  left join grup as g with (nolock) on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end
  UNION all


   SELECT k.id,k.firmano,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2,0 grp3,
   (0) as Prom_Grp1,''as fatunvan,'kasakart' as cartp,8 Tip_id,0 Per_id,
   k.muhkod,k.muhonkod,(4) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('') as grupad1,('KASA KARTLARI') as tip,1 TurId,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,
   ('') as vergidaire,('') as vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd 
   from KasaKart as k with (nolock)
   UNION all
   
   SELECT k.id,0 firmano,k.sil as sl,kod,ad as ad,0 grp1,0 grp2,0 grp3,
   (0) as Prom_Grp1,''as fatunvan,'vardicek' as cartp,9 Tip_id,0 Per_id,
   ('')muhkod,('') muhonkod,(1) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('') as grupad1,tip,1 TurId,
   ('')adres,('')adres2,('')evil,('')evilce,('')vergidaire,('') vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd
   from Harici_Kart as k with (nolock) where tip_id=9
   UNION all
   
   SELECT k.id,0 firmano,k.sil as sl,kod,ad as ad,0 grp1,0 grp2,0 grp3,
   (0) as Prom_Grp1,''as fatunvan,'vardikasa' as cartp,10 Tip_id,0 Per_id,
   ('')muhkod,('') muhonkod,(1) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('') as grupad1,tip,1 TurId,
   ('')adres,('')adres2,('')evil,('')evilce,('')vergidaire,('') vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd 
   from Harici_Kart as k with (nolock) where tip_id=10
   UNION all
   
    SELECT k.id,0 firmano,k.sil as sl,kod,ad as ad,0 grp1,0 grp2,0 grp3,
   (0) as Prom_Grp1,''as fatunvan,'vardihes' as cartp,11 Tip_id,0 Per_id,
   ('')muhkod,('') muhonkod,(1) as crno,('')tcno,'' tel,
   '' fax,'' cep,'' mail,'' As VergiKNo,'' As VergiEposta,0 Efatura,
    0 EfaturaTip,'' TicSicilNo,'' webadres,
   ('') as grupad1,tip,1 TurId,
   ('')adres,('')adres2,('')evil,('')evilce,('')vergidaire,('') vergino,
   (0) fis_iskonto,(0) as fat_iskonto,0 Oto_FisVadeFark,
   '' BankaKod,'' BankaDbs,'' As BankaAd 
   from Harici_Kart as k with (nolock) where tip_id=11

================================================================================
