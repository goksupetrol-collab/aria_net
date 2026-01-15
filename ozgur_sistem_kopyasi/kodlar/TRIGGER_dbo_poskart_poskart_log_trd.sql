-- Trigger: dbo.poskart_log_trd
-- Tablo: dbo.poskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.004853
================================================================================

CREATE TRIGGER [dbo].[poskart_log_trd] ON [dbo].[poskart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' ad='+ad+' sil='+cast(sil as varchar(50))+' drm='+drm+' bankod='+bankod+' muhkod='+muhkod+' kom='+cast(kom as varchar(50))+' exkom='+cast(exkom as varchar(50))+' vade='+cast(vade as varchar(50))+' vadetip='+vadetip+' parabrm='+parabrm+' gidhes='+gidhes+' bekbak='+cast(bekbak as varchar(50))+' kombak='+cast(kombak as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'poskart',-2,@for_log
end

================================================================================
