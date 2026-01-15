-- Trigger: dbo.pomvardimas_log_tru
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.997777
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_log_tru] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'pomvardimas',-1,''
  else
    exec sp_loglama @firmano,@id,'pomvardimas',0,''
end

================================================================================
