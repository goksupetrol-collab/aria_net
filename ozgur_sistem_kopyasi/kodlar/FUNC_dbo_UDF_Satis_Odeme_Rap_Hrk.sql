-- Function: dbo.UDF_Satis_Odeme_Rap_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.765333
================================================================================

CREATE FUNCTION [dbo].[UDF_Satis_Odeme_Rap_Hrk] (
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
   Tarih				Datetime,
   Islem_Ad				VARCHAR(50) COLLATE Turkish_CI_AS,
   Satis_Top			float,
   Odeme_Top		    float)

AS
BEGIN
 


   declare  @TABLE_BAKIYE TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Cari_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Tarih				Datetime,
   Islem_Ad				VARCHAR(50) COLLATE Turkish_CI_AS,
   Satis_Top			float,
   Odeme_Top		    float)


 /*satis borc */
  if @firmano=0
  insert into @TABLE_BAKIYE
  select k.tip,k.kod,k.Unvan,
  h.tarih,h.islmhrkad,
  Borc,0 Odeme_Top  
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  where h.tarih>=@Sat_BasTar
  and h.tarih<=@Sat_BitTar
  and Borc>0 
  
  
  if @firmano>0
  insert into @TABLE_BAKIYE
  select k.tip,k.kod,k.Unvan,
  h.tarih,h.islmhrkad,
  Borc,0 Odeme_Top  
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
  select k.tip,k.kod,k.Unvan,
  h.tarih,h.islmhrkad,
  0,Alacak  
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  where h.tarih>=@Ode_BasTar
  and h.tarih<=@Ode_BitTar
  and alacak>0 

  if @firmano>0
  insert into @TABLE_BAKIYE
  select k.tip,k.kod,k.Unvan,
  h.tarih,h.islmhrkad,
  0,Alacak  
  from carihrk as h
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  and h.firmano in (0,@firmano)
  where h.tarih>=@Ode_BasTar
  and h.tarih<=@Ode_BitTar
  and alacak>0 

  insert into @TABLE_BAKIYE_SATIS
  select Cari_Tip,Cari_Kod,Cari_Unvan,
  Tarih,Islem_Ad,
  (Satis_Top),(Odeme_Top)
  from  @TABLE_BAKIYE
  order by Cari_Tip,Cari_Kod,Cari_Unvan 










 RETURN


END

================================================================================
