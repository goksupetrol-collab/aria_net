-- Trigger: dbo.stkbrm_log_tru
-- Tablo: dbo.stkbrm
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.026877
================================================================================

CREATE TRIGGER [dbo].[stkbrm_log_tru] ON [dbo].[stkbrm]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'stkbrm',-1,''
  else
    exec sp_loglama @firmano,@id,'stkbrm',0,''
end

================================================================================
