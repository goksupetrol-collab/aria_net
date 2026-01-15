-- Stored Procedure: dbo.ResSatRecHrkOlustur
-- Tarih: 2026-01-14 20:06:08.362011
================================================================================

CREATE PROCEDURE dbo.[ResSatRecHrkOlustur]
@ResSatId     int
AS
BEGIN
  
  /*update  */
   update ResSatRecHrk Set sil=dt.sil,
   TransferStartId=TransferStartId+1  
    from ResSatRecHrk as t join 
    ( select h.Id,h.sil
    From ResSathrk as h with (nolock) 
    inner join Stok_Recete as r with (nolock) 
    on r.Urun_id=h.stkId and r.sil=0
    where h.ResSatId=@ResSatId and isnull(h.Recete,0)=1
    and h.Id in (Select ResSatHrkId From ResSatRecHrk with (nolock) 
    where ResSatId=@ResSatId ) ) dt 
    on dt.Id=t.ResSatHrkId 



   /*insert Uretim Recete */
   insert into ResSatRecHrk (ResSatId,ResSatHrkId,StokReceteId,
   UretimTipId,UrunId,StokTipId,StokTip,StokId,StokKod,Miktar,
   OlusturmaKullaniciUnvan,OlusturmaTarihSaat)
   Select @ResSatId,h.Id,r.id,
   1,r.Urun_id,r.StkTip_id,k.tip,r.Stk_id,k.Kod,r.Miktar*h.miktar,
   h.OlusUser,h.OlusTarSaat
   From ResSathrk as h with (nolock) 
   inner join Stok_Recete as r with (nolock) 
   on r.Urun_id=h.StkId and r.sil=0 and H.sil=0
   inner join Stokkart as k with (nolock) on k.id=r.Stk_id
   where h.ResSatId=@ResSatId and isnull(h.Recete,0)=1
   and h.Id not in (Select ResSatHrkId From ResSatRecHrk with (nolock) 
   where ResSatId=@ResSatId and UretimTipId=1 )

   
   /*insert Uretim Urun */
   insert into ResSatRecHrk (ResSatId,ResSatHrkId,StokReceteId,
   UretimTipId,UrunId,StokTipId,StokTip,StokId,StokKod,Miktar,
   OlusturmaKullaniciUnvan,OlusturmaTarihSaat)
   Select @ResSatId,h.Id,0,
   2,h.StkId,h.StkTipId,k.tip,h.StkId,k.Kod,h.miktar,
   h.OlusUser,h.OlusTarSaat
   From ResSathrk as h with (nolock) 
   inner join Stokkart as k with (nolock) on k.id=h.StkId
   where h.ResSatId=@ResSatId and isnull(h.Recete,0)=1
   and h.Id not in (Select ResSatHrkId From ResSatRecHrk with (nolock) 
   where ResSatId=@ResSatId and UretimTipId=2 )
   
   
   
   
   
   /*SELECT id FROM ResSatRecHrk as rh WHERE NOT EXISTS (SELECT id FROM ResSatRecHrk as mrs
   WHERE rh.X = mrs.X  AND rh.Y = mrs.Y )
   */
   
   
   /*delete */
   update ResSatRecHrk set Sil=1,TransferStartId=TransferStartId+1  
   where ResSatId=@ResSatId 
   and ResSatHrkId not in (select h.Id from ResSathrk h with (nolock)
   inner join ResSatMas as m  with (nolock)
   on m.Id=h.ResSatId  and isnull(h.Recete,0)=1 and  h.ResSatId=@ResSatId)
   
   
   
  declare @ResSatHrkId    int
  declare @ResSatRecId    int
  declare @UrunId   int
  declare @StokId   int
  declare @Miktar    float
  declare @StokIdAlisFiyat float
  
  declare @ResSatHrkRecToplam    float
  declare @ResSatHrkToplam       float
  
   
  declare pom_var CURSOR FAST_FORWARD  FOR 
  select Id,h.StkId,((h.BirimFiyat*(1-h.IndYuz))*h.Kur)*h.Miktar  as BirimFiyat 
  from ResSathrk as h with (nolock)  where ResSatId=@ResSatId and sil=0 
  and isnull(Recete,0)=1
   open pom_var
  fetch next from  pom_var into @ResSatHrkId,@UrunId,@ResSatHrkToplam
  while @@FETCH_STATUS=0
   begin
    set @ResSatHrkRecToplam=0
   
    /*Recete İcinde Urunleri Bul */
    
  declare rec_var CURSOR FAST_FORWARD  FOR 
   Select Id,StokId,Miktar From ResSatRecHrk with (nolock)  
   Where ResSatHrkId=@ResSatHrkId and Sil=0 and UretimTipId=1
   open rec_var
  fetch next from  rec_var into @ResSatRecId,@StokId,@Miktar
  while @@FETCH_STATUS=0
   begin
   
   /*Recete İcindeki Urunun Alis Fiyatini Bul  */
    Select @StokIdAlisFiyat=
    case when alskdvtip='Dahil' then alsfiy 
    else alsfiy*(1+(alskdv/100)) end
    From Stokkart with (NOLOCK) where id=@StokId
       
     update ResSatRecHrk Set BirimMaliyetFiyat=@StokIdAlisFiyat Where Id=@ResSatRecId
   
    set @ResSatHrkRecToplam=@ResSatHrkRecToplam+(@StokIdAlisFiyat*@Miktar)
     
   FETCH next from  rec_var into @ResSatRecId,@StokId,@Miktar
  end
 close rec_var
 deallocate rec_var
          
  /*Satis Fiyatiyla Orantila    */

   
    update ResSatRecHrk Set BirimFiyat=BirimMaliyetFiyat*(@ResSatHrkToplam/
    case when @ResSatHrkRecToplam>0 then @ResSatHrkRecToplam else 1.00 end )
    Where ResSatHrkId=@ResSatHrkId
  


   FETCH next from  pom_var into @ResSatHrkId,@UrunId,@ResSatHrkToplam
  end
 close Pom_Var
 deallocate pom_var
   


   
   
   

END

================================================================================
