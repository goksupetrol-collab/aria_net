-- Trigger: dbo.pomvardiperada_log_tru
-- Tablo: dbo.pomvardiperada
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.001296
================================================================================

CREATE TRIGGER [dbo].[pomvardiperada_log_tru] ON [dbo].[pomvardiperada]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'pomvardiperada',-1,''
  else
    exec sp_loglama @firmano,@id,'pomvardiperada',0,''
end

================================================================================
