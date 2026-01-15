-- View: dbo.Bakiye_Prom_Puan
-- Tarih: 2026-01-14 20:06:08.465472
================================================================================

CREATE VIEW [dbo].[Bakiye_Prom_Puan] AS
CREATE VIEW [dbo].Bakiye_Prom_Puan 
AS
  SELECT h.Car_KartID,
  ISNULL(sum(h.Puan_Giren),0) as Giren_Puan,
  ISNULL(sum(h.Puan_Cikan),0) as Cikan_Puan,
  ISNULL(sum(h.Puan_Giren-h.Puan_Cikan),0) as Mevcut_Puan,
  ISNULL(sum(case when h.Puan_Giren>0 then 
  h.Tutar_Kdvli else 0 end),0) as Als_Tutar,
  ISNULL(sum(case when h.Puan_Cikan>0 then 
  h.Tutar_Kdvli else 0 end),0) as Kul_Tutar,
  max(h.Tarih) SonTarih
  from Prom_Puan_Hrk as h with (nolock) 
  where h.Sil=0
  group by h.Car_KartID

================================================================================
