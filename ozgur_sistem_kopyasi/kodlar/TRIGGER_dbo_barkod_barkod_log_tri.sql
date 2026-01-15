-- Trigger: dbo.barkod_log_tri
-- Tablo: dbo.barkod
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.924004
================================================================================

CREATE TRIGGER [dbo].[barkod_log_tri] ON [dbo].[barkod]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'barkod',1,''
end

================================================================================
