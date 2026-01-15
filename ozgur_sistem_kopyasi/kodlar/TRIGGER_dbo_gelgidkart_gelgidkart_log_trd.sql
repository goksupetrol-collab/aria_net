-- Trigger: dbo.gelgidkart_log_trd
-- Tablo: dbo.gelgidkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.947311
================================================================================

CREATE TRIGGER [dbo].[gelgidkart_log_trd] ON [dbo].[gelgidkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' kod='+kod+' ad='+ad+' drm='+drm+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' grp3='+cast(grp3 as varchar(50))+' fisbak='+cast(fisbak as varchar(50))+' carbak='+cast(carbak as varchar(50))+' muhkod='+muhkod+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' fiyat='+cast(fiyat as varchar(50))+' toplim='+cast(toplim as varchar(50))+' kdvtip='+kdvtip+' kdv='+cast(kdv as varchar(50))+' brim='+brim+' parabrm='+parabrm+' fisaktut='+cast(fisaktut as varchar(50))+' fisadet='+cast(fisadet as varchar(50))+' fisakadet='+cast(fisakadet as varchar(50))+' actutar='+cast(actutar as varchar(50))+' gizli='+cast(gizli as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'gelgidkart',-2,@for_log
end

================================================================================
