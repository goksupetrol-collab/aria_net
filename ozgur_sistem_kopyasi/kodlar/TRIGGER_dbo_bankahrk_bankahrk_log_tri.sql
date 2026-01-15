-- Trigger: dbo.bankahrk_log_tri
-- Tablo: dbo.bankahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.920081
================================================================================

CREATE TRIGGER [dbo].[bankahrk_log_tri] ON [dbo].[bankahrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'bankahrk',1,''
end

================================================================================
