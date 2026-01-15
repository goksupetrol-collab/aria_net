-- Trigger: dbo.irsaliyehrk_log_tru
-- Tablo: dbo.irsaliyehrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.953176
================================================================================

CREATE TRIGGER [dbo].[irsaliyehrk_log_tru] ON [dbo].[irsaliyehrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'irsaliyehrk',-1,''
  else
    exec sp_loglama @firmano,@id,'irsaliyehrk',0,''
end

================================================================================
