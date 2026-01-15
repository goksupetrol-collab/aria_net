-- Trigger: dbo.istkart_tri
-- Tablo: dbo.istkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.958719
================================================================================

CREATE TRIGGER [dbo].[istkart_tri] ON [dbo].[istkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

EXEC numara_no_yaz 'istkredikart',@kod

EXEC carikartacilis 'istkredikart',@kod;


END

================================================================================
