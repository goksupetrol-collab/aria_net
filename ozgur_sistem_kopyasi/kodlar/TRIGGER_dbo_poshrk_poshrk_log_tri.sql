-- Trigger: dbo.poshrk_log_tri
-- Tablo: dbo.poshrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.003409
================================================================================

CREATE TRIGGER [dbo].[poshrk_log_tri] ON [dbo].[poshrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'poshrk',1,''
end

================================================================================
