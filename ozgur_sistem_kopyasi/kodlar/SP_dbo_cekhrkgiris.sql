-- Stored Procedure: dbo.cekhrkgiris
-- Tarih: 2026-01-14 20:06:08.320593
================================================================================

CREATE  PROCEDURE [dbo].cekhrkgiris @hrkid float
AS
BEGIN

declare @varno float
declare @baktop float
declare @newid float
declare @gctip varchar(1)
declare @giren float,@cikan float
declare @cekdrm varchar(20)
declare @CEKBAK float
  
declare @islmtip varchar(20),@islmhrk varchar(20),
@cartip varchar(20)
declare @cekhrkid float
declare @bankahrkid float
declare @kasahrkid float
declare @drmhrkid float
/*-masraf */
declare @gidtipkod varchar(20)
declare @gidtiphrkkod varchar(20)
declare @gidtipad varchar(30)
declare @gidtiphekad varchar(30)
/*-masraf */

declare @carkod varchar(50)
declare @tahcartip varchar(20),@tahcarkod varchar(20)
declare @gidkod varchar(20),@gidtutar float


declare @vercarkod varchar(50)


declare @hrkdrm varchar(20)


 if @hrkid=0
  RETURN


  select @drmhrkid=hrkid,@cekdrm=drm,@gctip=gctip,
  @cekhrkid=cekid,@islmtip=islmtip,@islmhrk=islmhrk,
  @giren=giren,@cikan=cikan,@varno=varno,
  @cartip=case when gctip='C' then vercartip else cartip end,
  @carkod=case when gctip='C' then vercarkod else carkod end,
  @vercarkod=vercarkod,
  @tahcartip=tahcartip,@tahcarkod=tahcarkod,@gidkod=gidkod,
  @gidtutar=gidtutar from cekkart with (nolock)
  where cekid=@hrkid


  update cekhrk set aktif=0 where cekid=@hrkid 

  select @hrkdrm=drm from cekhrk where id =@drmhrkid
   

   update cekhrk set aktif=1 where cekid=@hrkid and id >=
   (select top 1 id from cekhrk with (nolock) where cekid=@hrkid and drm in              
   ('KSN','POR') order by id desc ) 


 if (@hrkdrm='CGR')
  begin
      select @newid=0
      insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,
      Karsi_Karttip,Karsi_KartKod)
      select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,
      m.islmtip,m.islmtipad,h.drm,h.drmad,h.yertip,h.yerad,
      h.cartip,h.carkod,0,giren*m.kur,0,h.tarih,h.saat,h.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
      h.ack,0,/*m.varno, */
      m.kur,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
      'cekkart',m.refno,m.parabrm,
      'cekkart',m.refno
       from cekkart as m  with (nolock) inner join cekhrk as h with (nolock)
      on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
      
      select @newid=SCOPE_IDENTITY()
      update carihrk set carhrkid=@newid where id=@newid
  
  
  
  end


 if (@cekdrm='PKR') OR (@cekdrm='TKR') OR (@cekdrm='CKR')
  begin
   if (@cekdrm='PKR') OR (@cekdrm='TKR')
     begin

      /*- cek alinan cari ters hareket   */
      select @newid=0
      insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,Karsi_Karttip,Karsi_KartKod)
      select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,
      m.islmtip,m.islmtipad,h.drm,h.drmad,h.yertip,h.yerad,
      m.cartip,m.carkod,giren*m.kur,0,0,h.tarih,h.saat,
      h.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
      h.ack,0,/*m.varno, */
      m.kur,1,m.varok,m.perkod,m.adaid,
      h.olususer,h.olustarsaat,m.sil,
      'cekkart',m.refno,m.parabrm,
      'cekkart',m.refno
       from cekkart as m with (nolock)  inner join cekhrk as h with (nolock)
       on h.id=m.hrkid where 
       m.cekid=@hrkid and h.id=@drmhrkid
       
       
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
       
    end

  if (@cekdrm='CKR')
   begin
     /*- cek alinan cari ters hareket  */
      
      select @newid=0
      insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,Karsi_Karttip,Karsi_KartKod)
      select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,
      m.islmtip,m.islmtipad,h.drm,h.drmad,h.yertip,h.yerad,
      m.cartip,m.carkod,giren*m.kur,0,0,h.tarih,h.saat,h.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
      h.ack,0,/*m.varno, */
      m.kur,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
      'cekkart',m.refno,m.parabrm,'cekkart',m.refno 
      from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
      on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
      
       select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid where id=@newid
      
      /* cirolanan cari ters hareket */
      insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm,
      Karsi_Karttip,Karsi_KartKod)
      select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,
      m.islmtip,m.islmtipad,h.drm,h.drmad,h.yertip,h.yerad,
      h.cartip,h.carkod,0,giren*m.kur,0,h.tarih,h.saat,h.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
      h.ack,0,/*m.varno, */
      m.kur,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
      'cekkart',m.refno,m.parabrm,
      'cekkart',m.refno
       from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
      on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
      
      
      
     
    end
 
    RETURN
  end



 /*-carikart yansıması */
 if (@cekdrm='POR') OR (@cekdrm='CIR') OR (@cekdrm='KSN')  OR (@cekdrm='PID')
 begin
  if (@cartip='carikart') or (@cartip='perkart')
   or (@cartip='gelgidkart') or (@cartip='vardicek')
  begin
 /*-cari giris por */
  if (@cekdrm='POR') OR (@cekdrm='CIR')
  begin
  
  if @cekdrm='POR'
  begin
  /*-por işlemi */
  delete from carihrk where 
  /*cartip not in ('gelgidkart') and  */
  masterid=@cekhrkid
  and (islmtip='CEK' OR islmtip='SEN') and islmhrk='ALN' 
  and karsihestip='cekkart'

  select @newid=0
  insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,
  islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,Karsi_Karttip,Karsi_KartKod)
  select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,
  m.fisfattip,m.fisfatid,m.islmtip,m.islmtipad,m.islmhrk,m.islmhrkad,
  h.yertip,h.yerad,
  m.cartip,m.carkod,0,giren*m.kur,0,m.tarih,m.saat,h.olususer,
  h.olustarsaat,m.vadetar,m.ceksenno,
  h.ack,m.varno,m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,
  h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
  
   select @newid=SCOPE_IDENTITY()
   update carihrk set carhrkid=@newid where id=@newid
  
  end

 /*---CİRO */
  if @cekdrm='CIR'
  begin
    delete from carihrk where 
    /*cartip not in ('gelgidkart') and  */
    masterid=@cekhrkid and carkod=@vercarkod
    and (islmtip='CEK' OR islmtip='SEN') and 
     islmhrk='CIR' and karsihestip='cekkart'
   
   /* ayni cariden ve aynı cekid cirodan geri al islemini sil  */
    delete from carihrk where masterid=@cekhrkid and carkod=@vercarkod
    and (islmtip='CEK' OR islmtip='SEN') and 
     islmhrk='CGR' and karsihestip='cekkart' 
     
     

    select @newid=0
    insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,
    fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
    ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
    karsihestip,karsiheskod,parabrm,
    Karsi_Karttip,Karsi_KartKod) 
    select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,
    m.fisfatid,m.islmtip,m.islmtipad,m.drm,m.drmad,h.yertip,h.yerad,
    m.vercartip,m.vercarkod,
    cikan*m.kur,0,0,h.tarih,h.saat,h.olususer,h.olustarsaat,
    m.vadetar,m.ceksenno,
    h.ack,0,/*m.varno, */
    m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
    'cekkart',m.refno,m.parabrm,
    'cekkart',m.refno from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
    on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
    
    
     select @newid=SCOPE_IDENTITY()
     update carihrk set carhrkid=@newid where id=@newid
    
    end

  end;/*-PRO VE CIRO İŞLEMİ */
  
  if (@cekdrm='PID')/*portfoyden iade */
  begin
  select @newid=0
  insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod) 
  select m.firmano,m.cekid,@newid,'B',@cekhrkid,m.fisfattip,
  m.fisfatid,m.islmtip,m.islmtipad,m.drm,m.drmad,h.yertip,h.yerad,
  m.cartip,m.carkod,
  cikan*m.kur,0,0,h.tarih,h.saat,h.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
  
    select @newid=SCOPE_IDENTITY()
    update carihrk set carhrkid=@newid where id=@newid
  
  end
  
  
  

 /*-ksn */
  if (@cekdrm='KSN')
  begin
  delete from carihrk where masterid=@cekhrkid
  and (islmtip='CEK' OR islmtip='SEN') and islmhrk='KSN' 
  and karsihestip='cekkart'
  
  select @newid=0
  insert into carihrk (firmano,cekid,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod) 
  select m.firmano,m.cekid,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,m.islmtip,m.islmtipad,m.islmhrk,m.islmhrkad,h.yertip,h.yerad,
  m.vercartip,m.vercarkod,
  cikan*m.kur,0,0,h.tarih,m.saat,m.olususer,h.olustarsaat,m.vadetar,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m  with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
   select @newid=SCOPE_IDENTITY()
   update carihrk set carhrkid=@newid where id=@newid
  
 end
 END
