-- Trigger: dbo.sayimmas_log_trd
-- Tablo: dbo.sayimmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.018218
================================================================================

CREATE TRIGGER [dbo].[sayimmas_log_trd] ON [dbo].[sayimmas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sayid='+cast(sayid as varchar(50))+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' sayack='+sayack+' drm='+drm+' depkod='+depkod+' perkod='+perkod+' onaytarih='+cast(onaytarih as varchar(50))+' onaysaat='+onaysaat+' sayimmik='+cast(sayimmik as varchar(50))+' mevcutmik='+cast(mevcutmik as varchar(50))+' mevcuttut='+cast(mevcuttut as varchar(50))+' sayimtut='+cast(sayimtut as varchar(50))+' onayack='+onayack+' olustarsaat='+cast(olustarsaat as varchar(50))+' olususer='+olususer+' degtarsaat='+cast(degtarsaat as varchar(50))+' deguser='+deguser+' kdvtip='+kdvtip+' brmfiytip='+brmfiytip+' dataok='+cast(dataok as varchar(50))+' onayper='+onayper from deleted
  exec sp_loglama @firmano,@id,'sayimmas',-2,@for_log
end

================================================================================
