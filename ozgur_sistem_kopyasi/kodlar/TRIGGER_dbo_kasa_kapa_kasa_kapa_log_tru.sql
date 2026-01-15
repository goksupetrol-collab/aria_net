-- Trigger: dbo.kasa_kapa_log_tru
-- Tablo: dbo.kasa_kapa
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.964335
================================================================================

CREATE TRIGGER [dbo].[kasa_kapa_log_tru] ON [dbo].[kasa_kapa]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'kasa_kapa',-1,''
  else
    exec sp_loglama @firmano,@id,'kasa_kapa',0,''
end

================================================================================
