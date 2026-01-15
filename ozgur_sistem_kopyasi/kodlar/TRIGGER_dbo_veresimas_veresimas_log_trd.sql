-- Trigger: dbo.veresimas_log_trd
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.042260
================================================================================

CREATE TRIGGER [dbo].[veresimas_log_trd] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' verid='+cast(verid as varchar(50))+' varno='+cast(varno as varchar(50))+' firmano='+cast(firmano as varchar(50))+' varok='+cast(varok as varchar(50))+' kayok='+cast(kayok as varchar(50))+' sil='+cast(sil as varchar(50))+' fisad='+fisad+' fistip='+fistip+' yertip='+yertip+' tarih='+cast(tarih as varchar(50))+' yerad='+yerad+' seri='+seri+' no='+no+' ykno='+ykno+' cartip='+cartip+' carkod='+carkod+' plaka='+plaka+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' surucu='+surucu+' km='+cast(km as varchar(50))+' toptut='+cast(toptut as varchar(50))+' ack='+ack+' kmsec='+cast(kmsec as varchar(50))+' saat='+saat+' ototag='+cast(ototag as varchar(50))+' olususer='+olususer+' degtarsaat='+cast(degtarsaat as varchar(50))+' deguser='+deguser+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' aktip='+aktip+' fatbelno='+fatbelno+' aktar='+cast(aktar as varchar(50))+' vadtar='+cast(vadtar as varchar(50))+' bagid='+cast(bagid as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' parabrm='+parabrm+' kur='+cast(kur as varchar(50))+' akid='+cast(akid as varchar(50))+' otocarkod='+otocarkod+' otocarad='+otocarad from deleted
  exec sp_loglama @firmano,@id,'veresimas',-2,@for_log
end

================================================================================
