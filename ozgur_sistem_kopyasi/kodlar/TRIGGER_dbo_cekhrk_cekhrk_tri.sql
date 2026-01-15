-- Trigger: dbo.cekhrk_tri
-- Tablo: dbo.cekhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.932487
================================================================================

CREATE TRIGGER [dbo].[cekhrk_tri] ON [dbo].[cekhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @cekid float
declare @drm varchar(10),
@drmad varchar(20)
declare @cartip varchar(20),@carkod varchar(20)
declare @vcartip varchar(20),@vcarkod varchar(20)
declare @tar datetime,@saat varchar(8)
DECLARE @tutar float
DECLARE @giren float
DECLARE @cikan float
DECLARE @gidkod varchar (20)
DECLARE @gidtutar float
DECLARE @tahcartip varchar (20)
DECLARE @tahcarkod varchar (20)
declare @belno  varchar (20)

/*--------------------------------- */
declare @odemetarih datetime
declare @cirotarih datetime
declare @takastarih datetime
declare @takastahsiltarih datetime
declare @eldentahsiltarih datetime
declare @gerialtarih datetime
declare @iadetarih datetime
declare @sil int
declare @sonuc int
declare @id float
declare @ceksondrm varchar(10)
declare @parabrm varchar(20)
/*-------------------------------------- */


select @id=id,@cekid=cekid,@drm=drm,@drmad=drmad,@cartip=cartip,@carkod=carkod,
@tar=tarih,@saat=saat,@tutar=tutar,@gidkod=gidkod,@gidtutar=gidtutar,
@tahcartip=tahcartip,@tahcarkod=tahcarkod,@belno=belno,
@parabrm=parabrm from inserted;



exec numara_no_yaz 'makbuz',@belno


/*KARSILIKSIZLAR */
/*if (@drm='PID') */
 /* delete from carihrk where cartip not in ('gelgidkart') and  masterid=@cekid and karsihestip='cekkart' */

/*
if (@drm='PKR') 
 delete from carihrk where cartip not in ('gelgidkart') and  masterid=@cekid and karsihestip='cekkart'   

 if @drm='CKR'
  delete from carihrk where cartip not in ('gelgidkart') and masterid=@cekid and karsihestip='cekkart'

 if @drm='TKR'
   delete from bankahrk where masterid=@cekid and karsihestip='cekkart'
*/

/*GERİ ALMA İŞLEMİ */
 /* if @drm='CGR' -- CİRODAN GERİ ALINDI PORTFOYE */
  /*  delete from carihrk where masterid=@cekid */
  /*   and islmtip='CEK' AND islmhrk='CIR' and karsihestip='cekkart' */

/*
if @drm='TGR' -- TAKASATAN GERİ ALINDI
*/

    /*cek odeme iptalinde */
    if @drm='OTI'
    begin
      delete from bankahrk where  masterid=@cekid and karsihestip='cekkart'
      delete from kasahrk  where  masterid=@cekid and karsihestip='cekkart'
    /*delete from carihrk where cartip in ('gelgidkart') and  masterid=@cekid and karsihestip='cekkart' */
    end
    /*cek odeme iptalinde */

   select @ceksondrm=drm,
       @cirotarih=cirotar,
       @takastarih=takvertar,
       @takastahsiltarih=taktahtar,
       @eldentahsiltarih=eltahtar,
       @gerialtarih=geraltar,
       @iadetarih=iadetar,
       @sonuc=sonuc
       from cekkart where cekid=@cekid;
       

/*karsılıksız iptal */
      
       
       
   set @sil=0

    if (@drm='POR')
    begin
      set @giren=@tutar
      set @cikan=0
      set @sonuc=0
    end;

    if (@drm='CIR')
    begin
      set @cirotarih=@tar
      set @giren=@tutar
      set @cikan=@tutar
      /*set @sonuc=0 */
    end

    if (@drm='TAK')
    begin
      set @giren=@tutar
      set @cikan=0
      set @takastarih=@tar
      set @sonuc=0
    end

    if (@drm='TKT')
    begin
      set @giren=@tutar
      set @cikan=0
      set @takastahsiltarih=@tar
      set @sonuc=1
    end

    if (@drm='ELT')
    begin
      set @giren=@tutar
      set @cikan=0
      set @eldentahsiltarih=@tar
      set @sonuc=1
    end

    if (@drm='ODE')
    begin
      set @giren=0
      set @cikan=@tutar
      set @odemetarih=@tar
      set @sonuc=1
    end


/*-ödenen çekin geri alma işlemi */
    if (@drm='OTI')
    begin
      if (@ceksondrm='TKT') 
      begin/*takastan tahsil */
      /*bankadan tahilat silinecek */
      set @drm='TAK'
      set @giren=@tutar
      set @cikan=0
      set @odemetarih=null
      set @sonuc=0
    end

    if (@ceksondrm='ELT')/*ELDEN tahsil */
    begin
      /*kasa tahilat silinecek */
      set @drm='POR'
      SET @cartip=''
      SET @carkod=''
      set @giren=@tutar
      set @cikan=0
      set @eldentahsiltarih=null
      set @sonuc=0
    end

    if (@ceksondrm='ODE')/*KESİLEN CEK ÖDEMESİ BANKADAN */
    begin
      /*bankadan ODEME silinecek */
      set @drm='KSN'
      set @giren=@tutar
      set @cikan=0
      set @odemetarih=null
      set @sonuc=0
    end

   select @drmad=ad from cektip where kod=@drm
 end


  if (@drm='PID')
  begin
    set @sil=0
    set @giren=@tutar
    set @cikan=@tutar
    set @iadetarih=@tar
    set @sonuc=0
  end
  
  
  if (@drm='IGR')
  begin
    set @giren=@tutar
    set @cikan=0
    SET @drm='POR'
    select @drmad=ad from cektip where kod=@drm
    
     delete from carihrk where masterid=@cekid
     and (islmtip='CEK' OR islmtip='SEN') AND islmhrk='PID' and karsihestip='cekkart'  
    
    set @sonuc=0
    set @gerialtarih=@tar
  end
  
  


  if (@drm='TGR')
  begin
    set @giren=@tutar
    set @cikan=0
    SET @cartip=''
    SET @carkod=''
    SET @drm='POR'
    select @drmad=ad from cektip where kod=@drm
    set @sonuc=0
    set @gerialtarih=@tar
  end

  if (@drm='CGR')
  begin
    set @giren=@tutar
    set @cikan=0
    SET @cartip=''
    SET @carkod=''
    SET @drm='POR'
    select @drmad=ad from cektip where kod=@drm
    set @gerialtarih=@tar
    set @sonuc=0
  end

  if (@drm='KGR') /*KARISIKSIZDAN GERI ALIMI */
  begin
    if @ceksondrm='PKR'
    begin
      set @drm='POR'
      SET @cartip='';
      SET @carkod='';
      set @giren=@tutar
      set @cikan=0
      /*karsilıksız yansıma iptal */
     delete from carihrk where masterid=@cekid
     and (islmtip='CEK' OR islmtip='SEN') AND islmhrk='PKR' and karsihestip='cekkart'      
      
    end
    if @ceksondrm='TKR'
    begin
      set @drm='TAK'
      set @giren=@tutar
      set @cikan=0
       /*karsilıksız yansıma iptal */
      delete from carihrk where masterid=@cekid
     and (islmtip='CEK' OR islmtip='SEN') AND islmhrk='TKR' and karsihestip='cekkart'
      
    end

    if @ceksondrm='CKR'
    begin
      set @drm='CIR'
      set @giren=@tutar
      set @cikan=@tutar
     delete from carihrk where masterid=@cekid
     and (islmtip='CEK' OR islmtip='SEN') AND islmhrk='CKR' and karsihestip='cekkart'  
      
      
    end
  set @odemetarih=null
  set @sonuc=0

  select @drmad=ad from cektip where kod=@drm;
 end


    if (@drm='CIR') OR (@drm='TAK')
    update cekkart set giren=@giren,cikan=@cikan,drm=@drm,drmad=@drmad,
    vercartip=@cartip,vercarkod=@carkod,sonuc=@sonuc,
    cirotar=@cirotarih,takvertar=@takastarih,
    taktahtar=@takastahsiltarih,eltahtar=@eldentahsiltarih,
    geraltar=@gerialtarih,iadetar=@iadetarih,
    hrkid=@id,tahcartip=@tahcartip,tahcarkod=@tahcarkod,
    gidkod=@gidkod,gidtutar=@gidtutar
    where cekid=@cekid

    if (@drm='POR') /*cartip=@cartip,carkod=@carkod, */
    update cekkart set 
    giren=@giren,cikan=@cikan,drm=@drm,drmad=@drmad,
    vercarkod='',vercartip='',
    sonuc=@sonuc,
    cirotar=@cirotarih,takvertar=@takastarih,
    taktahtar=@takastahsiltarih,eltahtar=@eldentahsiltarih,
    geraltar=@gerialtarih,iadetar=@iadetarih,
    hrkid=@id,tahcartip=@tahcartip,tahcarkod=@tahcarkod,
    gidkod=@gidkod,gidtutar=@gidtutar
    where cekid=@cekid

    if (@drm='PID')
    update cekkart set drm=@drm,drmad=@drmad,
    cikan=@cikan,iadetar=@iadetarih,hrkid=@id
    where cekid=@cekid


    if not ((@drm='CIR') OR (@drm='TAK') or (@drm='POR') or (@drm='PID') )
    update cekkart set drm=@drm,drmad=@drmad,sil=@sil,
    cirotar=@cirotarih,takvertar=@takastarih,sonuc=@sonuc,
    taktahtar=@takastahsiltarih,eltahtar=@eldentahsiltarih,
    geraltar=@gerialtarih,iadetar=@iadetarih,
    odetar=@odemetarih,hrkid=@id,
    tahcartip=@tahcartip,tahcarkod=@tahcarkod,
    gidkod=@gidkod,gidtutar=@gidtutar where cekid=@cekid



    EXEC cekhrkgiris @cekid


END

================================================================================
