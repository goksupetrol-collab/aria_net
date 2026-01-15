-- Stored Procedure: dbo.poshrkgiris
-- Tarih: 2026-01-14 20:06:08.359987
================================================================================

CREATE PROCEDURE [dbo].poshrkgiris @hrkid float
AS
BEGIN

declare @varno 		float
declare @baktop 	float
declare @newid 		float
declare @anaid 		bigint
declare @gctip 		varchar(1)
declare @giren 		float
declare @cikan 		float
declare @poskod 	varchar(20)
  
declare @islmtip 	varchar(20)
declare @islmhrk 	varchar(20)
declare @cartip 	varchar(20)
declare @poshrkid 	float

declare @devir 	    bit

  select @gctip=gctip,@poshrkid=poshrkid,
  @islmtip=islmtip,@islmhrk=islmhrk,
  @giren=giren,@cikan=cikan,@varno=varno,
  @cartip=cartip,@anaid=ana_id,
  @devir=devir 
  from poshrk with (nolock) where poshrkid=@hrkid

 if @devir=1
  return

 if @poshrkid=0
  return

  
  if @anaid>0
   begin
    set @poshrkid=@anaid
    select @giren=sum(giren),@cikan=sum(cikan) from
    poshrk with (nolock)  where ana_id=@anaid  and sil=0
   end  
   


 /*delete from carihrk where masterid=@poshrkid and karsihestip='poskart' */
  update carihrk set sil=1,dataok=0 where masterid=@poshrkid  
  and islmtip=@islmtip and islmhrk=@islmhrk 
  and karsihestip='poskart'


  update istkhrk set sil=1,dataok=0 where masterid=@poshrkid  
  and islmtip=@islmtip and islmhrk=@islmhrk 
  and karsihestip='poskart'

   if @cartip<>''
    begin

    if (@cartip='carikart') or (@cartip='perkart') 
    or (@cartip='gelgidkart')
     begin
     /* select @newid=max(carhrkid)+1 from carihrk */
      insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip_id,cartip,car_id,carkod,borc,alacak,bakiye,tarih,saat,
      olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,
      adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,
      fatid,
      Karsi_Karttip,Karsi_KartKod) 
      select top 1 firmano,0,@gctip,@poshrkid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip_id,cartip,car_id,carkod,@cikan,@giren,0,tarih,saat,
      olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
      'poskart',poskod,parabrm,fatid,
      'poskart',poskod      
       from poshrk with (nolock)  where poshrkid=@poshrkid
      order by id
      
      select @newid=SCOPE_IDENTITY()
         
      update carihrk set carhrkid=@newid where id=@newid
      
      
      
    END

    
    
    if (@cartip='istkart') 
     begin
      insert into istkhrk (firmano,
      istkhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      istkkod,cartip_id,cartip,car_id,carkod,borc,alacak,tarih,saat,
      olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,varok,perkod,
      adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,fatid,
      Karsi_Karttip,Karsi_KartKod) 
      select top 1 firmano,0,@gctip,@poshrkid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      carkod,5,'poskart',pos_id,poskod,
      @cikan,@giren,tarih,saat,
      olususer,olustarsaat,car_vadetar,belno,
      ack,varno,kur,dataok,varok,perkod,adaid,deguser,degtarsaat,sil,
      'poskart',poskod,parabrm,fatid,
      'poskart',poskod
       from poshrk with (nolock)  where poshrkid=@poshrkid
      order by id
      
      select @newid=SCOPE_IDENTITY()
         
      update istkhrk set istkhrkid=@newid where id=@newid
      
      
      
    END
    
    end
  
END

================================================================================
