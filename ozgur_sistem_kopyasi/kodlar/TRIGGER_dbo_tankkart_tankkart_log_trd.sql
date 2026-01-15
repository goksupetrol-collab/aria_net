-- Trigger: dbo.tankkart_log_trd
-- Tablo: dbo.tankkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.035807
================================================================================

CREATE TRIGGER [dbo].[tankkart_log_trd] ON [dbo].[tankkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' bagak='+bagak+' firmano='+cast(firmano as varchar(50))+' ad='+ad+' sil='+cast(sil as varchar(50))+' dataok='+cast(dataok as varchar(50))+' kapsit='+cast(kapsit as varchar(50))+' minmik='+cast(minmik as varchar(50))+' drm='+drm+' acmik='+cast(acmik as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' alsmik='+cast(alsmik as varchar(50))+' satmik='+cast(satmik as varchar(50))+' stktip='+stktip+' alskdvlitoptut='+cast(alskdvlitoptut as varchar(50))+' satkdvlitoptut='+cast(satkdvlitoptut as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'tankkart',-2,@for_log
end

================================================================================
