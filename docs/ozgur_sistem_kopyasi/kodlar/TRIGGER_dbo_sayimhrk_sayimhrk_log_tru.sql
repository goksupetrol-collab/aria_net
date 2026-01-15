-- Trigger: dbo.sayimhrk_log_tru
-- Tablo: dbo.sayimhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.016472
================================================================================

CREATE TRIGGER [dbo].[sayimhrk_log_tru] ON [dbo].[sayimhrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'sayimhrk',-1,''
  else
    exec sp_loglama @firmano,@id,'sayimhrk',0,''
end

================================================================================
