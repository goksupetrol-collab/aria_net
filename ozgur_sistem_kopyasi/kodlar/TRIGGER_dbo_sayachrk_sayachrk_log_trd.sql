-- Trigger: dbo.sayachrk_log_trd
-- Tablo: dbo.sayachrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.011450
================================================================================

CREATE TRIGGER [dbo].[sayachrk_log_trd] ON [dbo].[sayachrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sayachrkid='+cast(sayachrkid as varchar(50))+' sayackod='+sayackod+' firmano='+cast(firmano as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' ilkendks='+cast(ilkendks as varchar(50))+' sonendks='+cast(sonendks as varchar(50))+' olustarsaat='+cast(olustarsaat as varchar(50))+' olususer='+olususer+' degtarsaat='+cast(degtarsaat as varchar(50))+' deguser='+deguser+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' dataok='+cast(dataok as varchar(50))+' ack='+ack+' yertip='+yertip+' yerad='+yerad+' islmid='+cast(islmid as varchar(50))+' belno='+belno from deleted
  exec sp_loglama @firmano,@id,'sayachrk',-2,@for_log
end

================================================================================
