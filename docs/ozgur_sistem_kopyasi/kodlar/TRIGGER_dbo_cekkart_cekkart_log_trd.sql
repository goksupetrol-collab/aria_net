-- Trigger: dbo.cekkart_log_trd
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.933075
================================================================================

CREATE TRIGGER [dbo].[cekkart_log_trd] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' islmtip='+islmtip+' firmano='+cast(firmano as varchar(50))+' cekid='+cast(cekid as varchar(50))+' sil='+cast(sil as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' firmano='+cast(firmano as varchar(50))+' cartip='+cartip+' carkod='+carkod+' vercartip='+vercartip+' vercarkod='+vercarkod+' gctip='+gctip+' yertip='+yertip+' yerad='+yerad+' drm='+drm+' drmad='+drmad+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' cikan='+cast(cikan as varchar(50))+' giren='+cast(giren as varchar(50))+' islmhrkad='+islmhrkad+' ceksenno='+ceksenno+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' banka='+banka+' banksub='+banksub+' hesepno='+hesepno+' refno='+refno+' kesideci='+kesideci+' parabrm='+parabrm+' ack='+ack+' vadetar='+cast(vadetar as varchar(50))+' odetar='+cast(odetar as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' masterid='+cast(masterid as varchar(50))+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' kur='+cast(kur as varchar(50))+' takvertar='+cast(takvertar as varchar(50))+' cirotar='+cast(cirotar as varchar(50))+' taktahtar='+cast(taktahtar as varchar(50))+' eltahtar='+cast(eltahtar as varchar(50))+' sonuc='+cast(sonuc as varchar(50))+' geraltar='+cast(geraltar as varchar(50))+' iadetar='+cast(iadetar as varchar(50))+' pro='+cast(pro as varchar(50))+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' hrkid='+cast(hrkid as varchar(50))+' belno='+belno+' gidkod='+gidkod+' gidtutar='+cast(gidtutar as varchar(50))+' tahcartip='+tahcartip+' tahcarkod='+tahcarkod+' fisid='+cast(fisid as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'cekkart',-2,@for_log
end

================================================================================
