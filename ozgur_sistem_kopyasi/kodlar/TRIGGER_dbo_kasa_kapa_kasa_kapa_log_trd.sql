-- Trigger: dbo.kasa_kapa_log_trd
-- Tablo: dbo.kasa_kapa
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.963300
================================================================================

CREATE TRIGGER [dbo].[kasa_kapa_log_trd] ON [dbo].[kasa_kapa]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' kaskod='+kaskod+' tarih='+cast(tarih as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' kapat='+cast(kapat as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'kasa_kapa',-2,@for_log
end

================================================================================
