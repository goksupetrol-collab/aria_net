-- Trigger: dbo.emtiasat_log_tru
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.938130
================================================================================

CREATE TRIGGER [dbo].[emtiasat_log_tru] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'emtiasat',-1,''
  else
    exec sp_loglama @firmano,@id,'emtiasat',0,''
end

================================================================================
