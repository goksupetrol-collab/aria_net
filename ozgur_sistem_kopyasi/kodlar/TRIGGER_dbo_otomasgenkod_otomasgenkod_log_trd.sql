-- Trigger: dbo.otomasgenkod_log_trd
-- Tablo: dbo.otomasgenkod
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.981759
================================================================================

CREATE TRIGGER [dbo].[otomasgenkod_log_trd] ON [dbo].[otomasgenkod]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' otomaskod='+otomaskod+' cartip='+cartip+' kod='+kod+' carkod='+carkod+' hrktip='+hrktip+' plaka='+plaka+' otomastip='+otomastip+' perkod='+perkod+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' limit='+cast(limit as varchar(50))+' limitturu='+limitturu+' stkod='+stkod from deleted
  exec sp_loglama @firmano,@id,'otomasgenkod',-2,@for_log
end

================================================================================
