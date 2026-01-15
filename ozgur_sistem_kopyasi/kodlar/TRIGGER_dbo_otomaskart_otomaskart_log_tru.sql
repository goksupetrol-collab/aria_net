-- Trigger: dbo.otomaskart_log_tru
-- Tablo: dbo.otomaskart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.984541
================================================================================

CREATE TRIGGER [dbo].[otomaskart_log_tru] ON [dbo].[otomaskart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'otomaskart',-1,''
  else
    exec sp_loglama @firmano,@id,'otomaskart',0,''
end

================================================================================
