-- Stored Procedure: dbo.TarihKapat
-- Tarih: 2026-01-14 20:06:08.385298
================================================================================

CREATE PROCEDURE [dbo].TarihKapat
@firmano      int,
@bastar       datetime,
@bittar       datetime,
@drm          int,
@user_Ad      varchar(100)
AS
BEGIN

 declare   @tar    datetime

 set @tar=@bastar
 
 
 
   while @tar<=@bittar 
    begin
    
    if (select count(*) from tarih_kapat where 
    firmano=@firmano and Tarih=@tar and sil=0)=0 
     insert into tarih_kapat 
     (firmano,tarih,drm,olususer,olustarsaat)
     values (@firmano,@tar,@drm,@user_Ad,getdate())
     else
     update tarih_kapat 
     set drm=@drm,
     deguser=@user_Ad,
     degtarsaat=getdate()
     where firmano=@firmano and Tarih=@tar
     
     
     
    
    
    
    set @tar=DATEADD(day,1,@tar)
    
    end
   

END

================================================================================
