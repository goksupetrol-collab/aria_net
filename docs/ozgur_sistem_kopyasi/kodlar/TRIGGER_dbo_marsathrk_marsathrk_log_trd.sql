-- Trigger: dbo.marsathrk_log_trd
-- Tablo: dbo.marsathrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.971899
================================================================================

CREATE TRIGGER [dbo].[marsathrk_log_trd] ON [dbo].[marsathrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' varno='+cast(varno as varchar(50))+' sil='+cast(sil as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' perkod='+perkod+' stktip='+stktip+' stktipad='+stktipad+' stkod='+stkod+' mik='+cast(mik as varchar(50))+' brmfiy='+cast(brmfiy as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' kdvyuz='+cast(kdvyuz as varchar(50))+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' kdvtip='+kdvtip+' kayok='+cast(kayok as varchar(50))+' parabrm='+parabrm+' kur='+cast(kur as varchar(50))+' brim='+brim+' barkod='+barkod+' satfiyno='+cast(satfiyno as varchar(50))+' depkod='+depkod+' islmtip='+islmtip+' islmtipad='+islmtipad+' yertip='+yertip+' yerad='+yerad+' varok='+cast(varok as varchar(50))+' indyuz='+cast(indyuz as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'marsathrk',-2,@for_log
end

================================================================================
