-- Trigger: dbo.sayimkap_log_trd
-- Tablo: dbo.sayimkap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.017200
================================================================================

CREATE TRIGGER [dbo].[sayimkap_log_trd] ON [dbo].[sayimkap]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sayid='+cast(sayid as varchar(50))+' kaptip='+kaptip+' firmano='+cast(firmano as varchar(50))+' kod='+kod+' tutar='+cast(tutar as varchar(50))+' ackfaz='+ackfaz+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' saymiktip='+saymiktip from deleted
  exec sp_loglama @firmano,@id,'sayimkap',-2,@for_log
end

================================================================================
