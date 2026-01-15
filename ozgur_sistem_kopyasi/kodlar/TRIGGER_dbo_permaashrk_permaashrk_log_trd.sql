-- Trigger: dbo.permaashrk_log_trd
-- Tablo: dbo.permaashrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.994233
================================================================================

CREATE TRIGGER [dbo].[permaashrk_log_trd] ON [dbo].[permaashrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' permaashrkid='+cast(permaashrkid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' carkod='+carkod+' cartip='+cartip+' gidkod='+gidkod+' olustarsaat='+cast(olustarsaat as varchar(50))+' olususer='+olususer+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' kur='+cast(kur as varchar(50))+' parabrm='+parabrm+' tutar='+cast(tutar as varchar(50))+' yertip='+yertip+' yerad='+yerad+' belno='+belno+' ack='+ack from deleted
  exec sp_loglama @firmano,@id,'permaashrk',-2,@for_log
end

================================================================================
