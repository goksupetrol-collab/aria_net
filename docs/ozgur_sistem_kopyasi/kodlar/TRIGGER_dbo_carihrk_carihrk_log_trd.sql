-- Trigger: dbo.carihrk_log_trd
-- Tablo: dbo.carihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.924760
================================================================================

CREATE TRIGGER [dbo].[carihrk_log_trd] ON [dbo].[carihrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' carhrkid='+cast(carhrkid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' gctip='+gctip+' masterid='+cast(masterid as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yerad='+yerad+' yertip='+yertip+' cartip='+cartip+' carkod='+carkod+' borc='+cast(borc as varchar(50))+' alacak='+cast(alacak as varchar(50))+' bakiye='+cast(bakiye as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' vadetar='+cast(vadetar as varchar(50))+' belno='+belno+' ack='+ack+' varno='+cast(varno as varchar(50))+' kur='+cast(kur as varchar(50))+' dataok='+cast(dataok as varchar(50))+' pro='+cast(pro as varchar(50))+' varok='+cast(varok as varchar(50))+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' sil='+cast(sil as varchar(50))+' parabrm='+parabrm+' karsihestip='+karsihestip+' karsiheskod='+karsiheskod+' kdvyuz='+cast(kdvyuz as varchar(50))+' fisaktip='+fisaktip+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' fisid='+cast(fisid as varchar(50))+' permasmasid='+cast(permasmasid as varchar(50))+' fatstkhrkid='+cast(fatstkhrkid as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'carihrk',-2,@for_log
end

================================================================================
