-- Trigger: dbo.faturamas_log_trd
-- Tablo: dbo.faturamas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.942997
================================================================================

CREATE TRIGGER [dbo].[faturamas_log_trd] ON [dbo].[faturamas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' fatid='+cast(fatid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tarih='+cast(tarih as varchar(50))+' saat='+saat+' fatad='+fatad+' fattip='+fattip+' fattur='+fattur+' fatturad='+fatturad+' fatseri='+fatseri+' fatno='+fatno+' cartip='+cartip+' carkod='+carkod+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' ack='+ack+' geniskyuz='+cast(geniskyuz as varchar(50))+' genisktop='+cast(genisktop as varchar(50))+' satisktop='+cast(satisktop as varchar(50))+' kdvtop='+cast(kdvtop as varchar(50))+' yuvtop='+cast(yuvtop as varchar(50))+' gidertop='+cast(gidertop as varchar(50))+' giderkdvtop='+cast(giderkdvtop as varchar(50))+' fattop='+cast(fattop as varchar(50))+' otvtop='+cast(otvtop as varchar(50))+' kdvtip='+kdvtip+' vadtar='+cast(vadtar as varchar(50))+' depo='+depo+' sil='+cast(sil as varchar(50))+' dataok='+cast(dataok as varchar(50))+' irsaliyeirid='+cast(irsaliyeirid as varchar(50))+' siparissipid='+cast(siparissipid as varchar(50))+' kayok='+cast(kayok as varchar(50))+' kur='+cast(kur as varchar(50))+' parabrm='+parabrm+' kaptip='+kaptip+' kapidler='+kapidler+' odemetop='+cast(odemetop as varchar(50))+' marsatid='+cast(marsatid as varchar(50))+' yazildi='+cast(yazildi as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'faturamas',-2,@for_log
end

================================================================================
