-- Trigger: dbo.perkart_log_tru
-- Tablo: dbo.perkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.992986
================================================================================

CREATE TRIGGER [dbo].[perkart_log_tru] ON [dbo].[perkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'perkart',-1,''
  else
    exec sp_loglama @firmano,@id,'perkart',0,''
end

================================================================================
