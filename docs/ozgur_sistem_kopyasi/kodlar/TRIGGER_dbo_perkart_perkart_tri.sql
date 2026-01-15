-- Trigger: dbo.perkart_tri
-- Tablo: dbo.perkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.993340
================================================================================

CREATE TRIGGER [dbo].[perkart_tri] ON [dbo].[perkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

EXEC carikartacilis 'perkart',@kod;

EXEC numara_no_yaz 'perkart',@kod

END

================================================================================
