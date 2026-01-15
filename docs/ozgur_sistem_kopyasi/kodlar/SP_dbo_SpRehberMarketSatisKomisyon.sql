-- Stored Procedure: dbo.SpRehberMarketSatisKomisyon
-- Tarih: 2026-01-14 20:06:08.379420
================================================================================

CREATE PROCEDURE dbo.SpRehberMarketSatisKomisyon
@MarsatId    int
AS
BEGIN
 

    
    declare @islmtip 	varchar(20)
    declare @islmhrk 	varchar(20)
    declare @islmtipad 	varchar(50)
    declare @islmhrkad 	varchar(50)
    declare @carkod 	varchar(30)
    declare @rehberId    int
    
    declare @KomisyonTutar  float
    declare @SatisTutar  float
    declare @alacak  float
    declare @borc  float
    declare @newid  int
    
    set @KomisyonTutar=0
    set @SatisTutar=0
    set @alacak=0
    set @borc=0
    set @islmtip='SAT'
    set @islmtipad='SATIŞ'
    set @islmhrk='KMS'
    set @islmhrkad='SATIŞ KOMİSYON'
   

    

    set @rehberId=0
    
    select @rehberId=rehberId,@SatisTutar=(m.satistop-m.iadetop) From marsatmas as m with (nolock)  
    where marsatid=@MarsatId and Sil=0
    
    
    if  @rehberId=0
    begin
       update carihrk set sil=1,dataok=0,
       TransferStartId=isnull(TransferStartId,0)+1 
       where marsatid=@MarsatId and islmtip=@islmtip and islmhrk=@islmhrk
       return
    end
    
    
    select @KomisyonTutar=sum( ((brmfiy*(1-indyuz))*h.kur)*(h.RehberKomisyonYuzde/100))
    from marsathrk h with (nolock) inner join marsatmas as m  with (nolock)
    on m.marsatid=h.marsatid  where h.marsatid=@MarsatId and m.Sil=0 and h.sil=0
    
   
    if @SatisTutar<0
     set @borc=@KomisyonTutar   
    else
      set @alacak=@KomisyonTutar
    
    select @carkod=kod from RehberKart with (nolock) 
    where Id=@rehberId
    

   /*insert */
   if not EXISTS (Select id from carihrk where marsatid=@MarsatId 
   and islmtip=@islmtip and islmhrk=@islmhrk)
    begin
      insert into carihrk (firmano,carhrkid,gctip,masterid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip_id,cartip,car_id,carkod,borc,alacak,bakiye,tarih,saat,
      olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,
      adaid,deguser,degtarsaat,sil,
      parabrm,marsatid) 
     
      select top 1 firmano,0,'G',@MarsatId,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,yertip,yerad,
      12,'rehberkart',@rehberId,@carkod,@borc,@alacak,0,tarih,saat,
      olususer,olustarsaat,tarih,@MarsatId,
      cast(@MarsatId as varchar(20))+' NOLU MARKET SATIŞ KOMİSYON',varno,kur,dataok,1,varok,'' as perkod,0 adaid,
      deguser,degtarsaat,sil,
      'TL',@MarsatId  from marsatmas as m with (nolock)  
      where marsatid=@MarsatId and Sil=0
      order by id
      
      select @newid=SCOPE_IDENTITY()
      update carihrk set carhrkid=@newid where id=@newid  
    
    end
    else
     begin
     
       update carihrk set sil=dt.sil,dataok=0,
       cartip_id=12,cartip='rehberkart',
       car_id=@rehberId,carkod=@carkod,
       tarih=dt.tarih,saat=dt.saat,vadetar=dt.tarih,
       borc=@borc,alacak=@alacak,
       deguser=dt.deguser,degtarsaat=dt.degtarsaat,
       TransferStartId=isnull(TransferStartId,0)+1 
       from carihrk as t join 
       ( select marsatid,tarih,saat,sil,deguser,degtarsaat from marsatmas as m with (nolock)  
         where marsatid=@MarsatId) dt on dt.marsatid=t.marsatid
         and t.islmtip=@islmtip and t.islmhrk=@islmhrk
       
     
     
     
     end

END

================================================================================
