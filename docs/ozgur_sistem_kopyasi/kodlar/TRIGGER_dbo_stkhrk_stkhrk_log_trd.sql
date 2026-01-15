-- Trigger: dbo.stkhrk_log_trd
-- Tablo: dbo.stkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.030050
================================================================================

CREATE TRIGGER [dbo].[stkhrk_log_trd] ON [dbo].[stkhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' stkhrkid='+cast(stkhrkid as varchar(50))+' tabload='+tabload+' stktip='+stktip+' stkod='+stkod+' gctip='+gctip+' depkod='+depkod+' firmano='+cast(firmano as varchar(50))+' dataok='+cast(dataok as varchar(50))+' islmid='+cast(islmid as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' islmtip='+islmtip+' islmtipad='+islmtipad+' yertip='+yertip+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' yerad='+yerad+' giren='+cast(giren as varchar(50))+' cikan='+cast(cikan as varchar(50))+' kalan='+cast(kalan as varchar(50))+' brmfiykdvli='+cast(brmfiykdvli as varchar(50))+' kdvyuz='+cast(kdvyuz as varchar(50))+' otv='+cast(otv as varchar(50))+' kesafet='+cast(kesafet as varchar(50))+' belno='+belno+' ack='+ack+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' stktipad='+stktipad+' pro='+cast(pro as varchar(50))+' aiademik='+cast(aiademik as varchar(50))+' siademik='+cast(siademik as varchar(50))+' brmsatirisktut='+cast(brmsatirisktut as varchar(50))+' brmgidertut='+cast(brmgidertut as varchar(50))+' brmgenelisktut='+cast(brmgenelisktut as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'stkhrk',-2,@for_log
end

================================================================================
