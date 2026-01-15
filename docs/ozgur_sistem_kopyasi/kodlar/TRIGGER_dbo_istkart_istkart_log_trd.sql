-- Trigger: dbo.istkart_log_trd
-- Tablo: dbo.istkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.956904
================================================================================

CREATE TRIGGER [dbo].[istkart_log_trd] ON [dbo].[istkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' kod='+kod+' ad='+ad+' bankod='+bankod+' sahibi='+sahibi+' muhkod='+muhkod+' lim='+cast(lim as varchar(50))+' sonkultar='+cast(sonkultar as varchar(50))+' heskesgun='+cast(heskesgun as varchar(50))+' hessongun='+cast(hessongun as varchar(50))+' drm='+drm+' karttur='+karttur+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' borc='+cast(borc as varchar(50))+' alacak='+cast(alacak as varchar(50))+' parabrm='+parabrm+' actutar='+cast(actutar as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'istkart',-2,@for_log
end

================================================================================
