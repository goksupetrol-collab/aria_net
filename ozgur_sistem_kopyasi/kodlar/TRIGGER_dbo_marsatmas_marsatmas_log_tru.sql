-- Trigger: dbo.marsatmas_log_tru
-- Tablo: dbo.marsatmas
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.975819
================================================================================

CREATE TRIGGER [dbo].[marsatmas_log_tru] ON [dbo].[marsatmas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'marsatmas',-1,''
  else
    exec sp_loglama @firmano,@id,'marsatmas',0,''
end

================================================================================
