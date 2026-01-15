-- Trigger: dbo.istkhrk_log_trd
-- Tablo: dbo.istkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.960202
================================================================================

CREATE TRIGGER [dbo].[istkhrk_log_trd] ON [dbo].[istkhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' istkhrkid='+cast(istkhrkid as varchar(50))+' istkkod='+istkkod+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' gctip='+gctip+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yertip='+yertip+' yerad='+yerad+' masterid='+cast(masterid as varchar(50))+' vadetar='+cast(vadetar as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' carslip='+cast(carslip as varchar(50))+' cartip='+cartip+' cartur='+cartur+' carkod='+carkod+' borc='+cast(borc as varchar(50))+' alacak='+cast(alacak as varchar(50))+' ack='+ack+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' belno='+belno+' kur='+cast(kur as varchar(50))+' parabrm='+parabrm+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' karsihestip='+karsihestip+' karsiheskod='+karsiheskod+' fisid='+cast(fisid as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'istkhrk',-2,@for_log
end

================================================================================
