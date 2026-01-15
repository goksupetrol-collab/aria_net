-- Trigger: dbo.markasahrk_log_trd
-- Tablo: dbo.markasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.970142
================================================================================

CREATE TRIGGER [dbo].[markasahrk_log_trd] ON [dbo].[markasahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kashrkid='+cast(kashrkid as varchar(50))+' varno='+cast(varno as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' cartip='+cartip+' carkod='+carkod+' gctip='+gctip+' sil='+cast(sil as varchar(50))+' varok='+cast(varok as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yertip='+yertip+' yerad='+yerad+' perkod='+perkod+' giren='+cast(giren as varchar(50))+' cikan='+cast(cikan as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' kur='+cast(kur as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' parabrm='+parabrm+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'markasahrk',-2,@for_log
end

================================================================================
