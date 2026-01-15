-- Stored Procedure: dbo.Yeni_Fiyat_Fark
-- Tarih: 2026-01-14 20:06:08.391011
================================================================================

CREATE PROCEDURE [dbo].Yeni_Fiyat_Fark
(@masid integer,
@sil  tinyint)
AS
BEGIN


  declare @newid int
  DECLARE @gidkod varchar(30)

  declare @kur      float
  declare @parabrm  varchar(20)
  
  declare @islmtip varchar(30)
  declare @islmtipad varchar(50)
  declare @islmhrk varchar(30)
  declare @islmhrkad varchar(50)

     set @islmtip='GLG'
     select @islmtipad=ad from islemturtip where tip=@islmtip
     set @islmhrk='FYF'
     select @islmhrkad=ad from islemhrktip where
     tip=@islmtip and hrk=@islmhrk

     select @parabrm=sistem_parabrm,@kur=sistem_kasakur,
     @gidkod=fisyenfiygelgid from sistemtanim

   delete from carihrk where masterid=@masid and islmtip=@islmtip
   and islmhrk=@islmhrk

  if @sil=0
   begin
      select @newid=0
      insert into carihrk (firmano,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,
      yertip,yerad,cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
      karsihestip,karsiheskod,parabrm)
      select max(m.firmano),@newid,'-',@masid,'KENDI',0,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,max(vf.yertip),max(vf.yerad),
      'gelgidkart',@gidkod,SUM( case when yeni_fiyat-eski_fiyat<0 then
      vh.mik*abs(yeni_fiyat-eski_fiyat) else 0 end),
      SUM( case when yeni_fiyat-eski_fiyat>0 then
      vh.mik*abs(yeni_fiyat-eski_fiyat) else 0 end),0,max(vf.tarih),max(vf.saat),
      max(vf.olususer),max(vf.olustarsaat),max(vf.tarih),cast(@masid as varchar),
      max(vf.ack),0,@kur,0,1,1,'',0,'','',0,
      '','',@parabrm from veresiyenfiyhrk as vf with (nolock) inner join
      veresihrk as vh with (nolock)  on vh.id=vf.verhrkid and vh.sil=0
      inner join veresimas as m on m.verid=vh.verid and m.sil=0
      where vf.masterid=@masid
      
      select @newid=SCOPE_IDENTITY()
       update carihrk set carhrkid=@newid 
       where masterid=@masid and islmtip=@islmtip and islmhrk=@islmhrk
       
      
      
      
      
   end

  
  
END

================================================================================
