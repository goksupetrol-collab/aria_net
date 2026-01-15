-- Trigger: dbo.tankkart_log_tri
-- Tablo: dbo.tankkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.036215
================================================================================

CREATE TRIGGER [dbo].[tankkart_log_tri] ON [dbo].[tankkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'tankkart',1,''
end

================================================================================
