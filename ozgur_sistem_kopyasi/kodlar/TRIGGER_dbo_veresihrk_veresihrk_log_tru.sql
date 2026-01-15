-- Trigger: dbo.veresihrk_log_tru
-- Tablo: dbo.veresihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.040566
================================================================================

CREATE TRIGGER [dbo].[veresihrk_log_tru] ON [dbo].[veresihrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'veresihrk',-1,''
  else
    exec sp_loglama @firmano,@id,'veresihrk',0,''
end

================================================================================
