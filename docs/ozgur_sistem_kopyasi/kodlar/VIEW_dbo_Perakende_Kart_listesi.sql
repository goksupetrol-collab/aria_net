-- View: dbo.Perakende_Kart_listesi
-- Tarih: 2026-01-14 20:06:08.474674
================================================================================

CREATE VIEW [dbo].[Perakende_Kart_listesi] AS
CREATE VIEW [dbo].Perakende_Kart_listesi
AS
  SELECT k.id,k.firmano,k.sil,k.drm,
  k.kod,k.ad,k.soyad,k.unvan,k.grp1,k.grp2,k.grp3,
  k.ilgili,k.tel,k.fax,k.cep,k.muhkod,k.resim,k.adres,
  k.evil,k.evilce,k.vergidaire,k.vergino,k.mail,
  k.tcno,k.kulkod,k.kulsif,k.fisbak,k.carbak,
  k.olususer,k.olustarsaat,k.deguser,k.degtarsaat,
  k.dataok,k.parabrm,k.adres2,k.fisadet,
  k.muhonkod,k.fatunvan,k.webextre,k.Prom_Grp1,
  k.vergieposta,k.EFatura,k.EfaturaTip,
  k.TicSicilNo,k.DogumTarih,
  bak.fis_bakiye as fis_bakiye,
  bak.car_bakiye as car_bakiye,
  round((bak.fis_bakiye+bak.car_bakiye),2) top_bakiye,
  bak.sonhrk_tarih,
  bak.son_fis_tarih,
  bak.son_fis_tutar,
  bak.fis_adet,
  (k.fisbak+k.carbak) topbak,
  (g.ad) Grup from perakendekart as k
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  left join Bakiye_Perakende as bak on bak.kod=k.kod

================================================================================
