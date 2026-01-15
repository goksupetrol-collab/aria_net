-- Trigger: dbo.perkart_tru
-- Tablo: dbo.perkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.993812
================================================================================

CREATE TRIGGER [dbo].[perkart_tru] ON [dbo].[perkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

declare @kod varchar(20);
DECLARE @id float;

select @id=id,@kod=kod from inserted;


END

================================================================================
