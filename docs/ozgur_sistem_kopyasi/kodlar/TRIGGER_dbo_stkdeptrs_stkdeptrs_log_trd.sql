-- Trigger: dbo.stkdeptrs_log_trd
-- Tablo: dbo.stkdeptrs
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.027305
================================================================================

CREATE TRIGGER [dbo].[stkdeptrs_log_trd] ON [dbo].[stkdeptrs]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' stktrsid='+cast(stktrsid as varchar(50))+' stktip='+stktip+' stkod='+stkod+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' firmano='+cast(firmano as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' girdepkod='+girdepkod+' cikdepkod='+cikdepkod+' yertip='+yertip+' yerad='+yerad+' miktar='+cast(miktar as varchar(50))+' brmfiykdvli='+cast(brmfiykdvli as varchar(50))+' kdvyuz='+cast(kdvyuz as varchar(50))+' otv='+cast(otv as varchar(50))+' kesafet='+cast(kesafet as varchar(50))+' belno='+belno+' ack='+ack+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' stktipad='+stktipad+' carpan='+cast(carpan as varchar(50))+' brim='+brim+' Sil='+cast(Sil as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'stkdeptrs',-2,@for_log
end

================================================================================
