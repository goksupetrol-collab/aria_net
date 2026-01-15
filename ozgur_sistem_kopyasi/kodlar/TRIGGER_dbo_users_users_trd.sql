-- Trigger: dbo.users_trd
-- Tablo: dbo.users
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.038546
================================================================================

CREATE TRIGGER [dbo].[users_trd] ON [dbo].[users]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
SET NOCOUNT ON

DECLARE @KOD VARCHAR(50);

SELECT @KOD=KOD FROM DELETED


SET NOCOUNT OFF


END

================================================================================
