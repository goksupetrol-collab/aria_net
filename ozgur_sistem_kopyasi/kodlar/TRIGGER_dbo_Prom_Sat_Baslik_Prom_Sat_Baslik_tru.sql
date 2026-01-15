-- Trigger: dbo.Prom_Sat_Baslik_tru
-- Tablo: dbo.Prom_Sat_Baslik
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.007957
================================================================================

CREATE TRIGGER [dbo].[Prom_Sat_Baslik_tru] ON [dbo].[Prom_Sat_Baslik]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
  
 Declare @Promid 		bigint
 Declare @sil 			bit
 Declare @Evraktip 		varchar(50)
 Declare @Kayok 		int
 Declare @Otomas_id 	bigint
 
 select @Evraktip=fistip,@Promid=promid,
 @sil=sil,@Kayok=Kayok,@Otomas_id=Otomas_id from inserted
 
 if @Promid=0 
   RETURN
   
   
 update Prom_Sat_Hrk set sil=@sil where promid=@Promid and sil=0  

 if (@Kayok=1)
  begin
  exec Prom_Puan_Hrk_isle  @Evraktip,@Promid,@sil 
  exec stokhrkisle @Promid,'Prom_Sat_Hrk','',@kayok,@sil,@Promid
  
  if @sil=0
   update otomasonlineoku set promid=@Promid
    where otomasid=@Otomas_id


   if @sil=1
   begin
    if @Otomas_id>0
     begin
      update otomasonlineoku set promid=0 where otomasid=@Otomas_id
      update Prom_Sat_Baslik set sil=1 where otomas_id=@Otomas_id    
     end 
   end
 



  
  end
  


END

================================================================================
