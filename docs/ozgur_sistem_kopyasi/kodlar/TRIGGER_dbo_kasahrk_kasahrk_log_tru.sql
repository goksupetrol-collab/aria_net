-- Trigger: dbo.kasahrk_log_tru
-- Tablo: dbo.kasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.965950
================================================================================

CREATE TRIGGER [dbo].[kasahrk_log_tru] ON [dbo].[kasahrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'kasahrk',-1,''
  else
    exec sp_loglama @firmano,@id,'kasahrk',0,''
end

================================================================================
