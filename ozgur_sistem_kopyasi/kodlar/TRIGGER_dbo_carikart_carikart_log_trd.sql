-- Trigger: dbo.carikart_log_trd
-- Tablo: dbo.carikart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.927369
================================================================================

CREATE TRIGGER [dbo].[carikart_log_trd] ON [dbo].[carikart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' sil='+cast(sil as varchar(50))+' kod='+kod+' ad='+ad+' soyad='+soyad+' unvan='+unvan+' fisbak='+cast(fisbak as varchar(50))+' carbak='+cast(carbak as varchar(50))+' fisadet='+cast(fisadet as varchar(50))+' fisakadet='+cast(fisakadet as varchar(50))+' cekbak='+cast(cekbak as varchar(50))+' fisaktut='+cast(fisaktut as varchar(50))+' actutar='+cast(actutar as varchar(50))+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' grp3='+cast(grp3 as varchar(50))+' ilgili='+ilgili+' tel='+tel+' fax='+fax+' cep='+cep+' muhkod='+muhkod+' drm='+drm+' adres='+adres+' evil='+evil+' evilce='+evilce+' vergidaire='+vergidaire+' vergino='+vergino+' mail='+mail+' tcno='+tcno+' kulkod='+kulkod+' sonhrktar='+cast(sonhrktar as varchar(50))+' kulsif='+kulsif+' fatvadtip='+fatvadtip+' fisvadtip='+fisvadtip+' fatvadsur='+cast(fatvadsur as varchar(50))+' fisvadsur='+cast(fisvadsur as varchar(50))+' fatisk='+cast(fatisk as varchar(50))+' fisvadfark='+cast(fisvadfark as varchar(50))+' fatvadfark='+cast(fatvadfark as varchar(50))+' fisisk='+cast(fisisk as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' parabrm='+parabrm+' otofisak='+cast(otofisak as varchar(50))+' fatunvan='+fatunvan+' toplamteminat='+cast(toplamteminat as varchar(50))+' toplamlimit='+cast(toplamlimit as varchar(50))+' sonfistutar='+cast(sonfistutar as varchar(50))+' sonfistarih='+cast(sonfistarih as varchar(50))+' adres2='+adres2+' notack='+notack from deleted
  exec sp_loglama @firmano,@id,'carikart',-2,@for_log
end

================================================================================
