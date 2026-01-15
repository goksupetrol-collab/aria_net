-- Trigger: dbo.pomvardiper_log_trd
-- Tablo: dbo.pomvardiper
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.999238
================================================================================

CREATE TRIGGER [dbo].[pomvardiper_log_trd] ON [dbo].[pomvardiper]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' per='+per+' perad='+perad+' sr='+cast(sr as varchar(50))+' perackfaz='+cast(perackfaz as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'pomvardiper',-2,@for_log
end

================================================================================
