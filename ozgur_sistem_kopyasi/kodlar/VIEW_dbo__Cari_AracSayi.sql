-- View: dbo._Cari_AracSayi
-- Tarih: 2026-01-14 20:06:08.453330
================================================================================

CREATE VIEW [dbo].[_Cari_AracSayi] AS
create VIEW [dbo]._Cari_AracSayi
AS
  SELECT cartip,kod,count(id) Arac_Sayi from otomasgenkod
  where cartip='carikart'   group by cartip,kod

================================================================================
