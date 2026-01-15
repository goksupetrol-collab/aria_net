-- Trigger: dbo.irsaliyemas_log_tri
-- Tablo: dbo.irsaliyemas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.955168
================================================================================

CREATE TRIGGER [dbo].[irsaliyemas_log_tri] ON [dbo].[irsaliyemas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'irsaliyemas',1,''
end

================================================================================
