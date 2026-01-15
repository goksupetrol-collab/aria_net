-- Trigger: dbo.pomvardikap_log_trd
-- Tablo: dbo.pomvardikap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.995813
================================================================================

CREATE TRIGGER [dbo].[pomvardikap_log_trd] ON [dbo].[pomvardikap]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' varno='+cast(varno as varchar(50))+' varok='+cast(varok as varchar(50))+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' kaptip='+kaptip+' kod='+kod+' tutar='+cast(tutar as varchar(50))+' cartip='+cartip+' ackfaz='+ackfaz+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'pomvardikap',-2,@for_log
end

================================================================================
