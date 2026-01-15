-- Stored Procedure: dbo.bankhrkgiris
-- Tarih: 2026-01-14 20:06:08.316026
================================================================================

CREATE PROCEDURE [dbo].bankhrkgiris @id int
AS
BEGIN

declare @varno float
declare @sil  int
declare @baktop float
declare @newid float
declare @gctip varchar(1)
declare @borc float,@alacak float
  
/*-masraf */
declare @gidtipkod varchar(20)
declare @gidtiphrkkod varchar(20)
declare @gidtipad varchar(30)
declare @gidtiphrkad varchar(30)
declare @gidkod varchar(30)

/*faiz masraf */
declare @faiz_gidtipkod varchar(20)
declare @faiz_gidtiphrkkod varchar(20)

declare @deguser varchar(100)
declare @degtarsaat datetime

declare @gidtutar float
declare @firmano    float
/*-masraf */
  
  
/*banka işlemleri */

  declare @islmtip varchar(20)
  declare @islmhrk varchar(20)
  declare @bankhrkid float

  /*-masraf kodları */
  set @gidtipkod='GLG'
  set @gidtiphrkkod='BMF'
  
  
   /*-faiz masraf kodları */
  set @faiz_gidtipkod='GLG'
  set @faiz_gidtiphrkkod='BFZ'
  

  

  select @firmano=firmano,@bankhrkid=bankhrkid,@sil=sil,
  @islmtip=islmtip,@islmhrk=islmhrk,
  @borc=borc,@alacak=alacak,@varno=varno,
  @gidkod=gidkod,@gidtutar=gidtutar,
  @deguser=deguser,
  @degtarsaat=degtarsaat
  from bankahrk with (nolock)
  where id=@id


   if @bankhrkid=0
    RETURN


  if @sil=1
  begin
    if (@islmhrk='YTN') or (@islmhrk='CKN')
      update kasahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
      where masterid=@bankhrkid and karsihestip='bankakart'
      and islmhrk=@islmhrk and Sil=0
    
    if (@islmhrk='B-C') or (@islmhrk='C-B')
    update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk and Sil=0
    
    if (@islmhrk='BKK') or (@islmhrk='EKK')
    update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk and Sil=0
    
    if (@islmhrk='BNK') or (@islmhrk='IKO')
    update istkhrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk and Sil=0
    

    update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid and 
    karsihestip='bankakart' and islmhrk=@islmhrk and Sil=0
    
    
    /*banka masraf yansıması silimi */
    update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid 
    and karsihestip='bankakart' and islmtip=@gidtipkod 
    and islmhrk=@gidtiphrkkod and Sil=0
    
    
    /*gelir gider masraf yansıması */
     update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
     where masterid=@bankhrkid
     and islmtip=@gidtipkod and islmhrk=@gidtiphrkkod 
     and karsihestip='bankakart' and Sil=0
   
  
   
    /*banka faiz yansıması silimi */
    update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid 
    and karsihestip='bankakart' and islmtip=@faiz_gidtipkod 
    and islmhrk=@faiz_gidtiphrkkod and Sil=0
    
    /*gelir gider faiz yansıması  */
     update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat  
     where masterid=@bankhrkid
     and islmtip=@faiz_gidtipkod and islmhrk=@faiz_gidtiphrkkod 
     and karsihestip='bankakart' and Sil=0
  
  return
  end
  
  
  
  
  


 if (@islmhrk='IKO')
   begin

          SET @gctip='C'

          delete from istkhrk where masterid=@bankhrkid and karsihestip='bankakart'
         
          select @newid=0 
          insert into istkhrk (firmano,istkkod,istkhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
          ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
          karsihestip,karsiheskod,parabrm,
          Karsi_Karttip,Karsi_KartKod)
          select firmano,carkod,@newid,@gctip,@bankhrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          'bankakart',bankod,@alacak*kur,@borc*kur,tarih,saat,olususer,olustarsaat,
          vadetar,belno,
          ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
          'bankakart',bankod,parabrm,
          'bankakart',bankod
           from bankahrk with (nolock) where id=@id
           select @newid=SCOPE_IDENTITY()
           update istkhrk set istkhrkid=@newid where id=@newid

  end



