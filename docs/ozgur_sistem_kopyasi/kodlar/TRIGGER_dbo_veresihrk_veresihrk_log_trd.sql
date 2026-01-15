-- Trigger: dbo.veresihrk_log_trd
-- Tablo: dbo.veresihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.039650
================================================================================

CREATE TRIGGER [dbo].[veresihrk_log_trd] ON [dbo].[veresihrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' varno='+cast(varno as varchar(50))+' verid='+cast(verid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' stktip='+stktip+' stkod='+stkod+' mik='+cast(mik as varchar(50))+' brmfiy='+cast(brmfiy as varchar(50))+' depkod='+depkod+' kdvyuz='+cast(kdvyuz as varchar(50))+' sil='+cast(sil as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' yenbrmfiyfark='+cast(yenbrmfiyfark as varchar(50))+' kayok='+cast(kayok as varchar(50))+' akfiytip='+akfiytip+' brim='+brim from deleted
  exec sp_loglama @firmano,@id,'veresihrk',-2,@for_log
end

================================================================================
