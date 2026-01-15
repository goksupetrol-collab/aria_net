-- Trigger: dbo.cekhrk_log_tru
-- Tablo: dbo.cekhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.932057
================================================================================

CREATE TRIGGER [dbo].[cekhrk_log_tru] ON [dbo].[cekhrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
begin
  Declare @firmano int,@id int,@islem int,@sil bit
  Select @firmano=firmano,@id=id,@sil=isnull(sil,0) from inserted
  if update(sil) and (@sil=1)
    exec sp_loglama @firmano,@id,'cekhrk',-1,''
  else
    exec sp_loglama @firmano,@id,'cekhrk',0,''
end

================================================================================
