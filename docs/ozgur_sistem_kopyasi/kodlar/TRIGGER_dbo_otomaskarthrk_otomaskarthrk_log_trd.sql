-- Trigger: dbo.otomaskarthrk_log_trd
-- Tablo: dbo.otomaskarthrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.985655
================================================================================

CREATE TRIGGER [dbo].[otomaskarthrk_log_trd] ON [dbo].[otomaskarthrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' otmaskod='+otmaskod+' firmano='+cast(firmano as varchar(50))+' kod='+kod+' ad='+ad+' pos='+cast(pos as varchar(50))+' uzn='+cast(uzn as varchar(50))+' iptkar='+iptkar+' onpos='+cast(onpos as varchar(50))+' onuzn='+cast(onuzn as varchar(50))+' oku='+cast(oku as varchar(50))+' sr='+cast(sr as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'otomaskarthrk',-2,@for_log
end

================================================================================
