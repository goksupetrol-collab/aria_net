-- Function: dbo.UDF_Satis_Personel_Rap
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.765916
================================================================================

CREATE FUNCTION [dbo].[UDF_Satis_Personel_Rap] (
@firmano 		int,
@Sat_BasTar		Datetime,
@Sat_BitTar		Datetime)
RETURNS
   
   @TABLE_BAKIYE_SATIS TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Per_id				int,
   Per_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Per_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Satis_Tutar			float,
   Satis_Litre		    float)

AS
BEGIN
 


   declare  @TABLE_BAKIYE TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Per_id				int,
   Per_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Per_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Yakit_Tip			VARCHAR(30) COLLATE Turkish_CI_AS, 
   Yakit_Kod			VARCHAR(30) COLLATE Turkish_CI_AS,
   Satis_Tutar			float,
   Satis_Litre		    float)


 /*satıs borc */
  if @firmano=0
  insert into @TABLE_BAKIYE (Per_id,Per_Kod,Per_Unvan,Yakit_Tip,Yakit_Kod,
  Satis_Tutar,Satis_Litre)
  select k.id,k.kod,k.ad+' '+k.soyad Unvan,h.stktip,h.stkod,
  ((h.brmfiy*h.mik)+h.otvtut)*(1+h.kdvyuz) TUTARKDVLI,
  h.mik 
  from Faturamas as m
  inner join faturahrk as h on m.fatid=h.fatid
  and m.sil=0 and h.sil=0  
  inner join perkart as k 
  on m.per_id=k.id
  where m.tarih>=@Sat_BasTar
  and m.tarih<=@Sat_BitTar
  and Per_id>0 
  
  
  if @firmano>0
  insert into @TABLE_BAKIYE (Per_id,Per_Kod,Per_Unvan,Yakit_Tip,Yakit_Kod,
  Satis_Tutar,Satis_Litre)
  select k.id,k.kod,k.ad+' '+k.soyad Unvan,h.stktip,h.stkod,
  ((h.brmfiy*h.mik)+h.otvtut)*(1+h.kdvyuz) TUTARKDVLI,
  h.mik
  from Faturamas as m
  inner join faturahrk as h on m.fatid=h.fatid
  and m.sil=0 and h.sil=0  
  inner join perkart as k 
  on m.per_id=k.id
  where m.tarih>=@Sat_BasTar
  and m.tarih<=@Sat_BitTar
  and m.firmano in (0,@firmano)
  and Per_id>0 
  
   
  
  
 

  insert into @TABLE_BAKIYE_SATIS
  (Per_id,Per_Kod,Per_Unvan, Satis_Tutar,Satis_Litre)
  select Per_id,Per_Kod,Per_Unvan,
  sum(Satis_Tutar),sum(Satis_Litre)
  from  @TABLE_BAKIYE
  group by Per_id,Per_Kod,Per_Unvan










 RETURN


END

================================================================================
