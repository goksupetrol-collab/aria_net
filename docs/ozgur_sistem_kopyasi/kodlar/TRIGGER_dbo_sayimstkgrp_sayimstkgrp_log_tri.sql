-- Trigger: dbo.sayimstkgrp_log_tri
-- Tablo: dbo.sayimstkgrp
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.020411
================================================================================

CREATE TRIGGER [dbo].[sayimstkgrp_log_tri] ON [dbo].[sayimstkgrp]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'sayimstkgrp',1,''
end

================================================================================
