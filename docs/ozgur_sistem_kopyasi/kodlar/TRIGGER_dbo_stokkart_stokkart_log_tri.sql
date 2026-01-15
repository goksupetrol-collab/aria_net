-- Trigger: dbo.stokkart_log_tri
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.033181
================================================================================

CREATE TRIGGER [dbo].[stokkart_log_tri] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'stokkart',1,''
end

================================================================================
