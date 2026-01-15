-- Trigger: dbo.perakendekart_log_tri
-- Tablo: dbo.perakendekart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.990161
================================================================================

CREATE TRIGGER [dbo].[perakendekart_log_tri] ON [dbo].[perakendekart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'perakendekart',1,''
end

================================================================================
