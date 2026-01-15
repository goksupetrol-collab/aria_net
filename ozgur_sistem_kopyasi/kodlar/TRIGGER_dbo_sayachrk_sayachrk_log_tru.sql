-- Trigger: dbo.sayachrk_log_tru
-- Tablo: dbo.sayachrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.012247
================================================================================

CREATE TRIGGER [dbo].[sayachrk_log_tru] ON [dbo].[sayachrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'sayachrk',-1,''
  else
    exec sp_loglama @firmano,@id,'sayachrk',0,''
end

================================================================================
