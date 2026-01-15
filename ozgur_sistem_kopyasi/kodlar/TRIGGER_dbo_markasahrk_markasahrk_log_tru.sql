-- Trigger: dbo.markasahrk_log_tru
-- Tablo: dbo.markasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.971028
================================================================================

CREATE TRIGGER [dbo].[markasahrk_log_tru] ON [dbo].[markasahrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'markasahrk',-1,''
  else
    exec sp_loglama @firmano,@id,'markasahrk',0,''
end

================================================================================
