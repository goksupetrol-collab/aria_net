-- Trigger: dbo.bankakart_tri
-- Tablo: dbo.bankakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.923023
================================================================================

CREATE TRIGGER [dbo].[bankakart_tri] ON [dbo].[bankakart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

EXEC carikartacilis 'bankakart',@kod;

EXEC numara_no_yaz 'bankakart',@kod


END

================================================================================
