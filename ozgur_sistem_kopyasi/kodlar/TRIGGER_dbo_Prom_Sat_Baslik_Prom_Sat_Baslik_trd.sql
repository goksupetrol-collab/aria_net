-- Trigger: dbo.Prom_Sat_Baslik_trd
-- Tablo: dbo.Prom_Sat_Baslik
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.007545
================================================================================

CREATE TRIGGER [dbo].[Prom_Sat_Baslik_trd] ON [dbo].[Prom_Sat_Baslik]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
 Declare @Promid 		bigint
 Declare @sil 			bit
 Declare @Evraktip 		varchar(50)
 Declare @Kayok 		int
 Declare @Otomas_id		bigint
 
 select @Evraktip=fistip,@Promid=promid,
 @sil=sil,@Kayok=Kayok,@Otomas_id=Otomas_id from deleted
 
 if @Promid=0 
   RETURN
   
   
  update Prom_Sat_Hrk set sil=1 where promid=@Promid and sil=0  


  update otomasonlineoku set promid=0 where otomasid=@Otomas_id



  exec Prom_Puan_Hrk_isle  @Evraktip,@Promid,1 
  exec stokhrkisle @Promid,'Prom_Sat_Hrk','',1,1,@Promid

END

================================================================================
