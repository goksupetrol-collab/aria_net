-- Trigger: dbo.pomvardimas_log_tri
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.997431
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_log_tri] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'pomvardimas',1,''
end

================================================================================
