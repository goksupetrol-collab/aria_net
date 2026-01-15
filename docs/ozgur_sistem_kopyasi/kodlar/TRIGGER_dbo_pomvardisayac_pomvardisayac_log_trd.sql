-- Trigger: dbo.pomvardisayac_log_trd
-- Tablo: dbo.pomvardisayac
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.001655
================================================================================

CREATE TRIGGER [dbo].[pomvardisayac_log_trd] ON [dbo].[pomvardisayac]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' perkod='+perkod+' perad='+perad+' adad='+adad+' sayackod='+sayackod+' ilkendk='+cast(ilkendk as varchar(50))+' sonendk='+cast(sonendk as varchar(50))+' digermik='+cast(digermik as varchar(50))+' satmik='+cast(satmik as varchar(50))+' testmik='+cast(testmik as varchar(50))+' transfermik='+cast(transfermik as varchar(50))+' brimfiy='+cast(brimfiy as varchar(50))+' tutar='+cast(tutar as varchar(50))+' sayacad='+sayacad+' tankod='+tankod+' transfertank='+transfertank+' stkod='+stkod+' adaid='+cast(adaid as varchar(50))+' stktip='+stktip+' kdvyuz='+cast(kdvyuz as varchar(50))+' enktur='+enktur from deleted
  exec sp_loglama @firmano,@id,'pomvardisayac',-2,@for_log
end

================================================================================