end
 
/*-carikart yansıması */

/*banka gelir gider kasa yansıması silimi */
delete from bankahrk where masterid=@cekhrkid and karsihestip='cekkart'
delete from kasahrk where masterid=@cekhrkid  and karsihestip='cekkart'
/*banka gelir gider kasa yansıması silimi */

/*banka gelir gider kasa yansıması */
if (@cekdrm='TKT') OR (@cekdrm='ELT') OR (@cekdrm='ODE')
begin

if (@tahcartip='bankakart') 
begin
if (@cekdrm='TKT') /*banka takastan tahsil işlemi */
set @cikan=0

if (@cekdrm='ODE') /*banka çek ödeme işlemi */
set @giren=0
  select @newid=0
  insert into bankahrk (firmano,cekid,bankod,bankhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,vadetar,tarih,saat,olususer,olustarsaat,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod)
  select m.firmano,m.cekid,h.carkod,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,m.islmtip,m.islmtipad,m.drm,m.drmad,
  h.yertip,h.yerad,'','',@giren,@cikan,m.vadetar,h.tarih,h.saat,h.olususer,h.olustarsaat,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
   select @newid=SCOPE_IDENTITY()
   update bankahrk set bankhrkid=@newid where id=@newid
  
  

if @gidtutar>0
begin

