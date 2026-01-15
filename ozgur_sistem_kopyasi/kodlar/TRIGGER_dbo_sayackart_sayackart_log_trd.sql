-- Trigger: dbo.sayackart_log_trd
-- Tablo: dbo.sayackart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.013309
================================================================================

CREATE TRIGGER [dbo].[sayackart_log_trd] ON [dbo].[sayackart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' grp1='+cast(grp1 as varchar(50))+' ad='+ad+' sil='+cast(sil as varchar(50))+' drm='+drm+' muhkod='+muhkod+' tankod='+tankod+' satfiytip='+satfiytip+' acendks='+cast(acendks as varchar(50))+' enktur='+enktur+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' sonendks='+cast(sonendks as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'sayackart',-2,@for_log
end

================================================================================
