-- View: dbo.RehberKartListesi
-- Tarih: 2026-01-14 20:06:08.479145
================================================================================

CREATE VIEW [dbo].[RehberKartListesi] AS
CREATE VIEW dbo.RehberKartListesi
As 
  SELECT 
  r.Id,r.FirmaNo,r.Kod,r.Unvan,r.CepNo,r.GrupId,r.OlusturmaTarihSaat,r.OlusturmaKullaniciUnvan,
  r.DegistirmeTarihSaat,r.DegistirmeKullaniciUnvan,r.SilTarihSaat,r.SilKullaniciUnvan,
  r.RemoteId,r.TransferStartId,r.TransferStopId,r.Sil,r.ParaBirim,r.Durum,
  g.ad as Grupad,
  bak.fis_bakiye as fis_bakiye,
  bak.car_bakiye as car_bakiye,
  round((bak.fis_bakiye+bak.car_bakiye),2) top_bakiye,
  bak.sonhrk_tarih,
  bak.son_fis_tarih,
  bak.son_fis_tutar,
  bak.fis_adet,
  (bak.fis_bakiye+bak.car_bakiye) topbak  
  FROM  RehberKart as r with (nolock) 
  left join RehberGrup as g with (nolock)  on g.Id=r.GrupId
  left join Bakiye_Rehber as bak on bak.kod=r.kod

================================================================================
