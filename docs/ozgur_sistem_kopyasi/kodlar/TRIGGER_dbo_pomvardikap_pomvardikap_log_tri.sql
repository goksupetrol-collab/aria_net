-- Trigger: dbo.pomvardikap_log_tri
-- Tablo: dbo.pomvardikap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.996248
================================================================================

CREATE TRIGGER [dbo].[pomvardikap_log_tri] ON [dbo].[pomvardikap]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'pomvardikap',1,''
end

================================================================================
