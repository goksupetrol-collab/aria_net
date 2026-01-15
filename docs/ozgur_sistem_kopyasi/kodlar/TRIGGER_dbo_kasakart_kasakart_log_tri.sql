-- Trigger: dbo.kasakart_log_tri
-- Tablo: dbo.kasakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.968312
================================================================================

CREATE TRIGGER [dbo].[kasakart_log_tri] ON [dbo].[kasakart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'kasakart',1,''
end

================================================================================
