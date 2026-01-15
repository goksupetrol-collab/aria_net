-- Trigger: dbo.kasa_kapa_log_tri
-- Tablo: dbo.kasa_kapa
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.963836
================================================================================

CREATE TRIGGER [dbo].[kasa_kapa_log_tri] ON [dbo].[kasa_kapa]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'kasa_kapa',1,''
end

================================================================================
