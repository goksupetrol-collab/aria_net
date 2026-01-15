-- Trigger: dbo.emtiasat_log_trd
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.937142
================================================================================

CREATE TRIGGER [dbo].[emtiasat_log_trd] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' emtid='+cast(emtid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tarih='+cast(tarih as varchar(50))+' varno='+cast(varno as varchar(50))+' saat='+saat+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' stktip='+stktip+' islmtip='+islmtip+' islmtipad='+islmtipad+' yertip='+yertip+' yerad='+yerad+' depkod='+depkod+' stktipad='+stktipad+' stkod='+stkod+' mik='+cast(mik as varchar(50))+' brmfiy='+cast(brmfiy as varchar(50))+' tutar='+cast(tutar as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' kdvyuz='+cast(kdvyuz as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'emtiasat',-2,@for_log
end

================================================================================
