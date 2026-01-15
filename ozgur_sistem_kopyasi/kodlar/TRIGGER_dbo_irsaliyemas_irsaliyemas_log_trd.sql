-- Trigger: dbo.irsaliyemas_log_trd
-- Tablo: dbo.irsaliyemas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.954665
================================================================================

CREATE TRIGGER [dbo].[irsaliyemas_log_trd] ON [dbo].[irsaliyemas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' irid='+cast(irid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' kayok='+cast(kayok as varchar(50))+' sil='+cast(sil as varchar(50))+' irtip='+irtip+' irad='+irad+' irturad='+irturad+' irtur='+irtur+' irseri='+irseri+' irno='+irno+' tarih='+cast(tarih as varchar(50))+' vadtar='+cast(vadtar as varchar(50))+' kdvtip='+kdvtip+' ack='+ack+' kdvtut='+cast(kdvtut as varchar(50))+' depo='+depo+' dataok='+cast(dataok as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' irtop='+cast(irtop as varchar(50))+' kdvtop='+cast(kdvtop as varchar(50))+' cartip='+cartip+' carkod='+carkod+' saat='+saat+' aktip='+aktip+' akid='+cast(akid as varchar(50))+' aktar='+cast(aktar as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'irsaliyemas',-2,@for_log
end

================================================================================
