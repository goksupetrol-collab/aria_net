-- Trigger: dbo.tankkart_log_tru
-- Tablo: dbo.tankkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.036577
================================================================================

CREATE TRIGGER [dbo].[tankkart_log_tru] ON [dbo].[tankkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'tankkart',-1,''
  else
    exec sp_loglama @firmano,@id,'tankkart',0,''
end

================================================================================
