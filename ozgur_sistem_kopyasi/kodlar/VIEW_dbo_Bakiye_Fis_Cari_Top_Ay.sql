-- View: dbo.Bakiye_Fis_Cari_Top_Ay
-- Tarih: 2026-01-14 20:06:08.462677
================================================================================

CREATE VIEW [dbo].[Bakiye_Fis_Cari_Top_Ay] AS
CREATE VIEW [dbo].Bakiye_Fis_Cari_Top_Ay
AS
 select h.cartip,h.carkod,
 isnull(sum(bakiye),0) Bakiye,
 h.ay,h.Yil
 from Bakiye_Fis_Cari_Genel_Ay as h
 group by h.cartip,h.carkod,h.Yil,h.Ay

================================================================================
