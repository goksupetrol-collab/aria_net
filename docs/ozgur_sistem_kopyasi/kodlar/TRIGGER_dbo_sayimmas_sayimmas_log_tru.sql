-- Trigger: dbo.sayimmas_log_tru
-- Tablo: dbo.sayimmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.018918
================================================================================

CREATE TRIGGER [dbo].[sayimmas_log_tru] ON [dbo].[sayimmas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'sayimmas',-1,''
  else
    exec sp_loglama @firmano,@id,'sayimmas',0,''
end

================================================================================
