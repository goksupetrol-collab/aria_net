-- View: dbo.V_ResSatMas
-- Tarih: 2026-01-14 20:06:08.486673
================================================================================

CREATE VIEW [dbo].[V_ResSatMas] AS
CREATE VIEW [dbo].[V_ResSatMas]
AS
SELECT     Id, OlusUser, OlusTarSaat, DegisUser, DegisTarSaat, Sil, VarNo, FirmaNo, Tarih, Saat,  Iade, DepoKod,
ParaBirim 
FROM         dbo.ResSatMas WITH (NOLOCK)
WHERE     (ISNULL(Sil, 0) = 0) AND (Iade = 0)

================================================================================
