-- Trigger: dbo.cekkart_log_tri
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.933593
================================================================================

CREATE TRIGGER [dbo].[cekkart_log_tri] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'cekkart',1,''
end

================================================================================
