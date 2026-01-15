-- Trigger: dbo.veresimas_log_tru
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.043782
================================================================================

CREATE TRIGGER [dbo].[veresimas_log_tru] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'veresimas',-1,''
  else
    exec sp_loglama @firmano,@id,'veresimas',0,''
end

================================================================================
