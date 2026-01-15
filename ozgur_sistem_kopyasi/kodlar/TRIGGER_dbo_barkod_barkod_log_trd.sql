-- Trigger: dbo.barkod_log_trd
-- Tablo: dbo.barkod
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.923671
================================================================================

CREATE TRIGGER [dbo].[barkod_log_trd] ON [dbo].[barkod]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tip='+tip+' kod='+kod+' barkod='+barkod+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' sil='+cast(sil as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'barkod',-2,@for_log
end

================================================================================
