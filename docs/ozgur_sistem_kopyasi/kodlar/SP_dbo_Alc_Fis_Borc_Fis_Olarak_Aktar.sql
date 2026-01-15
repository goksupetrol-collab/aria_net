-- Stored Procedure: dbo.Alc_Fis_Borc_Fis_Olarak_Aktar
-- Tarih: 2026-01-14 20:06:08.315255
================================================================================

CREATE PROCEDURE [dbo].Alc_Fis_Borc_Fis_Olarak_Aktar
(@firmano  		int,
@fisrap_id 		int,
@varno    		int,
@varok    		int,
@yertip   		varchar(100),
@veridin  		varchar(8000),
@tarih    		datetime,
@saat	  		varchar(10),	
@perkod   		varchar(50),
@adaid    		int)
AS
BEGIN
  
 declare @yertipad   varchar(100)    
 declare @fistip     varchar(50)    
 declare @fistipad   varchar(100)    
 declare @say		 int
 declare @MESAJ		 varchar(300)		
 declare @gctip		 varchar(1)
 declare @fistip_id  int
 declare @fistur_id  int
 
 


 select @gctip=f.gctip,
 @fistip_id=tip_id,
 @fistur_id=tur_id,
 @fistip=r.rapkod,
 @fistipad=r.ack
 from raporlar r left join fattip f on f.kod=r.rapkod 
 where r.sil=0 and r.id=@fisrap_id
 
 
 select  @yertipad=ad from yertipad as y where y.kod=@yertip
   
   select @say=count(*) from veresimas as vs 
   where aktip not in ('BL','BK') 
       and verid in (select * from CsvToInt(@veridin))
       if @say>0
           begin
           SELECT @MESAJ = 'Seçmiş Olduğunuz Fişler İçinde Aktarılmış Fişler Var..!'
           RAISERROR (@MESAJ, 16,1)
           RETURN
       end


  declare @verid 		int
  declare @new_verid  	float

  declare fis_cur CURSOR FAST_FORWARD  
  FOR select verid from veresimas where verid in (select * from CsvToInt(@veridin))
   open fis_cur
  fetch next from  fis_cur into @verid
  while @@FETCH_STATUS=0
   begin

   insert into veresimas (firmano,verid,varno,kayok,
   gctip,FisRap_id,fistip_id,fistur_id,fisad,fistip,yertip,yerad,seri,[no],ykno,
   cartip,cartip_id,car_id,carkod,
   plaka,perkod,adaid,surucu,km,toptut,ack,kmsec,varok,sil,
   tarih,saat,
   ototag,olususer,degtarsaat,deguser,olustarsaat,dataok,aktip,fatbelno,
   aktar,vadtar,bagid,marsatid,parabrm,kur,akid) 
   select
   firmano,0,@varno,kayok,
   @gctip,@fisrap_id,@fistip_id,@fistur_id,
   @fistipad,@fistip,@yertip,@yertipad,seri,[no],ykno,
   cartip,cartip_id,car_id,carkod,
   plaka,@perkod,@adaid,surucu,km,0,'SEÇİLEN ALACAK FİŞİ',kmsec,@varok,sil,
   @tarih,@saat,ototag,olususer,degtarsaat,deguser,olustarsaat,0,aktip,fatbelno,
   aktar,vadtar,0,marsatid,parabrm,kur,akid
   from veresimas where verid=@verid
   
   select @new_verid=SCOPE_IDENTITY()
   
   
   
   insert into veresihrk (firmano,varno,verid,
   stktip_id,stktip,stk_id,stkod,mik,brmfiy,depkod,kdvyuz,brim,sil,olususer,
   olustarsaat,deguser,degtarsaat,dataok,yenbrmfiyfark,kayok,akfiytip)
   select firmano,varno,@new_verid,
   stktip_id,stktip,stk_id,stkod,mik,brmfiy,depkod,kdvyuz,brim,sil,olususer,
   olustarsaat,deguser,degtarsaat,0,yenbrmfiyfark,kayok,akfiytip 
   from veresihrk  where verid=@verid and sil=0


   /*veresiye fis olustur   */
    update veresimas set 
    verid=@new_verid,
    fis_alc_bagverid=@verid,
    kayok=1 where id=@new_verid
   
    update veresimas set 
    fis_alc_bagverid=@new_verid,
    kayok=1 where verid=@verid
    
    
   FETCH next from  fis_cur into @verid
  end
 close fis_cur
 deallocate fis_cur  
   
END

================================================================================
