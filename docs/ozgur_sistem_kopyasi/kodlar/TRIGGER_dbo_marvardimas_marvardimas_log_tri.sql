-- Trigger: dbo.marvardimas_log_tri
-- Tablo: dbo.marvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.979826
================================================================================

CREATE TRIGGER [dbo].[marvardimas_log_tri] ON [dbo].[marvardimas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'marvardimas',1,''
end

================================================================================
