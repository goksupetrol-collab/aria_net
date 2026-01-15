-- Trigger: dbo.perakendekart_log_tru
-- Tablo: dbo.perakendekart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.990492
================================================================================

CREATE TRIGGER [dbo].[perakendekart_log_tru] ON [dbo].[perakendekart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'perakendekart',-1,''
  else
    exec sp_loglama @firmano,@id,'perakendekart',0,''
end

================================================================================
