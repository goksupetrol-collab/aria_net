-- Trigger: dbo.cekkart_log_tru
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.933980
================================================================================

CREATE TRIGGER [dbo].[cekkart_log_tru] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'cekkart',-1,''
  else
    exec sp_loglama @firmano,@id,'cekkart',0,''
end

================================================================================
