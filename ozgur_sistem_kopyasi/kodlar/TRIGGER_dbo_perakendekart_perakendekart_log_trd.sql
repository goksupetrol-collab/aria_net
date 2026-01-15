-- Trigger: dbo.perakendekart_log_trd
-- Tablo: dbo.perakendekart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.989763
================================================================================

CREATE TRIGGER [dbo].[perakendekart_log_trd] ON [dbo].[perakendekart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' drm='+drm+' kod='+kod+' ad='+ad+' soyad='+soyad+' unvan='+unvan+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' grp3='+cast(grp3 as varchar(50))+' ilgili='+ilgili+' tel='+tel+' fax='+fax+' cep='+cep+' muhkod='+muhkod+' adres='+adres+' evil='+evil+' evilce='+evilce+' vergidaire='+vergidaire+' vergino='+vergino+' mail='+mail+' tcno='+tcno+' kulkod='+kulkod+' kulsif='+kulsif+' fisbak='+cast(fisbak as varchar(50))+' carbak='+cast(carbak as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' parabrm='+parabrm+' adres2='+adres2+' fisadet='+cast(fisadet as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'perakendekart',-2,@for_log
end

================================================================================
