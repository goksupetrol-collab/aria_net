-- Stored Procedure: dbo.kasahrkgiris
-- Tarih: 2026-01-14 20:06:08.342097
================================================================================

CREATE PROCEDURE [dbo].kasahrkgiris @hrkid float,@sil int
AS
BEGIN

declare @varno 		float
declare @baktop 	float
declare @newid 		float
declare @masterid 	float
declare @gctip 		varchar(1)
declare @giren 		float
declare @cikan 		float
declare @yertip 	varchar(30)
declare @fisfattip  varchar(30)
  
declare @islmtip 	varchar(20)
declare @islmhrk 	varchar(20)
declare @cartip 	varchar(20)
declare @kashrkid 	float

  if @hrkid=0
   return

/*------- siliniyor */
if @sil=1
begin

 if (select count(*) from carihrk with (nolock)
 where masterid=@hrkid and karsihestip='kasakart' )>0
 delete from carihrk where masterid=@hrkid and karsihestip='kasakart'

 if (select count(*) from kasahrk with (nolock)
 where masterid=@hrkid and karsihestip='kasakart' )>0
  delete from kasahrk  where masterid=@hrkid and karsihestip='kasakart'

 if (select count(*) from istkhrk with (nolock)
 where masterid=@hrkid and karsihestip='kasakart' )>0
  delete from istkhrk where masterid=@hrkid and karsihestip='kasakart'


delete from TahsilatOdeme where id=
   (select top 1 tahodeid from kasahrk where kashrkid=@hrkid  )


RETURN
end
/*------- siliniyor */


/*------- bilgi giriliyor */
if @sil=0
begin

  select @gctip=gctip,@kashrkid=kashrkid,@islmtip=islmtip,@islmhrk=islmhrk,
  @masterid=masterid,@giren=giren,@cikan=cikan,@varno=varno,@cartip=cartip,
  @yertip=yertip,@fisfattip=fisfattip from kasahrk with (nolock)
  where kashrkid=@hrkid 

/*if @fisfattip='FIS' RETURN */

if (@islmhrk<>'TES') 
 begin

if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
or (@cartip='rehberkart')
 begin

  delete from carihrk where masterid=@kashrkid and karsihestip='kasakart'

  update istkhrk set sil=1,cartip='X' 
  where masterid=@kashrkid and karsihestip='kasakart'


    if @gctip='G'
    SET @gctip='A'
    if @gctip='C'
    SET @gctip='B'


  
  SELECT @newid=0 
  insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,
  islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod,CariAvans)
  select firmano,@newid,@gctip,@kashrkid,fisfattip,fisfatid,islmtip,islmtipad,
  islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,@cikan*kur,@giren*kur,0,tarih,saat,olususer,olustarsaat,vadetar,
  belno,ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
  'kasakart',kaskod,parabrm,
  'kasakart',kaskod,CariAvans 
  from kasahrk with (nolock) where kashrkid=@hrkid
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid  
 
  END


if (@cartip='istkart')
 begin

     set @gctip='G'

      delete from carihrk where masterid=@kashrkid and karsihestip='kasakart'
      
      /*update istkhrk set sil=1 where masterid=@kashrkid and karsihestip='kasakart' */
      
      /*delete istkhrk where masterid=@kashrkid and karsihestip='kasakart' */
      
      if (select count(*) from istkhrk with (nolock) where 
       masterid=@kashrkid and karsihestip='kasakart' and sil=0 )=0
       begin
        SELECT @newid=0
        insert into istkhrk (firmano,istkkod,istkhrkid,gctip,masterid,fisfattip,
        fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
        cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
        karsihestip,karsiheskod,parabrm,
        Karsi_Karttip,Karsi_KartKod)
        select firmano,carkod,@newid,@gctip,@kashrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
        'kasakart',kaskod,@cikan*kur,@giren*kur,tarih,saat,olususer,olustarsaat,
        vadetar,belno,
        ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
        'kasakart',kaskod,parabrm,
        'kasakart',kaskod
         from kasahrk with (nolock) where kashrkid=@hrkid
         select @newid=SCOPE_IDENTITY()
         update carihrk set carhrkid=@newid where id=@newid  
         
      end
       else
        begin
        update istkhrk set
        firmano=dt.firmano, 
        istkkod=dt.carkod,
        gctip=@gctip,masterid=@kashrkid,
        fisfattip=dt.fisfattip,fisfatid=dt.fisfatid,
        islmtip=dt.islmtip,islmtipad=dt.islmtipad,
        islmhrk=dt.islmhrk,islmhrkad=dt.islmhrkad,
        yertip=dt.yertip,yerad=dt.yerad,
        cartip='kasakart',carkod=dt.kaskod,
        borc=(@cikan*dt.kur),alacak=(@giren*dt.kur),
        tarih=dt.tarih,saat=dt.saat,
        olususer=dt.olususer,olustarsaat=dt.olustarsaat,
        vadetar=dt.vadetar,belno=dt.belno,
        ack=dt.ack,varno=dt.varno,kur=dt.kur,
        dataok=dt.dataok,varok=dt.varok,
        perkod=dt.perkod,adaid=dt.adaid,
        deguser=dt.deguser,degtarsaat=dt.degtarsaat,
        sil=dt.sil,karsihestip='kasakart',
        karsiheskod=dt.kaskod,parabrm=dt.parabrm,
        Karsi_Karttip='kasakart',
        Karsi_KartKod=dt.kaskod
        from istkhrk as t join
        (select firmano,carkod,fisfattip,fisfatid,
        islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
        kaskod,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
        parabrm from kasahrk with (nolock) where kashrkid=@hrkid and sil=0 ) dt
        on t.masterid=@kashrkid 
        and t.karsihestip='kasakart'
       end

  end

 end
end
 

END

================================================================================
