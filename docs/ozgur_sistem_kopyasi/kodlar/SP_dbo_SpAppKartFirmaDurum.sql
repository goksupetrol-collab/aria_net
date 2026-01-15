-- Stored Procedure: dbo.SpAppKartFirmaDurum
-- Tarih: 2026-01-14 20:06:08.368952
================================================================================

CREATE PROCEDURE dbo.[SpAppKartFirmaDurum]
@Firmano      int,
@KartTipId    int,
@KartKod        varchar(50)
AS
BEGIN
   

   
   
   
   Declare @Id     int 
   Declare @KartTip   varchar(20)
   
   /*
   if (@KartTipId=1) --cari
    select @KartTip='carikart',@KartKod=kod from carikart as b with (nolock)
     where b.kod=@KartKod and b.sil=0 
     
     
   if (@KartTipId=4) --banka
    select @KartTip='bankakart',@KartKod=kod from bankakart as b with (nolock)
     where b.kod=@KartKod and b.sil=0    


   if (@KartTipId=8) --kasa
    select @KartTip='kasakart',@KartKod=kod from kasakart as b with (nolock)
     where b.kod=@KartKod and b.sil=0   
  */

   if (@KartTipId=1) /*cari  */
    begin
     select id,kod,unvan ad,
     brc_bakiye borc,alc_bakiye alacak,top_bakiye bakiye
     from Cari_Kart_Listesi as k with (nolock) where kod=@KartKod and sil=0 
   
     select d.id,d.kod,d.ad,
     sum(borc) As borc,
     sum(alacak) As alacak,
     sum(borc-alacak) as bakiye
     from carikart as k with (nolock)
     left join carihrk as h with (nolock) on 
     h.cartip='carikart' and k.kod=h.carkod
     and h.sil=0 and k.sil=0
     left join Firma as d on d.id=h.firmano
     where k.kod=@KartKod 
     group by k.kod,k.ad,d.id,d.kod,d.ad
     having abs(isnull(sum(borc-alacak),0))>0
     
   end

   
   
   if (@KartTipId=4) /*kasa  */
    begin
     select id,kod,ad,
     giren_bakiye as borc,cikan_bakiye as alacak,top_bakiye as bakiye
     from Kasa_Kart_Listesi as k with (nolock) where kod=@KartKod and sil=0 
   
     select d.id,d.kod,d.ad,
     sum(h.giren) As borc,
     sum(h.cikan) As alacak,
     sum(h.giren-h.cikan) as bakiye
     from kasakart as k with (nolock)
     left join kasahrk as h with (nolock) on 
     k.kod=h.kaskod and h.sil=0 and k.sil=0
     left join Firma as d on d.id=h.firmano
     where k.kod=@KartKod 
     group by k.kod,k.ad,d.id,d.kod,d.ad
     having abs(isnull(sum(h.giren-h.cikan),0))>0
     
   end
   
   
   
   if (@KartTipId=8) /*banka  */
    begin
     select id,kod,ad,
     brc_bakiye borc,alc_bakiye alacak,top_bakiye bakiye
     from Banka_Kart_Listesi as k with (nolock) where kod=@KartKod and sil=0 
   
     select d.id,d.kod,d.ad,
     sum(h.borc) As borc,
     sum(h.alacak) As alacak,
     sum(h.borc-h.alacak) as bakiye
     from bankakart as k with (nolock)
     left join bankahrk as h with (nolock) on 
     k.kod=h.bankod and h.sil=0 and k.sil=0
     left join Firma as d on d.id=h.firmano
     where k.kod=@KartKod 
     group by k.kod,k.ad,d.id,d.kod,d.ad
     having abs(isnull(sum(h.borc-h.alacak),0))>0
     
   end
    

  
END

================================================================================
