-- Trigger: dbo.pomvardisayac_log_tri
-- Tablo: dbo.pomvardisayac
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.002023
================================================================================

CREATE TRIGGER [dbo].[pomvardisayac_log_tri] ON [dbo].[pomvardisayac]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'pomvardisayac',1,''
end

================================================================================
