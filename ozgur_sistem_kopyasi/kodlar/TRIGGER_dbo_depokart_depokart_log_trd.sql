-- Trigger: dbo.depokart_log_trd
-- Tablo: dbo.depokart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.935353
================================================================================

CREATE TRIGGER [dbo].[depokart_log_trd] ON [dbo].[depokart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' dataok='+cast(dataok as varchar(50))+' deptip='+deptip+' ad='+ad+' perkod='+perkod+' drm='+drm+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' sil='+cast(sil as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'depokart',-2,@for_log
end

================================================================================
