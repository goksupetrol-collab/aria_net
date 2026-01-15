-- Function: dbo.UDF_Satis_Odeme_Rap
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.764815
================================================================================

CREATE FUNCTION [dbo].[UDF_Satis_Odeme_Rap] (
@firmano 		int,
@Sat_BasTar		Datetime,
@Sat_BitTar		Datetime,
@Ode_BasTar		Datetime,
@Ode_BitTar		Datetime)
RETURNS
   
   @TABLE_BAKIYE_SATIS TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Cari_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Satis_Top			float,
   Odeme_Top		    float,
   Bakiye				float,
   Limit_Top			Float,
   Limit_Fark			Float)

AS
BEGIN
 


   declare  @TABLE_BAKIYE TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Cari_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Satis_Top			float,
   Odeme_Top		    float,
   Bakiye				float,
   Limit_Top			Float,
   Fark_Top				Float )


 /*satıs borc */
  if @firmano=0
  insert into @TABLE_BAKIYE 
  (Cari_Tip,Cari_Kod,Cari_Unvan,Satis_Top,Odeme_Top,Bakiye)
  select k.tip,k.kod,k.Unvan,Borc,0 Odeme_Top,0 Bakiye 
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  where h.tarih>=@Sat_BasTar
  and h.tarih<=@Sat_BitTar
  and Borc>0 
  
  
  if @firmano>0
  insert into @TABLE_BAKIYE
  (Cari_Tip,Cari_Kod,Cari_Unvan,Satis_Top,Odeme_Top,Bakiye)
  select k.tip,k.kod,k.Unvan,Borc,0 Odeme_Top,0 Bakiye 
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  and h.firmano in (0,@firmano)
  where h.tarih>=@Sat_BasTar
  and h.tarih<=@Sat_BitTar
  and Borc>0 
  
  
  
  
  /*odeme toplam */
  if @firmano=0
  insert into @TABLE_BAKIYE
  (Cari_Tip,Cari_Kod,Cari_Unvan,Satis_Top,Odeme_Top,Bakiye)
  select k.tip,k.kod,k.Unvan,0,Alacak,0 Bakiye
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  where h.tarih>=@Ode_BasTar
  and h.tarih<=@Ode_BitTar
  and alacak>0 

  if @firmano>0
  insert into @TABLE_BAKIYE
  (Cari_Tip,Cari_Kod,Cari_Unvan,Satis_Top,Odeme_Top,Bakiye)
  select k.tip,k.kod,k.Unvan,0,Alacak,0 Bakiye 
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  and h.firmano in (0,@firmano)
  where h.tarih>=@Ode_BasTar
  and h.tarih<=@Ode_BitTar
  and alacak>0 

  insert into @TABLE_BAKIYE_SATIS
  (Cari_Tip,Cari_Kod,Cari_Unvan,Satis_Top,Odeme_Top,Bakiye)
  select Cari_Tip,Cari_Kod,Cari_Unvan,
  sum(Satis_Top),sum(Odeme_Top),sum(Satis_Top-Odeme_Top) Bakiye
  from  @TABLE_BAKIYE
  group by Cari_Tip,Cari_Kod,Cari_Unvan 
  
  
  
  update  @TABLE_BAKIYE_SATIS set Limit_Top=dt.Risk_Limit
  ,Limit_Fark=dt.Risk_Limit-Bakiye from @TABLE_BAKIYE_SATIS as t 
  join (Select k.kod,ISNULL(k.Risk_Limit,0) Risk_Limit
    from Cari_Kart_Listesi as k )
  dt on t.Cari_Kod=dt.kod
  
 


 RETURN



END

================================================================================
