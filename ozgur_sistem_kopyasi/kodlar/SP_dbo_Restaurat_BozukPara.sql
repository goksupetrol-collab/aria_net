-- Stored Procedure: dbo.Restaurat_BozukPara
-- Tarih: 2026-01-14 20:06:08.362382
================================================================================

CREATE PROCEDURE [dbo].[Restaurat_BozukPara]
(
@firmano  	int,
@varno 		int,
@sil 		int)
AS
BEGIN


declare @islmtip  	varchar(50)
declare @islmtipad  varchar(50)
declare @islmhrk  	varchar(50)
declare @islmhrkad  varchar(50)
declare @gctip  	varchar(50)
declare @newid  	int


declare @yertip  	varchar(50)
declare @yertipkad  varchar(50)


    set @islmtip='VAR'
    set @islmhrk='BPC'
    set @gctip='C'
    set @yertip='resvardimas'
    
    
     update kasahrk set sil=1  where 
     marbozukpara_id=@varno 
 
 
  
    
   if @sil=0
    begin 
    
    select @islmtipad=ad from islemturtip where tip=@islmtip 
    
    
    select @islmhrkad=ad from islemhrktip where tip=@islmtip and 
    hrk=@islmhrk
    
    
    select @yertipkad=ad from yertipad where kod=@yertip

    select @newid=0
    insert into kasahrk (firmano,kaskod,kashrkid,gctip,varno,
    masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,
    yerad,perkod,adaid,giren,cikan,bakiye,cartip,carkod,tarih,saat,
    belno,ack,kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,dataok,parabrm,
    karsihestip,karsiheskod,marbozukpara_id)
    select firmano,KasaKod,@newid,@gctip,0,0,
    @islmtip,@islmtipad,
    @islmhrk,@islmhrkad,@yertip,
    @yertipkad,'Diger',0,0,bozukpara,0,'vardikasa','VRDKASA',
    tarih,saat,cast(varno as varchar(50)),varad,
    kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,
    1,ParaBirim,'','',varno 
    from resvardimas where firmano=@firmano and varno=@varno
    and sil=0 and KasaKod<>'' and bozukpara>0
 
     select @newid=SCOPE_IDENTITY()
     update kasahrk set kashrkid=@newid where id=@newid
     
   end

END

================================================================================
