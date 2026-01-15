-- Trigger: dbo.grup_log_trd
-- Tablo: dbo.grup
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.950009
================================================================================

CREATE TRIGGER [dbo].[grup_log_trd] ON [dbo].[grup]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sr='+cast(sr as varchar(50))+' sil='+cast(sil as varchar(50))+' firmano='+cast(firmano as varchar(50))+' tabload='+tabload+' grp1='+cast(grp1 as varchar(50))+' grp2='+cast(grp2 as varchar(50))+' ad='+ad+' olususer='+olususer+' olustarsaat='+cast(olustarsaat as varchar(50))+' deguser='+deguser+' degtarsaat='+cast(degtarsaat as varchar(50))+' dataok='+cast(dataok as varchar(50))+' kar1='+cast(kar1 as varchar(50))+' kar2='+cast(kar2 as varchar(50))+' kdv='+cast(kdv as varchar(50))+' ykkisno='+ykkisno+' kar3='+cast(kar3 as varchar(50))+' kar4='+cast(kar4 as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'grup',-2,@for_log
end

================================================================================
