-- Trigger: dbo.stokkart_log_trd
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.032771
================================================================================

CREATE TRIGGER [dbo].[stokkart_log_trd] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' tip='+tip+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' barkod='+barkod+' ad='+ad+' sat1fiy='+cast(sat1fiy as varchar(50))+' sat1kdv='+cast(sat1kdv as varchar(50))+' sat1kdvtip='+sat1kdvtip+' sat2fiy='+cast(sat2fiy as varchar(50))+' sat2kdv='+cast(sat2kdv as varchar(50))+' sat2kdvtip='+sat2kdvtip+' alsfiy='+cast(alsfiy as varchar(50))+' alskdv='+cast(alskdv as varchar(50))+' alskdvtip='+alskdvtip+' kesft='+cast(kesft as varchar(50))+' brim='+brim+' otv='+cast(otv as varchar(50))+' eksat='+eksat+' minmik='+cast(minmik as varchar(50))+' drm='+drm+' muhgrskod='+muhgrskod+' muhckskod='+muhckskod+' brmcarp='+cast(brmcarp as varchar(50))+' brmust='+brmust+' ykno='+ykno+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' grp3='+cast(grp3 as varchar(50))+' alsmik='+cast(alsmik as varchar(50))+' satmik='+cast(satmik as varchar(50))+' sil='+cast(sil as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' acmik='+cast(acmik as varchar(50))+' karoran1='+cast(karoran1 as varchar(50))+' karoran2='+cast(karoran2 as varchar(50))+' grpkdvoran='+cast(grpkdvoran as varchar(50))+' sat1pbrm='+sat1pbrm+' sat2pbrm='+sat2pbrm+' sat3pbrm='+sat3pbrm+' sat4pbrm='+sat4pbrm+' alspbrm='+alspbrm+' sat3fiy='+cast(sat3fiy as varchar(50))+' sat3kdv='+cast(sat3kdv as varchar(50))+' sat3kdvtip='+sat3kdvtip+' sat4fiy='+cast(sat4fiy as varchar(50))+' sat4kdv='+cast(sat4kdv as varchar(50))+' sat4kdvtip='+sat4kdvtip+' alskdvlitoptut='+cast(alskdvlitoptut as varchar(50))+' satkdvlitoptut='+cast(satkdvlitoptut as varchar(50))+' alsiademik='+cast(alsiademik as varchar(50))+' alsiadekdvlitoptut='+cast(alsiadekdvlitoptut as varchar(50))+' satiademik='+cast(satiademik as varchar(50))+' satiadekdvlitoptut='+cast(satiadekdvlitoptut as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'stokkart',-2,@for_log
end

================================================================================
