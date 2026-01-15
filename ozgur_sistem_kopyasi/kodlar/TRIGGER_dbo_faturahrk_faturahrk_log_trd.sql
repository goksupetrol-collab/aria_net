-- Trigger: dbo.faturahrk_log_trd
-- Tablo: dbo.faturahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.940002
================================================================================

CREATE TRIGGER [dbo].[faturahrk_log_trd] ON [dbo].[faturahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' fatid='+cast(fatid as varchar(50))+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' stktip='+stktip+' stkod='+stkod+' mik='+cast(mik as varchar(50))+' brmfiy='+cast(brmfiy as varchar(50))+' depkod='+depkod+' kdvyuz='+cast(kdvyuz as varchar(50))+' kdvtut='+cast(kdvtut as varchar(50))+' kdvtip='+kdvtip+' brim='+brim+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' satiskyuz='+cast(satiskyuz as varchar(50))+' satisktut='+cast(satisktut as varchar(50))+' otvyuz='+cast(otvyuz as varchar(50))+' otvtut='+cast(otvtut as varchar(50))+' genisktut='+cast(genisktut as varchar(50))+' geniskyuz='+cast(geniskyuz as varchar(50))+' ustbrim='+ustbrim+' carpan='+cast(carpan as varchar(50))+' parabrim='+parabrim+' kur='+cast(kur as varchar(50))+' dataok='+cast(dataok as varchar(50))+' otvbrim='+cast(otvbrim as varchar(50))+' grupid='+cast(grupid as varchar(50))+' kayok='+cast(kayok as varchar(50))+' kaphrkid='+cast(kaphrkid as varchar(50))+' kaptip='+kaptip+' giderbrmtut='+cast(giderbrmtut as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'faturahrk',-2,@for_log
end

================================================================================
