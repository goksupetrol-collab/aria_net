-- Trigger: dbo.Stkdeptrsmas_tru
-- Tablo: dbo.Stkdeptrsmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.029655
================================================================================

CREATE TRIGGER [dbo].[Stkdeptrsmas_tru] ON [dbo].[Stkdeptrsmas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
 
 declare @trs_id    float
 declare @sil 		int
 declare @tarih 	datetime
 declare @saat 	    varchar(10)
 
 
 select @sil=sil,@trs_id=trs_id,@tarih=tarih,@saat=saat from inserted


 if update(sil) or update(kayok)
  update stkdeptrs set sil=@sil,tarih=@tarih,saat=@saat where trs_id=@trs_id 

END

================================================================================
