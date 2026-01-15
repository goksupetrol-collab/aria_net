-- Trigger: dbo.marsathrk_log_tru
-- Tablo: dbo.marsathrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.972788
================================================================================

CREATE TRIGGER [dbo].[marsathrk_log_tru] ON [dbo].[marsathrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'marsathrk',-1,''
  else
    exec sp_loglama @firmano,@id,'marsathrk',0,''
end

================================================================================
