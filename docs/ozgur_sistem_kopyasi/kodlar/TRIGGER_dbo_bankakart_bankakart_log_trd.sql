-- Trigger: dbo.bankakart_log_trd
-- Tablo: dbo.bankakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.921899
================================================================================

CREATE TRIGGER [dbo].[bankakart_log_trd] ON [dbo].[bankakart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' kod='+kod+' firmano='+cast(firmano as varchar(50))+' ad='+ad+' muhkod='+muhkod+' hesno='+hesno+' parabrm='+parabrm+' ilgili='+ilgili+' tel='+tel+' drm='+drm+' fax='+fax+' grp1='+grp1+' grp2='+grp2+' grp3='+grp3+' borc='+cast(borc as varchar(50))+' alacak='+cast(alacak as varchar(50))+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' degtarsaat='+cast(degtarsaat as varchar(50))+' deguser='+deguser+' sil='+cast(sil as varchar(50))+' dataok='+cast(dataok as varchar(50))+' actutar='+cast(actutar as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'bankakart',-2,@for_log
end

================================================================================
