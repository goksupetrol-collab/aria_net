-- Trigger: dbo.stkhrk_log_tri
-- Tablo: dbo.stkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.030481
================================================================================

CREATE TRIGGER [dbo].[stkhrk_log_tri] ON [dbo].[stkhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'stkhrk',1,''
end

================================================================================
