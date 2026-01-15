-- Trigger: dbo.sayackart_tri
-- Tablo: dbo.sayackart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.015010
================================================================================

CREATE TRIGGER [dbo].[sayackart_tri] ON [dbo].[sayackart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

EXEC sayacacilis @kod;

EXEC numara_no_yaz 'sayackart',@kod

END

================================================================================
