-- Trigger: dbo.sayachrk_log_tri
-- Tablo: dbo.sayachrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.011875
================================================================================

CREATE TRIGGER [dbo].[sayachrk_log_tri] ON [dbo].[sayachrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayachrk',1,''
end

================================================================================
