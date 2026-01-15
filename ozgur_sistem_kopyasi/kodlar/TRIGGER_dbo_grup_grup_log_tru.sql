-- Trigger: dbo.grup_log_tru
-- Tablo: dbo.grup
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.951149
================================================================================

CREATE TRIGGER [dbo].[grup_log_tru] ON [dbo].[grup]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'grup',-1,''
  else
    exec sp_loglama @firmano,@id,'grup',0,''
end

================================================================================
