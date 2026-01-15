-- Trigger: dbo.istkhrk_log_tru
-- Tablo: dbo.istkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.961758
================================================================================

CREATE TRIGGER [dbo].[istkhrk_log_tru] ON [dbo].[istkhrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'istkhrk',-1,''
  else
    exec sp_loglama @firmano,@id,'istkhrk',0,''
end

================================================================================
