-- Trigger: dbo.sayimhrk_log_trd
-- Tablo: dbo.sayimhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.015751
================================================================================

CREATE TRIGGER [dbo].[sayimhrk_log_trd] ON [dbo].[sayimhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sayid='+cast(sayid as varchar(50))+' depkod='+depkod+' stkod='+stkod+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' drm='+drm+' stktip='+stktip+' sayimmik='+cast(sayimmik as varchar(50))+' mevcutmik='+cast(mevcutmik as varchar(50))+' saydrm='+saydrm+' olustarsaat='+cast(olustarsaat as varchar(50))+' olususer='+olususer+' degtarsaat='+cast(degtarsaat as varchar(50))+' deguser='+deguser+' brmfiy='+cast(brmfiy as varchar(50))+' kdvtip='+kdvtip+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' dataok='+cast(dataok as varchar(50))+' kdvyuz='+cast(kdvyuz as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'sayimhrk',-2,@for_log
end

================================================================================
