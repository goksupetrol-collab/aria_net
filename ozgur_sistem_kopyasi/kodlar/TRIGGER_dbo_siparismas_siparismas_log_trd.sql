-- Trigger: dbo.siparismas_log_trd
-- Tablo: dbo.siparismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.024024
================================================================================

CREATE TRIGGER [dbo].[siparismas_log_trd] ON [dbo].[siparismas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sipid='+cast(sipid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' kayok='+cast(kayok as varchar(50))+' sipad='+sipad+' siptip='+siptip+' siptur='+siptur+' sipturad='+sipturad+' sipseri='+sipseri+' sipno='+sipno+' tarih='+cast(tarih as varchar(50))+' vadtar='+cast(vadtar as varchar(50))+' kdvtip='+kdvtip+' ack='+ack+' kdvtut='+cast(kdvtut as varchar(50))+' depo='+depo+' dataok='+cast(dataok as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' siptop='+cast(siptop as varchar(50))+' kdvtop='+cast(kdvtop as varchar(50))+' cartip='+cartip+' carkod='+carkod+' saat='+saat+' aktip='+aktip+' kaltop='+cast(kaltop as varchar(50))+' irtip='+irtip from deleted
  exec sp_loglama @firmano,@id,'siparismas',-2,@for_log
end

================================================================================
