-- Trigger: dbo.pomvardiperada_log_trd
-- Tablo: dbo.pomvardiperada
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.000576
================================================================================

CREATE TRIGGER [dbo].[pomvardiperada_log_trd] ON [dbo].[pomvardiperada]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' per='+per+' sr='+cast(sr as varchar(50))+' adaid='+cast(adaid as varchar(50))+' adad='+adad from deleted
  exec sp_loglama @firmano,@id,'pomvardiperada',-2,@for_log
end

================================================================================
