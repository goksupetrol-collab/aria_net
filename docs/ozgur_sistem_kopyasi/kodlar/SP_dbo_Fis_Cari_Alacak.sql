-- Stored Procedure: dbo.Fis_Cari_Alacak
-- Tarih: 2026-01-14 20:06:08.328670
================================================================================

CREATE PROCEDURE  [dbo].[Fis_Cari_Alacak] (
@verid 	float,
@sil 	int)
AS
BEGIN

declare @newid float    
declare @fistip varchar(10)
declare @fistipad varchar(30)

declare @islmtip  		varchar(50)
declare @islmtipad 		varchar(50)
declare @islmhrk  		varchar(50)
declare @islmhrkad 		varchar(50)


declare @ack 			varchar(200)
declare @carkod 		varchar(50)
declare @cartip			varchar(50)
declare @alc_carsec     bit





 if @verid=0
  RETURN


 if @sil=1
  begin
    
    delete from carihrk where fis_brc_id=@verid
    
    RETURN
  end
  

  if @sil=0
   begin 
   
    set @alc_carsec=0
      
    select @alc_carsec=alc_carsec from veresimas with (nolock) where verid=@verid 
    and alc_carsec=1 and fistip='FISVERSAT' and sil=0   
   
    if @alc_carsec=0
      update carihrk set sil=1 where fis_brc_id=@verid and sil=0
   
   
    if (@alc_carsec=1)
     begin
    
     /*veresiye fisine cari yansıması  */
    
      delete from carihrk where fis_brc_id=@verid
     
     
      select @carkod=carkod,@cartip=cartip
      from veresimas with (nolock)
      where verid=@verid and sil=0 
     
      select @ack='FİŞ ALACAK - C/H : '+@carkod+' / '+ad from 
      Genel_Kart as k where k.cartp=@cartip and k.kod=@carkod
    
    
       set @islmtip='FIS'
        SELECT @islmtipad=AD from islemturtip where tip=@islmtip
        set @islmhrk='VFG'
        SELECT @islmhrkad=ad from islemhrktip where tip=@islmtip 
        and hrk=@islmhrk
     
     
       select @newid=0  
       insert into carihrk (carhrkid,firmano,gctip,masterid,fisfattip,fisfatid,
       islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
       cartip,cartip_id,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
       ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
       karsihestip,karsiheskod,parabrm,fis_brc_id)
  
       select 0,
       firmano,'A',0,'',0,
       @islmtip,@islmtipad,@islmhrk,@islmhrkad,yertip,yerad,
       cartip,cartip_id,brc_carkod,0,toptut,0,tarih,saat,olususer,olustarsaat,vadtar,
       seri+CAST([no] as varchar),@ack,varno,kur,0,0,varok,perkod,adaid,
       deguser,degtarsaat,sil,'','',parabrm,@verid
       from veresimas with (nolock) where verid=@verid and sil=0 
       
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
       
      
      return  
   
   end    
   
   end

END

================================================================================
