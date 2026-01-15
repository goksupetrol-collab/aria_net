-- Trigger: dbo.stkbrm_log_tri
-- Tablo: dbo.stkbrm
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.026519
================================================================================

CREATE TRIGGER [dbo].[stkbrm_log_tri] ON [dbo].[stkbrm]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'stkbrm',1,''
end

================================================================================
