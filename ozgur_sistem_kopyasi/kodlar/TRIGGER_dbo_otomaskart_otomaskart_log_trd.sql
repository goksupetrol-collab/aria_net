-- Trigger: dbo.otomaskart_log_trd
-- Tablo: dbo.otomaskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.983383
================================================================================

CREATE TRIGGER [dbo].[otomaskart_log_trd] ON [dbo].[otomaskart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' firmano='+cast(firmano as varchar(50))+' otmaskod='+otmaskod+' klasor='+klasor+' bassatir='+cast(bassatir as varchar(50))+' dosuznti='+dosuznti+' tarformat='+tarformat+' dostan='+dostan+' sonid='+cast(sonid as varchar(50))+' otomascari='+otomascari+' otomasper='+otomasper+' otofiload='+otofiload+' basid='+cast(basid as varchar(50))+' olususer='+olususer+' olustar='+cast(olustar as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' host='+host+' beg='+beg+' users='+users+' pass='+pass from deleted
  exec sp_loglama @firmano,@id,'otomaskart',-2,@for_log
end

================================================================================
