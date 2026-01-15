-- Stored Procedure: dbo.Fiyat_Fark_Yansıma
-- Tarih: 2026-01-14 20:06:08.330959
================================================================================

CREATE  PROCEDURE [dbo].Fiyat_Fark_Yansıma
(@tip varchar(30),
@masid integer,
@sil  tinyint)
AS
BEGIN


  declare @newid int
  DECLARE @gidkod varchar(30)
  DECLARE @tutar float
  
  declare @kur      float
  declare @parabrm  varchar(20)
  
  declare @islmtip varchar(30)
  declare @islmtipad varchar(50)
  declare @islmhrk varchar(30)
  declare @islmhrkad varchar(50)
  declare @ack       varchar(50)


  declare @yertip varchar(30)
  declare @yerad varchar(50)
  
  if @tip='YFF'
    begin
    
     set @islmtip='GLG'
     select @islmtipad=ad from islemturtip where tip=@islmtip
     set @islmhrk='YFK'
     select @islmhrkad=ad from islemhrktip where
     tip=@islmtip and hrk=@islmhrk

     set @yertip='yenifiyfark'
     select @yerad=ad from yertipad where kod=@yertip

     select @parabrm=sistem_parabrm,@kur=sistem_kasakur,
     @gidkod=vadfarkgelgid from sistemtanim
     
     set @ack='FİŞLERE YENİ FİYAT UYGULA'
   end
   
    if @tip='VDF'
    begin
     set @islmtip='VAD'
     select @islmtipad=ad from islemturtip where tip=@islmtip
     set @islmhrk='VDF'
     select @islmhrkad=ad from islemhrktip where
     tip=@islmtip and hrk=@islmhrk

     set @yertip='vadefiyfark'
     select @yerad=ad from yertipad where kod=@yertip

     select @parabrm=sistem_parabrm,@kur=sistem_kasakur,
     @gidkod=vadfarkgelgid from sistemtanim

     set @ack='FİŞLERE VADE FARKI UYGULA'
   end

  delete from carihrk where masterid=@masid and islmtip=@islmtip
  and islmhrk=@islmhrk

  select @newid=0
  insert into carihrk (carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,
  yertip,yerad,cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm)
  select @newid,'A',@masid,'KENDI',0,
  @islmtip,@islmtipad,@islmhrk,@islmhrkad,@yertip,@yerad,
  'gelgidkart',@gidkod,0,@tutar,0,max(tarih),max(saat),max(olususer),
  max(olustarsaat),max(tarih),cast(@masid as varchar),
  @ack,0,@kur,0,1,1,'',0,'','',1,
  '','',@parabrm from veresifarkhrk with (nolock) where masterid=@masid
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid
  
  
END

================================================================================
