-- Trigger: dbo.carikart_tri
-- Tablo: dbo.carikart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.928730
================================================================================

CREATE TRIGGER [dbo].[carikart_tri] ON [dbo].[carikart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;
declare @userid int;

select @id=id,@kod=kod
from inserted;

EXEC carikartacilis 'carikart',@kod;

EXEC numara_no_yaz 'carikart',@kod


END

================================================================================
