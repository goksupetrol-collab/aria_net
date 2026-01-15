-- Trigger: dbo.sayimstkgrp_log_trd
-- Tablo: dbo.sayimstkgrp
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.019984
================================================================================

CREATE TRIGGER [dbo].[sayimstkgrp_log_trd] ON [dbo].[sayimstkgrp]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
  Declare @firmano int,@id int,@islem int,@for_log varchar(8000)
  Select @for_log=' id='+cast(id as varchar(50))+' sayid='+cast(sayid as varchar(50))+' firmano='+cast(firmano as varchar(50))+' depkod='+depkod+' stktip='+stktip+' stkgrp1='+cast(stkgrp1 as varchar(50))+' stkgrp2='+cast(stkgrp2 as varchar(50))+' stkgrp3='+cast(stkgrp3 as varchar(50)) from deleted
  exec sp_loglama @firmano,@id,'sayimstkgrp',-2,@for_log
end

================================================================================
