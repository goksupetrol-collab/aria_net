-- Trigger: dbo.markasahrk_log_tri
-- Tablo: dbo.markasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.970608
================================================================================

CREATE TRIGGER [dbo].[markasahrk_log_tri] ON [dbo].[markasahrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'markasahrk',1,''
end

================================================================================
