-- Trigger: dbo.carikart_log_tru
-- Tablo: dbo.carikart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.928352
================================================================================

CREATE TRIGGER [dbo].[carikart_log_tru] ON [dbo].[carikart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'carikart',-1,''
  else
    exec sp_loglama @firmano,@id,'carikart',0,''
end

================================================================================
