-- Trigger: dbo.fismas_log_tri
-- Tablo: dbo.fismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.946274
================================================================================

CREATE TRIGGER [dbo].[fismas_log_tri] ON [dbo].[fismas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'fismas',1,''
end

================================================================================