set @gidtipkod='GLG'
set @gidtiphrkkod='MRF'
SELECT @gidtipad=ad from islemturtip where tip=@gidtipkod;
SELECT @gidtiphekad=ad from islemhrktip where tip=@gidtipkod and hrk=@gidtiphrkkod;

/*--BANKA MASRAF GİRİŞİ */
  select @newid=0
  insert into bankahrk (firmano,cekid,bankod,bankhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,vadetar,tarih,saat,olususer,olustarsaat,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod)
  select m.firmano,m.cekid,h.tahcarkod,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,@gidtipkod,@gidtipad,@gidtiphrkkod,@gidtiphekad,h.yertip,h.yerad,
  'gelgidkart',@gidkod,0,@gidtutar,m.vadetar,h.tarih,h.saat,h.olususer,h.olustarsaat,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'gelgidkart',@gidkod from cekkart as m  with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
  select @newid=SCOPE_IDENTITY()
  update bankahrk set bankhrkid=@newid where id=@newid

end
END
 

if (@tahcartip='kasakart')
begin

if (@cekdrm='ELT') /*KASA ELDEN tahsil işlemi */
set @cikan=0

  select @newid=0
  insert into kasahrk (firmano,cekid,kaskod,kashrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,giren,cikan,tarih,saat,olususer,olustarsaat,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod)
  select m.firmano,m.cekid,h.tahcarkod,@newid,@gctip,@cekhrkid,m.fisfattip,m.fisfatid,m.islmtip,m.islmtipad,m.drm,m.drmad,
  h.yertip,h.yerad,'','',
  @giren,@cikan,h.tarih,h.saat,h.olususer,h.olustarsaat,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m with (nolock) inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
  select @newid=SCOPE_IDENTITY()
  update kasahrk set kashrkid=@newid where id=@newid
  
  
  
delete from carihrk where masterid=@cekhrkid and islmtip='GLG' and islmhrk='MRF'
   and karsihestip='cekkart'
if @gidtutar>0
begin

set @gidtipkod='GLG'
set @gidtiphrkkod='MRF'
SELECT @gidtipad=ad from islemturtip where tip=@gidtipkod;
SELECT @gidtiphekad=ad from islemhrktip where tip=@gidtipkod and hrk=@gidtiphrkkod

/*--KASA MASRAF GİRİŞİ */
  select @newid=0
  insert into kasahrk (firmano,cekid,kaskod,kashrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,giren,cikan,tarih,saat,olususer,olustarsaat,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,
  Karsi_Karttip,Karsi_KartKod)
  select m.firmano,m.cekid,h.tahcarkod,@newid,'C',@cekhrkid,m.fisfattip,m.fisfatid,@gidtipkod,@gidtipad,@gidtiphrkkod,@gidtiphekad,
  h.yertip,h.yerad,'gelgidkart',@gidkod,0,@gidtutar,h.tarih,h.saat,h.olususer,h.olustarsaat,m.ceksenno,
  h.ack,0,/*m.varno, */
  m.kur,m.dataok,1,m.varok,m.perkod,m.adaid,h.olususer,h.olustarsaat,m.sil,
  'cekkart',m.refno,m.parabrm,
  'cekkart',m.refno from cekkart as m with (nolock)  inner join cekhrk as h with (nolock)
  on h.id=m.hrkid where m.cekid=@hrkid and h.id=@drmhrkid
  
  select @newid=SCOPE_IDENTITY()
  update kasahrk set kashrkid=@newid where id=@newid

 end

 END
end



  
END

================================================================================
