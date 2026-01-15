-- Stored Procedure: dbo.KasaKapat
-- Tarih: 2026-01-14 20:06:08.343160
================================================================================

CREATE PROCEDURE [dbo].[KasaKapat]
@firmano      int,
@kaskod		  varchar(50),
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
    
    if (select count(*) from Kasa_kapat where 
    firmano=@firmano and kaskod=@kaskod and Tarih=@tar and sil=0)=0 
     insert into Kasa_kapat 
     (firmano,kaskod,tarih,drm,olususer,olustarsaat)
     values (@firmano,@kaskod,@tar,@drm,@user_Ad,getdate())
     else
     update Kasa_kapat 
     set drm=@drm,
     deguser=@user_Ad,
     degtarsaat=getdate()
     where firmano=@firmano and kaskod=@kaskod and Tarih=@tar
     

    set @tar=DATEADD(day,1,@tar)
    
    end
   

END

================================================================================
