-- View: dbo.V_ResSatHrk
-- Tarih: 2026-01-14 20:06:08.485904
================================================================================

CREATE VIEW [dbo].[V_ResSatHrk] AS
CREATE VIEW [dbo].[V_ResSatHrk]
AS
SELECT *, TutarKdvli - Tutar AS KdvTutar, ((Tutar / Miktar) - IndTutar) * (1 + KdvYuz)  AS NetBirimFiyat, (Tutar - IndTutar) * (1 + KdvYuz)  AS NetTutar
FROM (
SELECT     RSH.Id, RSH.OlusUser, RSH.OlusTarSaat, RSH.DegisUser, RSH.DegisTarSaat, RSH.Sil, RSH.VarNo, RSH.ResSatId, RSH.StkTipId, RSH.StkId, RS.Kod, RS.Ad, RSH.Miktar
			, RSH.Birim, RSH.BirimCarpan, RSH.BirimFiyat, RSH.KdvYuz, RSH.ParaBirim, RSH.Kur, RSH.Barkod, RSH.SatFiyNo, RSH.IndYuz
			, (RSH.Miktar * RSH.BirimFiyat) / (1 + RSH.KdvYuz) AS Tutar
			, RSH.Miktar * RSH.BirimFiyat AS TutarKdvli	
			, ((RSH.Miktar * RSH.BirimFiyat) / (1 + RSH.KdvYuz)) * IndYuz AS IndTutar	
FROM         dbo.ResSatHrk AS RSH INNER JOIN
             dbo.V_ResStok_01 AS RS ON RSH.StkId = RS.Id AND RSH.StkTipId = RS.TipId
WHERE     (ISNULL(RSH.Sil, 0) = 0)) AS TBL

================================================================================
