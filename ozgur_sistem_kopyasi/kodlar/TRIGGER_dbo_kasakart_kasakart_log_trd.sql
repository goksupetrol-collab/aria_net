-- Trigger: dbo.kasakart_log_trd
-- Tablo: dbo.kasakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.967835
================================================================================

CREATE TRIGGER [dbo].[kasakart_log_trd] ON [dbo].[kasakart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tip='+cast(tip as varchar(50))+' kod='+kod+' ad='+ad+' parabrm='+parabrm+' giren='+cast(giren as varchar(50))+' cikan='+cast(cikan as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' sil='+cast(sil as varchar(50))+' dataok='+cast(dataok as varchar(50))+' sr='+cast(sr as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'kasakart',-2,@for_log
end

================================================================================
