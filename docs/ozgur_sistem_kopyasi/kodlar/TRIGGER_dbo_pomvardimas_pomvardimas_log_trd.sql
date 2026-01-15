-- Trigger: dbo.pomvardimas_log_trd
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.996989
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_log_trd] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' varad='+varad+' dataok='+cast(dataok as varchar(50))+' sil='+cast(sil as varchar(50))+' adabag='+cast(adabag as varchar(50))+' aksatmik='+cast(aksatmik as varchar(50))+' aksattop='+cast(aksattop as varchar(50))+' naktestop='+cast(naktestop as varchar(50))+' postop='+cast(postop as varchar(50))+' veresitop='+cast(veresitop as varchar(50))+' malsattop='+cast(malsattop as varchar(50))+' gelirtop='+cast(gelirtop as varchar(50))+' gidertop='+cast(gidertop as varchar(50))+' tahtop='+cast(tahtop as varchar(50))+' odetop='+cast(odetop as varchar(50))+' kaptar='+cast(kaptar as varchar(50))+' kapsaat='+kapsaat+' otocheck='+cast(otocheck as varchar(50))+' otomastop='+cast(otomastop as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' varackfaztip='+varackfaztip from deleted
  exec sp_loglama @firmano,@id,'pomvardimas',-2,@for_log
end

================================================================================
