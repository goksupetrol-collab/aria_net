-- Trigger: dbo.faturamas_log_tri
-- Tablo: dbo.faturamas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.943586
================================================================================

CREATE TRIGGER [dbo].[faturamas_log_tri] ON [dbo].[faturamas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'faturamas',1,''
end

================================================================================
