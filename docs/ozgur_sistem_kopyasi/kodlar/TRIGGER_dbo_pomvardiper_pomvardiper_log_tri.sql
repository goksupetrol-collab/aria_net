-- Trigger: dbo.pomvardiper_log_tri
-- Tablo: dbo.pomvardiper
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.999693
================================================================================

CREATE TRIGGER [dbo].[pomvardiper_log_tri] ON [dbo].[pomvardiper]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'pomvardiper',1,''
end

================================================================================
