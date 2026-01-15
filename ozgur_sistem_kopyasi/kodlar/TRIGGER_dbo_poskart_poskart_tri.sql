-- Trigger: dbo.poskart_tri
-- Tablo: dbo.poskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.005911
================================================================================

CREATE TRIGGER [dbo].[poskart_tri] ON [dbo].[poskart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;


EXEC numara_no_yaz 'poskart',@kod


END

================================================================================
