-- Trigger: dbo.depokart_log_tri
-- Tablo: dbo.depokart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.935689
================================================================================

CREATE TRIGGER [dbo].[depokart_log_tri] ON [dbo].[depokart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'depokart',1,''
end

================================================================================
