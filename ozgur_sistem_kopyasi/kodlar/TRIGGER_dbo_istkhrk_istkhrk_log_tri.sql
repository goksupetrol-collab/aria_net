-- Trigger: dbo.istkhrk_log_tri
-- Tablo: dbo.istkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.960985
================================================================================

CREATE TRIGGER [dbo].[istkhrk_log_tri] ON [dbo].[istkhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'istkhrk',1,''
end

================================================================================
