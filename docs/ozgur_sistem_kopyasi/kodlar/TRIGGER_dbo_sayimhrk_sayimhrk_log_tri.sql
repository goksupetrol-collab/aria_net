-- Trigger: dbo.sayimhrk_log_tri
-- Tablo: dbo.sayimhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.016128
================================================================================

CREATE TRIGGER [dbo].[sayimhrk_log_tri] ON [dbo].[sayimhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayimhrk',1,''
end

================================================================================
