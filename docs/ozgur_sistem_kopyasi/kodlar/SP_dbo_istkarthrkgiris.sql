-- Stored Procedure: dbo.istkarthrkgiris
-- Tarih: 2026-01-14 20:06:08.339496
================================================================================

CREATE PROCEDURE [dbo].istkarthrkgiris @hrkid float,@sil int
AS
BEGIN

declare @varno float
declare @baktop float
declare @newid float
declare @gctip varchar(1)
declare @borc float
declare @alacak float
declare @poskod varchar(20)
declare @masid  float
  
declare @islmtip varchar(20)
declare @islmhrk varchar(20)
declare @cartip varchar(20)
declare @istkhrkid float
declare @Yan_Sil   bit

declare @devir 	    bit

select @masid=masterid,@gctip=gctip,@istkhrkid=istkhrkid,
@islmtip=islmtip,@islmhrk=islmhrk,
@borc=borc,@alacak=alacak,@varno=varno,@cartip=cartip,
@devir=devir
from istkhrk where istkhrkid=@hrkid

 if @hrkid=0
  RETURN

 if @devir=1
  return

if @sil=1
 begin
/*-karsı hesap siliniyor */
  if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
    delete from carihrk where masterid=@istkhrkid and karsihestip='istkart'

  if (@cartip='kasakart') 
   delete from kasahrk where kashrkid=@masid

 RETURN
end


 
if @cartip<>''
begin


if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
begin
  delete from carihrk where masterid=@istkhrkid and karsihestip='istkart'

  select @newid=0
  insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod) 
  select firmano,@newid,@gctip,@istkhrkid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,@alacak,@borc,0,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,
  'istkart',istkkod,parabrm,
  'istkart',istkkod
  from istkhrk with (nolock)  where istkhrkid=@hrkid
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid
  
  
  
END
end


  
  
END

================================================================================
