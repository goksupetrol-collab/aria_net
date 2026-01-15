-- Trigger: dbo.siparishrk_log_tru
-- Tablo: dbo.siparishrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.022987
================================================================================

CREATE TRIGGER [dbo].[siparishrk_log_tru] ON [dbo].[siparishrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'siparishrk',-1,''
  else
    exec sp_loglama @firmano,@id,'siparishrk',0,''
end

================================================================================
