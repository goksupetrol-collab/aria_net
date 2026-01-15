-- Trigger: dbo.stokkart_log_tru
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.033612
================================================================================

CREATE TRIGGER [dbo].[stokkart_log_tru] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted

  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'stokkart',-1,''
  else
   begin
    if update(sat1fiy) or update(alsfiy)
    or update(sat2fiy) or update(sat3fiy)
    exec sp_loglama @firmano,@id,'stokkart',0,''
    
    end
end

================================================================================
