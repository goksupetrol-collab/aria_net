-- View: dbo.View_Cariler_Kart_Bakiye
-- Tarih: 2026-01-14 20:06:08.489470
================================================================================

CREATE VIEW [dbo].[View_Cariler_Kart_Bakiye] AS
CREATE VIEW [dbo].View_Cariler_Kart_Bakiye
AS
  SELECT k.id,k.sil as sl,k.kod as kod,k.unvan as ad,k.grp1,k.grp2,k.grp3,
  k.fatunvan as fatunvan,'carikart' as cartp,fisvadfark,fatvadfark,
  (1) as crno,k.tcno, ('CARİ KARTLAR') as tip,k.adres,k.adres2,
  k.evil,k.evilce,k.vergidaire,k.vergino,
  k.ykt_alm_def_no,k.Arac_Ad,
  k.tel,k.cep,k.fax,k.mail,
  fis_bakiye as fisbak,car_bakiye as carbak,top_bakiye as topbak,
  k.toplamlimit as Toplimit,cekharc_bakiye,cek_bakiye,
  k.Grup as Grup_Ad
  from Cari_Kart_Listesi as k

  UNION all
   SELECT k.id,k.sil as sl,k.kod,k.ad+' '+k.soyad as ad,k.grp1,k.grp2,k.grp3,
   k.ad+' '+k.soyad as fatunvan,'perkart' as cartp,0,0,
  (1) as crno,('')tcno,('PERSONEL KARTLARI') as tip,
  ('') as adres,('') as adres2,evil,evilce,('') as vergidaire,('') as vergino,
  ('') ykt_alm_def_no,('') Arac_Ad,
  k.tel,k.cep,k.fax,k.mail,
  fis_bakiye as fisbak,car_bakiye as carbak,top_bakiye as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  k.grup as Grup_Ad
  from Personel_Kart_Listesi as k
   
  UNION all
  SELECT k.id,k.sil as sl,k.kod,k.unvan as ad,k.grp1,k.grp2,k.grp3,
  k.unvan as fatunvan,'perakendekart' as cartp,0,0,
  (6) as crno,k.tcno,('PERAKENDE KARTLAR') as tip,
  k.adres,k.adres2,evil,evilce,k.vergidaire,k.vergino,
  ('') ykt_alm_def_no,('') Arac_Ad,
  k.tel,k.cep,k.fax,k.mail,
  fis_bakiye as fisbak,car_bakiye as carbak,top_bakiye as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  k.grup as Grup_Ad
  from Perakende_Kart_listesi as k
   UNION all
  SELECT k.id,k.sil as sl,k.kod,k.ad,k.grp1,k.grp2,k.grp3,
  k.ad as fatunvan,'gelgidkart' as cartp,0,0,
  (1) as crno,('')tcno,('GELİR-GİDER KARTLARI') as tip,
  ('') as adres,('') as adres2,('') as evil,('') as evilce,('') as vergidaire,
  ('') as vergino,
  ('') ykt_alm_def_no,('') Arac_Ad,
  ('')tel,('')cep,('')fax,('') mail,
  fis_bakiye as fisbak,car_bakiye as carbak,top_bakiye as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  k.grup as Grup_Ad
  from Gel_Gid_Kart_Listesi as k
  UNION all
  SELECT k.id,k.sil as sl,k.kod,k.ad,k.grp1,k.grp2,k.grp3,
  k.ad as fatunvan,'bankakart' as cartp,0,0,
  (3) as crno,('')tcno,('BANKA KARTLARI') as tip,
  ('') as adres,('') as adres2,('') as evil,('') as evilce,
  ('') as vergidaire,('') as vergino,
   ('') ykt_alm_def_no,('') Arac_Ad,
  k.tel,('') cep,k.fax,('') mail,
  0 as fisbak,0 as carbak,top_bakiye as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  k.grup as Grup_Ad
  from Banka_Kart_Listesi as k
  
  
  UNION all
  SELECT k.id,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2, 0 grp3,
  k.ad as fatunvan,'poskart' as cartp,0,0,
  (3) as crno,('')tcno,('POS KARTLARI') as tip,
  ('') as adres,('') as adres2,('') as evil,('') as evilce,
  ('') as vergidaire,('') as vergino,
   ('') ykt_alm_def_no,('') Arac_Ad,
  ('') tel,('') cep,('') fax,('') mail,
  0 as fisbak,0 as carbak,nettutar as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  ('') Grup_Ad
  from Pos_Kart_Listesi as k
  
  
  
   
  UNION all
  SELECT k.id,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2, 0 grp3,
  k.ad as fatunvan,'istkart' as cartp,0,0,
  (3) as crno,('')tcno,('İSLETME K. KARTLARI') as tip,
  ('') as adres,('') as adres2,('') as evil,('') as evilce,
  ('') as vergidaire,('') as vergino,
   ('') ykt_alm_def_no,('') Arac_Ad,
  ('') tel,('') cep,('') fax,('') mail,
  0 as fisbak,0 as carbak,top_bakiye as topbak,
  0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
  ('') Grup_Ad
  from istkredi_Kart_Listesi as k
  
  
   union all
   SELECT k.id,k.sil as sl,k.kod,k.ad,0 grp1,0 grp2,0 grp3,
   k.ad as fatunvan,'kasakart' as cartp,0,0,
   (4) as crno,('')tcno,('KASA KARTLARI') as tip,
   ('') as adres,('') as adres2,('') as evil,('') as evilce,
   ('') as vergidaire,('') as vergino,
    ('') ykt_alm_def_no,('') Arac_Ad,
   ('') tel,('') cep,('') fax,('') mail,
   0 as fisbak,0 as carbak,0 as topbak,
   0 as Toplimit,0 cekharc_bakiye,0 cek_bakiye,
   ('') Grup_Ad from KasaKart as k

================================================================================
