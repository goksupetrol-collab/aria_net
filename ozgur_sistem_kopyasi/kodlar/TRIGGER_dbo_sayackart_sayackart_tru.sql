-- Trigger: dbo.sayackart_tru
-- Tablo: dbo.sayackart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.015417
================================================================================

CREATE TRIGGER [dbo].[sayackart_tru] ON [dbo].[sayackart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

END

================================================================================
