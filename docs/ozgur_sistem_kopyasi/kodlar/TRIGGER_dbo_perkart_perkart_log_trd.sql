-- Trigger: dbo.perkart_log_trd
-- Tablo: dbo.perkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.991877
================================================================================

CREATE TRIGGER [dbo].[perkart_log_trd] ON [dbo].[perkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' drm='+drm+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' kod='+kod+' ad='+ad+' soyad='+soyad+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' grp3='+cast(grp3 as varchar(50))+' tel='+tel+' fax='+fax+' cep='+cep+' muhkod='+muhkod+' adres='+adres+' evil='+evil+' evilce='+evilce+' vergidaire='+vergidaire+' vergino='+vergino+' mail='+mail+' tcno='+tcno+' toplim='+cast(toplim as varchar(50))+' maasgun='+cast(maasgun as varchar(50))+' maas='+cast(maas as varchar(50))+' prim='+cast(prim as varchar(50))+' isk='+cast(isk as varchar(50))+' isbastar='+cast(isbastar as varchar(50))+' isbittar='+cast(isbittar as varchar(50))+' fisbak='+cast(fisbak as varchar(50))+' carbak='+cast(carbak as varchar(50))+' gos='+cast(gos as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' fisadet='+cast(fisadet as varchar(50))+' fisaktut='+cast(fisaktut as varchar(50))+' fisakadet='+cast(fisakadet as varchar(50))+' parabrm='+parabrm+' actutar='+cast(actutar as varchar(50))+' adres2='+adres2 from deleted
  exec sp_loglama @firmano,@id,'perkart',-2,@for_log
end

================================================================================
