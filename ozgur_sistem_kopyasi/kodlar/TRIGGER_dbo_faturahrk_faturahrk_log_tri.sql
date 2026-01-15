-- Trigger: dbo.faturahrk_log_tri
-- Tablo: dbo.faturahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.940462
================================================================================

CREATE TRIGGER [dbo].[faturahrk_log_tri] ON [dbo].[faturahrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'faturahrk',1,''
end

================================================================================
