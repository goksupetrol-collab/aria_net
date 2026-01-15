-- Trigger: dbo.istkart_tru
-- Tablo: dbo.istkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.959452
================================================================================

CREATE TRIGGER [dbo].[istkart_tru] ON [dbo].[istkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

END

================================================================================
