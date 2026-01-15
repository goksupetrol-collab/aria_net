-- Trigger: dbo.cariteminat_log_trd
-- Tablo: dbo.cariteminat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.929450
================================================================================

CREATE TRIGGER [dbo].[cariteminat_log_trd] ON [dbo].[cariteminat]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' tip='+tip+' tur='+tur+' tutar='+cast(tutar as varchar(50))+' ack='+ack+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'cariteminat',-2,@for_log
end

================================================================================
