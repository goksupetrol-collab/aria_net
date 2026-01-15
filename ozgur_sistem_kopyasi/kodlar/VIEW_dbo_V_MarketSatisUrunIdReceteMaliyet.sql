-- View: dbo.V_MarketSatisUrunIdReceteMaliyet
-- Tarih: 2026-01-14 20:06:08.484964
================================================================================

CREATE VIEW [dbo].[V_MarketSatisUrunIdReceteMaliyet] AS
CREATE VIEW dbo.V_MarketSatisUrunIdReceteMaliyet 
AS
  SELECT rh.MarSatId,rh.MarSatHrkId,Max(Id) as MarSatRecHrkId,
  UrunId,Sum(BirimMaliyetFiyat*Miktar) BirimMaliyetFiyat
  From MarSatRecHrk  as rh with (nolock) 
  Where Sil=0 
  Group by MarSatId,MarSatHrkId,UrunId

================================================================================
