-- Trigger: dbo.kasahrk_log_trd
-- Tablo: dbo.kasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.964895
================================================================================

CREATE TRIGGER [dbo].[kasahrk_log_trd] ON [dbo].[kasahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' kaskod='+kaskod+' kashrkid='+cast(kashrkid as varchar(50))+' gctip='+gctip+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' varno='+cast(varno as varchar(50))+' masterid='+cast(masterid as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yertip='+yertip+' yerad='+yerad+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' giren='+cast(giren as varchar(50))+' cikan='+cast(cikan as varchar(50))+' bakiye='+cast(bakiye as varchar(50))+' carkod='+carkod+' cartip='+cartip+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' belno='+belno+' ack='+ack+' kur='+cast(kur as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' parabrm='+parabrm+' pro='+cast(pro as varchar(50))+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' karsihestip='+karsihestip+' karsiheskod='+karsiheskod+' fisid='+cast(fisid as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'kasahrk',-2,@for_log
end

================================================================================