if (@islmhrk='YTN') or (@islmhrk='CKN')
 begin
   if @islmhrk='YTN'
    SET @gctip='G'
    if @islmhrk='CKN'
    SET @gctip='C'
   

    delete from kasahrk where masterid=@bankhrkid and karsihestip='bankakart'

    select @newid=0 
    insert into kasahrk (firmano,kaskod,kashrkid,gctip,varno,masterid,fisfattip,
    fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,
    yerad,perkod,adaid,giren,cikan,bakiye,carkod,cartip,tarih,saat,
    belno,ack,kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,dataok,parabrm,
    karsihestip,karsiheskod,
    Karsi_Karttip,Karsi_KartKod)
    select firmano,kaskod,@newid,@gctip,varno,@bankhrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,
    yerad,perkod,adaid,@alacak,@borc,0,bankod,'bankakart',tarih,saat,belno,ack,kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,dataok,parabrm,'bankakart',bankod,
    'bankakart',bankod from bankahrk with (nolock) where id=@id
    
    select @newid=SCOPE_IDENTITY()
    update kasahrk set kashrkid=@newid where id=@newid
    
    
    
 end

 if (@islmhrk='B-C') or (@islmhrk='C-B')
  begin
  
      /*banka masraf yansıması sil */
      delete from bankahrk where masterid=@bankhrkid 
      and karsihestip='bankakart' and islmtip=@gidtipkod 
      and islmhrk=@gidtiphrkkod 
  
    
      delete from carihrk where masterid=@bankhrkid and karsihestip='bankakart'

      select @newid=0
      insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,CariAvans,
      Karsi_Karttip,Karsi_KartKod)
      select firmano,@newid,gctip,@bankhrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,@alacak*kur,@borc*kur,0,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
      'bankakart',bankod,parabrm,CariAvans,
      'bankakart',bankod from bankahrk with (nolock) where id=@id
      select @newid=SCOPE_IDENTITY()
      update carihrk set carhrkid=@newid where id=@newid
      
  end

 /*-pos masraf kom */
  if (@islmhrk='BKK') or (@islmhrk='EKK')
  begin
  
      delete from carihrk where masterid=@bankhrkid
      and islmtip='BNK' and islmhrk=@islmhrk and karsihestip='bankakart'


      select @newid=0 
      insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,CariAvans,
      Karsi_Karttip,Karsi_KartKod)
      select firmano,@newid,gctip,@bankhrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,@alacak,@borc,0,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
      'bankakart',bankod,parabrm,CariAvans,
      'bankakart',bankod from bankahrk with (nolock) where id=@id
      and islmtip='BNK' and islmhrk=@islmhrk
      
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
      
      
  end



  /*banka gelir gider kasa yansıması silimi */
  if (@islmhrk<>'VRG') and (@islmhrk<>'VKG')
   begin
   
   
   if  (@islmhrk='VRC')  
    begin
      /*banka masraf yansıması silimi */
      delete from bankahrk where masterid=@bankhrkid 
      and karsihestip='bankakart' and islmtip=@gidtipkod 
      and islmhrk=@gidtiphrkkod
      
      
       /*gelir gider masraf yansıması silimi */
       delete from carihrk where masterid=@bankhrkid
       and islmtip=@gidtipkod and islmhrk=@gidtiphrkkod 
       and karsihestip='bankakart'
     end  
      
      
      if (@islmhrk='VKC')
       begin
       /*banka faiz yansıması silimi */
        delete from bankahrk where masterid=@bankhrkid 
        and karsihestip='bankakart' and islmtip=@faiz_gidtipkod 
        and islmhrk=@faiz_gidtiphrkkod
        
        
       /*-gelir gider faiz yansıması silimi */
       delete from carihrk where masterid=@bankhrkid
       and islmtip=@faiz_gidtipkod and islmhrk=@faiz_gidtiphrkkod 
       and karsihestip='bankakart'
      end

   end
   
   
   
   
   
   
    /*banka masraf yansıması silimi */
    if (@islmhrk<>'VRG')
    update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
    where masterid=@bankhrkid 
    and karsihestip='bankakart' and islmtip=@gidtipkod 
    and islmhrk=@gidtiphrkkod and Sil=0
    
    
    /*gelir gider masraf yansıması */
    if (@islmhrk<>'VRG')
     update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat 
     where masterid=@bankhrkid
     and islmtip=@gidtipkod and islmhrk=@gidtiphrkkod 
     and karsihestip='bankakart' and Sil=0
   
   
   
  if @gidtutar>0
    begin

     
     SELECT @gidtipad=ad from islemturtip where tip=@gidtipkod
     SELECT @gidtiphrkad=ad from islemhrktip where tip=@gidtipkod and hrk=@gidtiphrkkod

      if @islmtip='KRD' and @islmhrk='VKC'
       begin
        set @gidtipkod=@faiz_gidtipkod
        set @gidtiphrkkod=@faiz_gidtiphrkkod
        
        SELECT @gidtipad=ad from islemturtip where tip=@gidtipkod
        SELECT @gidtiphrkad=ad from islemhrktip where tip=@gidtipkod 
        and hrk=@gidtiphrkkod
       end
     
      

     /*--BANKA MASRAF GİRİŞİ */
      select @newid=0
      insert into bankahrk (firmano,bankod,bankhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,vadetar,tarih,saat,olususer,olustarsaat,belno,
      ack,varno,kur,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,
      Karsi_Karttip,Karsi_KartKod)
      select firmano,bankod,@newid,'A',@bankhrkid,fisfattip,fisfatid,
      @gidtipkod,@gidtipad,@gidtiphrkkod,@gidtiphrkad,yertip,yerad,
      'gelgidkart',@gidkod,0,@gidtutar,vadetar,tarih,saat,olususer,olustarsaat,belno,
      ack,varno,kur,varok,perkod,adaid,deguser,degtarsaat,sil,
      'bankakart',bankod,parabrm,
      'bankakart',bankod  from bankahrk where id=@id
      
       select @newid=SCOPE_IDENTITY()
       update bankahrk set bankhrkid=@newid where id=@newid
      
      /*masraf gelir gider yansıması */
         
    
          select @newid=0 
          insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
          ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
          karsihestip,karsiheskod,parabrm,CariAvans,
          Karsi_Karttip,Karsi_KartKod)
          select firmano,@newid,gctip,@bankhrkid,fisfattip,fisfatid,@gidtipkod,@gidtipad,@gidtiphrkkod,@gidtiphrkad,yertip,yerad,
          'gelgidkart',@gidkod,@gidtutar*kur,0,0,tarih,saat,olususer,olustarsaat,vadetar,belno,
          ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
          'bankakart',bankod,parabrm,CariAvans,
          'bankakart',bankod from bankahrk with (nolock) where id=@id
          
           select @newid=SCOPE_IDENTITY()
           update carihrk set carhrkid=@newid where id=@newid
          


     end

  
  
END

================================================================================
