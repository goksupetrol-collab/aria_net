-- Trigger: dbo.pomvardiperada_log_tri
-- Tablo: dbo.pomvardiperada
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.000972
================================================================================

CREATE TRIGGER [dbo].[pomvardiperada_log_tri] ON [dbo].[pomvardiperada]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'pomvardiperada',1,''
end

================================================================================
