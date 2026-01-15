-- Trigger: dbo.cekhrk_log_tri
-- Tablo: dbo.cekhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.931664
================================================================================

CREATE TRIGGER [dbo].[cekhrk_log_tri] ON [dbo].[cekhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'cekhrk',1,''
end

================================================================================
