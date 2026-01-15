-- Trigger: dbo.sayackart_log_tri
-- Tablo: dbo.sayackart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.013660
================================================================================

CREATE TRIGGER [dbo].[sayackart_log_tri] ON [dbo].[sayackart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayackart',1,''
end

================================================================================
