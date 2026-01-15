-- Trigger: dbo.marvardimas_log_tru
-- Tablo: dbo.marvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.980273
================================================================================

CREATE TRIGGER [dbo].[marvardimas_log_tru] ON [dbo].[marvardimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'marvardimas',-1,''
  else
    exec sp_loglama @firmano,@id,'marvardimas',0,''
end

================================================================================
