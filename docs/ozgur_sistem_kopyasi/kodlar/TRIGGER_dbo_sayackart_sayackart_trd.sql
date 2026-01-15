-- Trigger: dbo.sayackart_trd
-- Tablo: dbo.sayackart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.014497
================================================================================

CREATE TRIGGER [dbo].[sayackart_trd] ON [dbo].[sayackart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @kod varchar(30)

select @kod=kod from deleted;

delete from sayachrk where sayackod=@kod;

END

================================================================================
