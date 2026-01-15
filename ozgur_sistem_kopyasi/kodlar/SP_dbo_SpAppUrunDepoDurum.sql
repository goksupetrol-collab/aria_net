-- Stored Procedure: dbo.SpAppUrunDepoDurum
-- Tarih: 2026-01-14 20:06:08.370636
================================================================================

CREATE PROCEDURE dbo.SpAppUrunDepoDurum
@Firmano    int,
@BarkodNo   varchar(30)
AS
BEGIN
   

   
   
   
   Declare @Id     int 
   Declare @StokTip   varchar(10)
   Declare @StokKod   varchar(50)

   
   
   select @StokTip=tip,@StokKod=kod from barkod as b with (nolock)
   where b.barkod=@BarkodNo and b.sil=0 and isnull(b.barkod,'')!=''

   
   /*ürün adı, depolara göre miktar, alış-satış fiyatı-kdv, kar yüzdesi */
   
   select id,kod,ad,
   round(case when alsfiy>0 then  ((sat1fiy*100)/alsfiy)-100 else 0 end,2) karyuzde,
   k.alsfiy as alisfiyat,
   k.alskdv as aliskdv,
   k.sat1fiy as satisfiyat,
   k.sat1kdv satiskdv
   from stokkart as k with (nolock) where tip=@StokTip and kod=@StokKod and sil=0 
   
   
   
   select d.id,d.kod,d.ad,
   sum(giren) As giren,
   sum(cikan) As cikan,
   sum(giren-cikan) as kalan
   from stokkart as k with (nolock)
   left join stkhrk as h with (nolock) on 
   k.tip=h.stktip and k.kod=h.stkod
   and h.sil=0 and k.sil=0
   left join Depo_Kart_Listesi as d on d.kod=h.depkod
   where k.tip=@StokTip and k.kod=@StokKod 
   group by k.tip,k.kod,k.ad,d.id,d.kod,d.ad
   having abs(isnull(sum(giren-cikan),0))>0
     


    

  
END

================================================================================
