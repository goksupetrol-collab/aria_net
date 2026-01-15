-- Trigger: dbo.fismas_log_tru
-- Tablo: dbo.fismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.946799
================================================================================

CREATE TRIGGER [dbo].[fismas_log_tru] ON [dbo].[fismas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'fismas',-1,''
  else
    exec sp_loglama @firmano,@id,'fismas',0,''
end

================================================================================
