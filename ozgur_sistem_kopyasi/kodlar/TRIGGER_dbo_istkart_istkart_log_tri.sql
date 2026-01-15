-- Trigger: dbo.istkart_log_tri
-- Tablo: dbo.istkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.957341
================================================================================

CREATE TRIGGER [dbo].[istkart_log_tri] ON [dbo].[istkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'istkart',1,''
end

================================================================================
