-- Trigger: dbo.cariteminat_log_tri
-- Tablo: dbo.cariteminat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.929859
================================================================================

CREATE TRIGGER [dbo].[cariteminat_log_tri] ON [dbo].[cariteminat]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'cariteminat',1,''
end

================================================================================
