-- Trigger: dbo.stokkart_trd
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.033992
================================================================================

CREATE TRIGGER [dbo].[stokkart_trd] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @tip varchar(10)
declare @kod varchar(20)
declare @deguser varchar(100)

  select @tip=tip,@kod=kod,@deguser=deguser from deleted;

  update barkod Set Sil=1,deguser=@deguser,degtarsaat=GetDate() where tip=@tip and kod=@kod



END

================================================================================
