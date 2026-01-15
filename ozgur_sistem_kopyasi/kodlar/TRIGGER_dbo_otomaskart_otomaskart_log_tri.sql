-- Trigger: dbo.otomaskart_log_tri
-- Tablo: dbo.otomaskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.984007
================================================================================

CREATE TRIGGER [dbo].[otomaskart_log_tri] ON [dbo].[otomaskart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'otomaskart',1,''
end

================================================================================
