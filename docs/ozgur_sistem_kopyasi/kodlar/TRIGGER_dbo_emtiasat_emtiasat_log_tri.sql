-- Trigger: dbo.emtiasat_log_tri
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.937641
================================================================================

CREATE TRIGGER [dbo].[emtiasat_log_tri] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'emtiasat',1,''
end

================================================================================
