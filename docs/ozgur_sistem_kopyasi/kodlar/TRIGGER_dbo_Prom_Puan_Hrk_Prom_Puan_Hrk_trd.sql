-- Trigger: dbo.Prom_Puan_Hrk_trd
-- Tablo: dbo.Prom_Puan_Hrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.006672
================================================================================

CREATE TRIGGER [dbo].[Prom_Puan_Hrk_trd] ON [dbo].[Prom_Puan_Hrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
 Declare @Puanid 		int
 Declare @sil 			bit
 Declare @Kayok 		int
 
 select @Puanid=Puanid,
 @sil=sil,@Kayok=Kayok
 from deleted

   if @Puanid=0 
   RETURN

 
  exec stokhrkisle @Puanid,'Prom_Puan_Hrk','',1,1,@Puanid

END

================================================================================
