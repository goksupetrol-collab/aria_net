-- Trigger: dbo.carikart_log_tri
-- Tablo: dbo.carikart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.927929
================================================================================

CREATE TRIGGER [dbo].[carikart_log_tri] ON [dbo].[carikart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'carikart',1,''
end

================================================================================
