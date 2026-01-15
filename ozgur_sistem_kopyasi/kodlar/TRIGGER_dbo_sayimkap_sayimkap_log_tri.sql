-- Trigger: dbo.sayimkap_log_tri
-- Tablo: dbo.sayimkap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.017544
================================================================================

CREATE TRIGGER [dbo].[sayimkap_log_tri] ON [dbo].[sayimkap]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayimkap',1,''
end

================================================================================
