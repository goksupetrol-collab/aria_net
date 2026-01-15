-- Trigger: dbo.irsaliyehrk_log_tri
-- Tablo: dbo.irsaliyehrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.952447
================================================================================

CREATE TRIGGER [dbo].[irsaliyehrk_log_tri] ON [dbo].[irsaliyehrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'irsaliyehrk',1,''
end

================================================================================
