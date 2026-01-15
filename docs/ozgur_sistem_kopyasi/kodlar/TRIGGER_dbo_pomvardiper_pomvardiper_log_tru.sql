-- Trigger: dbo.pomvardiper_log_tru
-- Tablo: dbo.pomvardiper
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.000143
================================================================================

CREATE TRIGGER [dbo].[pomvardiper_log_tru] ON [dbo].[pomvardiper]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'pomvardiper',-1,''
  else
    exec sp_loglama @firmano,@id,'pomvardiper',0,''
end

================================================================================
