-- Trigger: dbo.Prom_Puan_Hrk_tru
-- Tablo: dbo.Prom_Puan_Hrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.007076
================================================================================

CREATE TRIGGER [dbo].[Prom_Puan_Hrk_tru] ON [dbo].[Prom_Puan_Hrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
 Declare @Puanid 		int
 Declare @sil 			bit
 Declare @Kayok 		int
 
 select @Puanid=Puanid,
 @sil=sil,@Kayok=Kayok from inserted
 
 if @Puanid=0 
   RETURN
   
   
 if (@Kayok=1)
  begin
   exec stokhrkisle @Puanid,'Prom_Puan_Hrk','',@kayok,@sil,@Puanid
 end
END

================================================================================
