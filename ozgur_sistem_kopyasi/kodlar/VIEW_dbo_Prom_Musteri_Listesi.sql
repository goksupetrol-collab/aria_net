-- View: dbo.Prom_Musteri_Listesi
-- Tarih: 2026-01-14 20:06:08.477254
================================================================================

CREATE VIEW [dbo].[Prom_Musteri_Listesi] AS
CREATE VIEW [dbo].Prom_Musteri_Listesi 
AS
  SELECT otk.id Ot_id,k.id,'1-'+cast(k.id as varchar(30)) idx,
  1 cartip_id,'carikart' cartip,k.firmano,
  k.grp1,k.grp2,k.grp3,g.ad as Grup_Ad,k.DogumTarih,
  k.kod,
  k.ad,k.soyad,k.unvan,k.sil,k.adres,k.adres2,
  k.evil,k.evilce,k.vergino,k.vergidaire,k.tel,k.fax,
  k.cep,k.mail,k.drm,k.parabrm,
  k.Prom_Grp1,
  ISNULL(bak.Giren_Puan,0) Giren_Puan,
  ISNULL(bak.Cikan_Puan,0) Cikan_Puan,
  ISNULL(bak.Mevcut_Puan,0) Mevcut_Puan,
  ISNULL(bak.Als_Tutar,0) Als_Tutar,
  ISNULL(bak.Kul_Tutar,0) Kul_Tutar,
  ISNULL(bak.Als_Tutar-Kul_Tutar,0) Kal_Tutar,
  bak.SonTarih,
  otk.prom_Grs,otk.Fis_Grs,otk.plaka,otk.kartno,otk.id As KartId
  from  carikart as k  with (nolock) inner join otomasgenkod as otk with (nolock) on
  otk.cartip_id=1 and otk.car_id=k.id and otk.prom_Grs=1 and isnull(otk.sil,0)=0
  left join Bakiye_Prom_Puan as bak with (nolock) on
  bak.Car_KartID=otk.id
  left join grup g with (nolock) on g.id=case 
  when k.grp3>0 then k.grp3 
  when k.grp2>0 then k.grp2 
  when k.grp1>0 then k.grp1 end
  UNION
  SELECT otk.id Ot_id,k.id,'7-'+cast(k.id as varchar(30)) idx,
  7 cartip_id,'perakendekart' as cartip,k.firmano,
  k.grp1,k.grp2,k.grp3,g.ad as Grup_Ad,k.DogumTarih,
  k.kod,
  k.ad,k.soyad,k.unvan,k.sil,k.adres,k.adres2,
  k.evil,k.evilce,k.vergino,k.vergidaire,k.tel,k.fax,
  k.cep,k.mail,k.drm,k.parabrm,
  k.Prom_Grp1,
  ISNULL(bak.Giren_Puan,0) Giren_Puan,
  ISNULL(bak.Cikan_Puan,0) Cikan_Puan,
  ISNULL(bak.Mevcut_Puan,0) Mevcut_Puan,
  ISNULL(bak.Als_Tutar,0) Als_Tutar,
  ISNULL(bak.Kul_Tutar,0) Kul_Tutar,
  ISNULL(bak.Als_Tutar-Kul_Tutar,0) Kal_Tutar,
  bak.SonTarih,
  otk.prom_Grs,otk.Fis_Grs,otk.plaka,otk.kartno,otk.id As KartId
  from perakendekart as k with (nolock) inner join otomasgenkod as otk with (nolock) on
  otk.cartip_id=7 and otk.car_id=k.id and otk.prom_Grs=1  and isnull(otk.sil,0)=0
  left join Bakiye_Prom_Puan as bak with (nolock) on
  bak.Car_KartID=otk.id 
  left join grup g with (nolock) on g.id=case 
  when k.grp3>0 then k.grp3 
  when k.grp2>0 then k.grp2 
  when k.grp1>0 then k.grp1 end

================================================================================
