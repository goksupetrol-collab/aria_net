-- Trigger: dbo.stkbrm_log_trd
-- Tablo: dbo.stkbrm
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.026095
================================================================================

CREATE TRIGGER [dbo].[stkbrm_log_trd] ON [dbo].[stkbrm]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' ad='+ad+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' Sil='+cast(Sil as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'stkbrm',-2,@for_log
end

================================================================================
