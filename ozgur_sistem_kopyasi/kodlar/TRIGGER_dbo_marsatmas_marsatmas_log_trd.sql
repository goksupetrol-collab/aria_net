-- Trigger: dbo.marsatmas_log_trd
-- Tablo: dbo.marsatmas
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.974470
================================================================================

CREATE TRIGGER [dbo].[marsatmas_log_trd] ON [dbo].[marsatmas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' kayok='+cast(kayok as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' islmtip='+islmtip+' islmtipad='+islmtipad+' yertip='+yertip+' yerad='+yerad+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' sil='+cast(sil as varchar(50))+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' naktop='+cast(naktop as varchar(50))+' postop='+cast(postop as varchar(50))+' veresitop='+cast(veresitop as varchar(50))+' iadetop='+cast(iadetop as varchar(50))+' indtop='+cast(indtop as varchar(50))+' yuvtop='+cast(yuvtop as varchar(50))+' parabrm='+parabrm+' kur='+cast(kur as varchar(50))+' satistop='+cast(satistop as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'marsatmas',-2,@for_log
end

================================================================================
