-- Trigger: dbo.otomaskarthrk_log_tri
-- Tablo: dbo.otomaskarthrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.986095
================================================================================

CREATE TRIGGER [dbo].[otomaskarthrk_log_tri] ON [dbo].[otomaskarthrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'otomaskarthrk',1,''
end

================================================================================
