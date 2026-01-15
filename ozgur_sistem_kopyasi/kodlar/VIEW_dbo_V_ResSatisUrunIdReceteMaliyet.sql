-- View: dbo.V_ResSatisUrunIdReceteMaliyet
-- Tarih: 2026-01-14 20:06:08.486321
================================================================================

CREATE VIEW [dbo].[V_ResSatisUrunIdReceteMaliyet] AS
CREATE VIEW [dbo].[V_ResSatisUrunIdReceteMaliyet] 
AS
  SELECT rh.ResSatId,rh.ResSatHrkId,Max(Id) as ResSatRecHrkId,
  UrunId,Sum(BirimMaliyetFiyat*Miktar) BirimMaliyetFiyat
  From ResSatRecHrk  as rh with (nolock) 
  Where Sil=0 
  Group by ResSatId,ResSatHrkId,UrunId

================================================================================
