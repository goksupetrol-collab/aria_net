-- Trigger: dbo.permaashrk_log_tri
-- Tablo: dbo.permaashrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.994633
================================================================================

CREATE TRIGGER [dbo].[permaashrk_log_tri] ON [dbo].[permaashrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'permaashrk',1,''
end

================================================================================
