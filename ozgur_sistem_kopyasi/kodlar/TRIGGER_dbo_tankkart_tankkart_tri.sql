-- Trigger: dbo.tankkart_tri
-- Tablo: dbo.tankkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.037015
================================================================================

CREATE TRIGGER [dbo].[tankkart_tri] ON [dbo].[tankkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @tip      varchar(10)
declare @akkod    varchar(20)
declare @kod      varchar(20)
declare @depkod   varchar(20)
declare @id       FLOAT

select @id=id,@tip=stktip,@kod=kod,@akkod=bagak,@depkod=kod from inserted;

exec stokkartacilis @tip,@depkod,@akkod

EXEC numara_no_yaz 'tankkart',@kod


END

================================================================================
