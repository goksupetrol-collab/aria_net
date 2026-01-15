-- Trigger: dbo.kasakart_log_tru
-- Tablo: dbo.kasakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.968739
================================================================================

CREATE TRIGGER [dbo].[kasakart_log_tru] ON [dbo].[kasakart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'kasakart',-1,''
  else
    exec sp_loglama @firmano,@id,'kasakart',0,''
end

================================================================================
