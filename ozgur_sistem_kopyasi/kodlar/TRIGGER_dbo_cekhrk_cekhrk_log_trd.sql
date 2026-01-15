-- Trigger: dbo.cekhrk_log_trd
-- Tablo: dbo.cekhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.931296
================================================================================

CREATE TRIGGER [dbo].[cekhrk_log_trd] ON [dbo].[cekhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' cekid='+cast(cekid as varchar(50))+' drm='+drm+' drmad='+drmad+' gctip='+gctip+' yertip='+yertip+' yerad='+yerad+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' tutar='+cast(tutar as varchar(50))+' ack='+ack+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' cartip='+cartip+' carkod='+carkod+' belno='+belno+' gidkod='+gidkod+' gidtutar='+cast(gidtutar as varchar(50))+' parabrm='+parabrm+' tahcartip='+tahcartip+' tahcarkod='+tahcarkod from deleted
  exec sp_loglama @firmano,@id,'cekhrk',-2,@for_log
end

================================================================================
