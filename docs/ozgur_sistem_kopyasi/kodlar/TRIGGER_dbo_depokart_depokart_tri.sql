-- Trigger: dbo.depokart_tri
-- Tablo: dbo.depokart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.936341
================================================================================

CREATE TRIGGER [dbo].[depokart_tri] ON [dbo].[depokart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @kod      varchar(20)
declare @id       FLOAT

select @id=id,@kod=kod from inserted;

EXEC numara_no_yaz 'mardepkart',@kod


END

================================================================================
