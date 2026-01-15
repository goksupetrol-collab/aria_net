-- Trigger: dbo.perkart_log_tri
-- Tablo: dbo.perkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.992568
================================================================================

CREATE TRIGGER [dbo].[perkart_log_tri] ON [dbo].[perkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'perkart',1,''
end

================================================================================
