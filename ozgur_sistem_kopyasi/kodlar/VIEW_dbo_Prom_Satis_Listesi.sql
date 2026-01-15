-- View: dbo.Prom_Satis_Listesi
-- Tarih: 2026-01-14 20:06:08.477766
================================================================================

CREATE VIEW [dbo].[Prom_Satis_Listesi] AS
CREATE VIEW [dbo].Prom_Satis_Listesi 
AS
  SELECT p.*,k.kod,k.unvan
  From Prom_Sat_Baslik as p with (nolock) 
  inner join Prom_Musteri_Listesi as k with (nolock) on
  p.cartip_id=k.cartip_id and p.car_id=k.id
  and p.KartId=k.KartId

================================================================================
