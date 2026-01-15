-- Stored Procedure: dbo.Fis_Cari_Borc
-- Tarih: 2026-01-14 20:06:08.329297
================================================================================

CREATE  PROCEDURE  [dbo].Fis_Cari_Borc (
@verid float,
@sil int)
AS
BEGIN

declare @newid float    
declare @fistip varchar(10)
declare @fistipad varchar(30)

declare @islmtip  		varchar(50)
declare @islmtipad 		varchar(50)
declare @islmhrk  		varchar(50)
declare @islmhrkad 		varchar(50)


  set @fistip='FISVERSAT'


 if @sil=1
  begin
    delete from veresimas where fis_cariver_id=@verid 
    
    delete from carihrk where fis_alc_id=@verid
    
    update veresimas set fis_alc_bagverid=0 
     where verid=(select top 1 fis_alc_bagverid 
     from veresimas with (nolock) where verid=@verid )

    RETURN
  end
  

    select @fistipad=ad from fattip where kod=@fistip
   
   
   if @sil=0
   begin 
     delete from veresimas where fis_cariver_id=@verid
   
    if EXISTS ( select id from veresimas with (nolock) where verid=@verid and brc_carsec=1 )
     begin
   
    
      select @newid=0
      insert into veresimas (
      verid,varno,kayok,fisad,fisrap_id,fistip,yertip,tarih,yerad,seri,[no],ykno,cartip,
      carkod,plaka,perkod,adaid,surucu,km,toptut,ack,kmsec,varok,sil,saat,
      ototag,olususer,degtarsaat,deguser,olustarsaat,dataok,aktip,fatbelno,
      aktar,vadtar,bagid,marsatid,parabrm,kur,akid,fis_cariver_id) 
      select
      @newid,varno,kayok,@fistipad,fisrap_id,@fistip,yertip,tarih,yerad,seri,[no],ykno,
      brc_cartip,brc_carkod,plaka,perkod,adaid,surucu,km,0,ack+' - BAĞLI FİŞ',kmsec,varok,sil,saat,
      ototag,olususer,degtarsaat,deguser,olustarsaat,0,aktip,fatbelno,
      aktar,vadtar,@verid,marsatid,parabrm,kur,akid,@verid 
      from veresimas with (nolock) where verid=@verid and brc_carsec=1
      select @newid=SCOPE_IDENTITY()
      update veresimas set verid=@newid where id=@newid
      
      
      insert into veresihrk (varno,verid,stktip,stkod,mik,brmfiy,depkod,kdvyuz,brim,sil,olususer,
      olustarsaat,deguser,degtarsaat,dataok,yenbrmfiyfark,kayok,akfiytip)
      select varno,@newid,stktip,stkod,mik,brmfiy,depkod,kdvyuz,brim,sil,olususer,
      olustarsaat,deguser,degtarsaat,0,yenbrmfiyfark,kayok,akfiytip from veresihrk with (nolock)
      where verid=@verid and sil=0 
    end  
   
   
   /*alacak fisine cari yansıması  */
    if EXISTS ( select id from veresimas with (nolock) where verid=@verid 
    and (fis_alc_kocan=1 ) and fistip='FISALCSAT') 
     begin
     
      delete from carihrk where fis_alc_id=@verid
     
     
     
       set @islmtip='FIS'
        SELECT @islmtipad=AD from islemturtip where tip=@islmtip
        set @islmhrk='AFG'
        SELECT @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
     
     
       select @newid=0
       insert into carihrk (carhrkid,gctip,masterid,fisfattip,fisfatid,
       islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
       cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
        karsihestip,karsiheskod,parabrm,fis_alc_id)
        
       select @newid,
       'B',0,'',0,
       @islmtip,@islmtipad,@islmhrk,@islmhrkad,yertip,yerad,
       cartip,carkod,toptut,0,0,tarih,saat,olususer,olustarsaat,vadtar,
       seri+CAST([no] as varchar),ack,varno,kur,0,0,varok,perkod,adaid,
       deguser,degtarsaat,sil,'','',parabrm,@verid
       from veresimas with (nolock)
       where verid=@verid and sil=0 
       
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
       
      
      return  
       
   
   end
   
   
    
   /*alacak fisine cari yansıması  */
    if EXISTS ( select id from veresimas with (nolock) where verid=@verid 
    and (brc_carsec=0 or (brc_carsec is null) ) and (fis_alc_kocan=0) and fistip='FISALCSAT')
     begin
     
      delete from carihrk where fis_alc_id=@verid
     
     
     
     set @islmtip='FIS'
     SELECT @islmtipad=AD from islemturtip where tip=@islmtip
     set @islmhrk='AFG'
     SELECT @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
     
     
       select @newid=0
       insert into carihrk (carhrkid,gctip,masterid,fisfattip,fisfatid,
       islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
       cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
        karsihestip,karsiheskod,parabrm,fis_alc_id)
        
       select @newid,
       'B',0,'',0,
       @islmtip,@islmtipad,@islmhrk,@islmhrkad,yertip,yerad,
       cartip,carkod,toptut,0,0,tarih,saat,olususer,olustarsaat,vadtar,
       seri+CAST([no] as varchar),ack,varno,kur,0,0,varok,perkod,adaid,
       deguser,degtarsaat,sil,'','',parabrm,@verid
       from veresimas with (nolock)
       where verid=@verid and sil=0 
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
      
        
       
    end
     
   end

END

================================================================================
