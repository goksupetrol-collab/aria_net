-- Trigger: dbo.otomasgenkod_log_tri
-- Tablo: dbo.otomasgenkod
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.982168
================================================================================

CREATE TRIGGER [dbo].[otomasgenkod_log_tri] ON [dbo].[otomasgenkod]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'otomasgenkod',1,''
end

================================================================================
