-- Trigger: dbo.veresimas_log_tri
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.043240
================================================================================

CREATE TRIGGER [dbo].[veresimas_log_tri] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'veresimas',1,''
end

================================================================================
