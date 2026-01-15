-- Trigger: dbo.carikart_tru
-- Tablo: dbo.carikart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.929097
================================================================================

CREATE TRIGGER [dbo].[carikart_tru] ON [dbo].[carikart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;


END

================================================================================
