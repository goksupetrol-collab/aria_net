-- Trigger: dbo.marvardikap_log_tru
-- Tablo: dbo.marvardikap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.978974
================================================================================

CREATE TRIGGER [dbo].[marvardikap_log_tru] ON [dbo].[marvardikap]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'marvardikap',-1,''
  else
    exec sp_loglama @firmano,@id,'marvardikap',0,''
end

================================================================================
