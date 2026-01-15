-- Trigger: dbo.poskart_tru
-- Tablo: dbo.poskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.006297
================================================================================

CREATE TRIGGER [dbo].[poskart_tru] ON [dbo].[poskart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

END

================================================================================
