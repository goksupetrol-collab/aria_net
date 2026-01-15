-- Trigger: dbo.sayimmas_log_tri
-- Tablo: dbo.sayimmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.018599
================================================================================

CREATE TRIGGER [dbo].[sayimmas_log_tri] ON [dbo].[sayimmas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayimmas',1,''
end

================================================================================
