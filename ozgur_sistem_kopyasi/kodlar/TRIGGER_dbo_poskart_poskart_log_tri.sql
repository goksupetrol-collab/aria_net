-- Trigger: dbo.poskart_log_tri
-- Tablo: dbo.poskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.005210
================================================================================

CREATE TRIGGER [dbo].[poskart_log_tri] ON [dbo].[poskart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'poskart',1,''
end

================================================================================
