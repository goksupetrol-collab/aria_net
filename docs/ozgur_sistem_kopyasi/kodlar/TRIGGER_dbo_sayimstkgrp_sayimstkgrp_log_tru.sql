-- Trigger: dbo.sayimstkgrp_log_tru
-- Tablo: dbo.sayimstkgrp
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.020762
================================================================================

CREATE TRIGGER [dbo].[sayimstkgrp_log_tru] ON [dbo].[sayimstkgrp]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'sayimstkgrp',-1,''
  else
    exec sp_loglama @firmano,@id,'sayimstkgrp',0,''
end

================================================================================
