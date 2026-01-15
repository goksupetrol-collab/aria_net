-- Trigger: dbo.bankahrk_log_trd
-- Tablo: dbo.bankahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.919584
================================================================================

/* */
/* Definition for triggers :  */
/* */

CREATE TRIGGER [dbo].[bankahrk_log_trd] ON [dbo].[bankahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' bankod='+bankod+' bankhrkid='+cast(bankhrkid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' gctip='+gctip+' varno='+cast(varno as varchar(50))+' masterid='+cast(masterid as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yertip='+yertip+' yerad='+yerad+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' borc='+cast(borc as varchar(50))+' alacak='+cast(alacak as varchar(50))+' carkod='+carkod+' cartur='+cartur+' cartip='+cartip+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' belno='+belno+' ack='+ack+' kur='+cast(kur as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' parabrm='+parabrm+' kaskod='+kaskod+' pro='+cast(pro as varchar(50))+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' karsihestip='+karsihestip+' karsiheskod='+karsiheskod+' fisid='+cast(fisid as varchar(50))+' gidkod='+gidkod+' gidtutar='+cast(gidtutar as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'bankahrk',-2,@for_log
end

================================================================================
