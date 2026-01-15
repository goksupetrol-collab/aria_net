-- Trigger: dbo.otomaskart_trd
-- Tablo: dbo.otomaskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.985124
================================================================================

CREATE TRIGGER [dbo].[otomaskart_trd] ON [dbo].[otomaskart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @otamskod varchar(30);

select @otamskod=otmaskod from deleted;


delete from otomaskarthrk where otmaskod=@otamskod;






END

================================================================================
