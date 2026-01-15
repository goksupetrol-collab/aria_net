-- Trigger: dbo.fismas_log_trd
-- Tablo: dbo.fismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.945762
================================================================================

CREATE TRIGGER [dbo].[fismas_log_trd] ON [dbo].[fismas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' fisid='+cast(fisid as varchar(50))+' fisno='+fisno+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' cartip='+cartip+' carkod='+carkod+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' toptut='+cast(toptut as varchar(50))+' yertip='+yertip+' ack='+ack from deleted
  exec sp_loglama @firmano,@id,'fismas',-2,@for_log
end

================================================================================
