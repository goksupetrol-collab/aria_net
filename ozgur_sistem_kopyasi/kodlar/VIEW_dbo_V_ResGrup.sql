-- View: dbo.V_ResGrup
-- Tarih: 2026-01-14 20:06:08.485492
================================================================================

CREATE VIEW [dbo].[V_ResGrup] AS
CREATE VIEW [dbo].[V_ResGrup]
AS
SELECT     id AS Id, sr AS Sr, sil AS Sil, firmano AS FirmaNo, tabload AS TabloAd, grp1 AS Grp1, grp2 AS Grp2, ad AS Ad, dataok AS DataOk, kar1 AS Kar1, kar2 AS Kar2, kdv AS Kdv, ykkisno AS YkkIsNo, 
                      kar3 AS Kar3, kar4 AS Kar4, Restaurant
FROM         dbo.grup
WHERE     (ISNULL(Sil, 0) = 0) AND (ISNULL(Restaurant, 0) = 1)

================================================================================
