-- Trigger: dbo.bankakart_tru
-- Tablo: dbo.bankakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.923338
================================================================================

CREATE TRIGGER [dbo].[bankakart_tru] ON [dbo].[bankakart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;


END

================================================================================
