-- Trigger: dbo.gelgidkart_tru
-- Tablo: dbo.gelgidkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.949479
================================================================================

CREATE TRIGGER [dbo].[gelgidkart_tru] ON [dbo].[gelgidkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;

END

================================================================================
