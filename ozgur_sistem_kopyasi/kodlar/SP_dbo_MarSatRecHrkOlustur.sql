-- Stored Procedure: dbo.MarSatRecHrkOlustur
-- Tarih: 2026-01-14 20:06:08.346692
================================================================================

CREATE PROCEDURE dbo.MarSatRecHrkOlustur
@MarSatId     int
AS
BEGIN
  
  /*update  */
   update MarSatRecHrk Set sil=dt.sil,
   TransferStartId=TransferStartId+1  
    from MarSatRecHrk as t join 
    ( select h.id,h.sil
    From Marsathrk as h with (nolock) 
    inner join Stok_Recete as r with (nolock) 
    on r.Urun_id=h.stk_id and r.sil=0
    where h.marsatid=@MarSatId and isnull(h.Recete,0)=1
    and h.id in (Select MarSatHrkId From MarSatRecHrk with (nolock) 
    where marsatid=@MarSatId ) ) dt 
    on dt.id=t.MarSatHrkId 



   /*insert Uretim Recete */
   insert into MarSatRecHrk (MarSatId,MarSatHrkId,StokReceteId,
   UretimTipId,UrunId,StokTipId,StokTip,StokId,StokKod,Miktar,
   OlusturmaKullaniciUnvan,OlusturmaTarihSaat)
   Select @MarSatId,h.id,r.id,
   1,r.Urun_id,r.StkTip_id,k.tip,r.Stk_id,k.Kod,r.Miktar*h.mik,
   h.OlusUser,h.OlusTarSaat
   From Marsathrk as h with (nolock) 
   inner join Stok_Recete as r with (nolock) 
   on r.Urun_id=h.stk_id and r.sil=0 and H.sil=0
   inner join Stokkart as k with (nolock) on k.id=r.Stk_id
   where h.marsatid=@MarSatId and isnull(h.Recete,0)=1
   and h.id not in (Select MarSatHrkId From MarSatRecHrk with (nolock) 
   where marsatid=@MarSatId and UretimTipId=1 )

   
   /*insert Uretim Urun */
   insert into MarSatRecHrk (MarSatId,MarSatHrkId,StokReceteId,
   UretimTipId,UrunId,StokTipId,StokTip,StokId,StokKod,Miktar,
   OlusturmaKullaniciUnvan,OlusturmaTarihSaat)
   Select @MarSatId,h.id,0,
   2,h.Stk_id,h.StkTip_id,k.tip,h.Stk_id,k.Kod,h.mik,
   h.OlusUser,h.OlusTarSaat
   From Marsathrk as h with (nolock) 
   inner join Stokkart as k with (nolock) on k.id=h.Stk_id
   where h.marsatid=@MarSatId and isnull(h.Recete,0)=1
   and h.id not in (Select MarSatHrkId From MarSatRecHrk with (nolock) 
   where marsatid=@MarSatId and UretimTipId=2 )
   
   
   
   
   
   /*SELECT id FROM MarSatRecHrk as rh WHERE NOT EXISTS (SELECT id FROM MarSatRecHrk as mrs
   WHERE rh.X = mrs.X  AND rh.Y = mrs.Y )
   */
   
   
   /*delete */
   update MarSatRecHrk set Sil=1,TransferStartId=TransferStartId+1  
   where MarSatId=@MarSatId 
   and MarSatHrkId not in (select h.id from Marsathrk h with (nolock)
   inner join marsatmas as m  with (nolock)
   on m.marsatid=h.marsatid  and isnull(h.Recete,0)=1 and  h.marsatid=@MarSatId)
   
   
   
  declare @MarSatHrkId    int
  declare @MarSatRecId    int
  declare @UrunId   int
  declare @StokId   int
  declare @Miktar    float
  declare @StokIdAlisFiyat float
  
  declare @MarSatHrkRecToplam    float
  declare @MarSatHrkToplam       float
  
   
  declare pom_var CURSOR FAST_FORWARD  FOR 
  select id,h.Stk_id,((h.brmfiy*(1-h.indyuz))*h.kur)*h.mik  as BirimFiyat 
  from Marsathrk as h with (nolock)  where marsatid=@MarSatId and sil=0 
  and isnull(Recete,0)=1
   open pom_var
  fetch next from  pom_var into @MarSatHrkId,@UrunId,@MarSatHrkToplam
  while @@FETCH_STATUS=0
   begin
    set @MarSatHrkRecToplam=0
   
    /*Recete İcinde Urunleri Bul */
    
  declare rec_var CURSOR FAST_FORWARD  FOR 
   Select Id,StokId,Miktar From MarSatRecHrk with (nolock)  
   Where MarSatHrkId=@MarSatHrkId and Sil=0 and UretimTipId=1
   open rec_var
  fetch next from  rec_var into @MarSatRecId,@StokId,@Miktar
  while @@FETCH_STATUS=0
   begin
   
   /*Recete İcindeki Urunun Alis Fiyatini Bul  */
    Select @StokIdAlisFiyat=
    case when alskdvtip='Dahil' then alsfiy 
    else alsfiy*(1+(alskdv/100)) end
    From Stokkart with (NOLOCK) where id=@StokId
       
     update MarSatRecHrk Set BirimMaliyetFiyat=@StokIdAlisFiyat Where Id=@MarSatRecId
   
    set @MarSatHrkRecToplam=@MarSatHrkRecToplam+(@StokIdAlisFiyat*@Miktar)
     
   FETCH next from  rec_var into @MarSatRecId,@StokId,@Miktar
  end
 close rec_var
 deallocate rec_var
          
  /*Satis Fiyatiyla Orantila    */

   
    update MarSatRecHrk Set BirimFiyat=BirimMaliyetFiyat*(@MarSatHrkToplam/
    case when @MarSatHrkRecToplam>0 then @MarSatHrkRecToplam else 1.00 end )
    Where MarSatHrkId=@MarSatHrkId
  


   FETCH next from  pom_var into @MarSatHrkId,@UrunId,@MarSatHrkToplam
  end
 close Pom_Var
 deallocate pom_var
   


   
   
   

END

================================================================================
