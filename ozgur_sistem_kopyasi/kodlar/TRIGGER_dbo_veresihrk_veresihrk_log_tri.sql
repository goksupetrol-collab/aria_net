-- Trigger: dbo.veresihrk_log_tri
-- Tablo: dbo.veresihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.040136
================================================================================

CREATE TRIGGER [dbo].[veresihrk_log_tri] ON [dbo].[veresihrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'veresihrk',1,''
end

================================================================================
