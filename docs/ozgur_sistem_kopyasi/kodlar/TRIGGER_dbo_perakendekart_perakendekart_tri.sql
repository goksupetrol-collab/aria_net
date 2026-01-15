-- Trigger: dbo.perakendekart_tri
-- Tablo: dbo.perakendekart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.990863
================================================================================

CREATE TRIGGER [dbo].[perakendekart_tri] ON [dbo].[perakendekart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

EXEC numara_no_yaz 'perakendekart',@kod

END

================================================================================
