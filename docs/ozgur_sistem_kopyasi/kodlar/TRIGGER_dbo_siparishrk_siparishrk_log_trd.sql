-- Trigger: dbo.siparishrk_log_trd
-- Tablo: dbo.siparishrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.022306
================================================================================

CREATE TRIGGER [dbo].[siparishrk_log_trd] ON [dbo].[siparishrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sipid='+cast(sipid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' irid='+cast(irid as varchar(50))+' kapa='+kapa+' dataok='+cast(dataok as varchar(50))+' kdvtip='+kdvtip+' cartur='+cartur+' carkod='+carkod+' stktip='+stktip+' stkod='+stkod+' mik='+cast(mik as varchar(50))+' carpan='+cast(carpan as varchar(50))+' brim='+brim+' ustbrim='+ustbrim+' kdvyuz='+cast(kdvyuz as varchar(50))+' kdvtut='+cast(kdvtut as varchar(50))+' depo='+depo+' grupid='+cast(grupid as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' brmfiy='+cast(brmfiy as varchar(50))+' tesmik='+cast(tesmik as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'siparishrk',-2,@for_log
end

================================================================================
