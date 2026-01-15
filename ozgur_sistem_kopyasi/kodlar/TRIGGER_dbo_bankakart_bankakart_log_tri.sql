-- Trigger: dbo.bankakart_log_tri
-- Tablo: dbo.bankakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.922274
================================================================================

CREATE TRIGGER [dbo].[bankakart_log_tri] ON [dbo].[bankakart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'bankakart',1,''
end

================================================================================
