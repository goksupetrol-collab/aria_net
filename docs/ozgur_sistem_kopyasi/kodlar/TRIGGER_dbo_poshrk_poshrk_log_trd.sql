-- Trigger: dbo.poshrk_log_trd
-- Tablo: dbo.poshrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.003047
================================================================================

CREATE TRIGGER [dbo].[poshrk_log_trd] ON [dbo].[poshrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' poshrkid='+cast(poshrkid as varchar(50))+' poskod='+poskod+' firmano='+cast(firmano as varchar(50))+' bankod='+bankod+' sil='+cast(sil as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' perkod='+perkod+' adaid='+cast(adaid as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' islmhrk='+islmhrk+' islmhrkad='+islmhrkad+' yertip='+yertip+' yerad='+yerad+' masterid='+cast(masterid as varchar(50))+' gctip='+gctip+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' carslip='+cast(carslip as varchar(50))+' cartip='+cartip+' carkod='+carkod+' giren='+cast(giren as varchar(50))+' cikan='+cast(cikan as varchar(50))+' extrakomyuz='+cast(extrakomyuz as varchar(50))+' bankomyuz='+cast(bankomyuz as varchar(50))+' ack='+ack+' vadetar='+cast(vadetar as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' belno='+belno+' kur='+cast(kur as varchar(50))+' aktar='+cast(aktar as varchar(50))+' aktip='+aktip+' gerialtar='+cast(gerialtar as varchar(50))+' bagid='+cast(bagid as varchar(50))+' parabrm='+parabrm+' ekkomyuz='+cast(ekkomyuz as varchar(50))+' akid='+cast(akid as varchar(50))+' pro='+cast(pro as varchar(50))+' fisfattip='+fisfattip+' fisfatid='+cast(fisfatid as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' cartur='+cartur+' fisid='+cast(fisid as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'poshrk',-2,@for_log
end

================================================================================
