-- Stored Procedure: dbo.Prom_Puan_Birlestir
-- Tarih: 2026-01-14 20:06:08.360704
================================================================================

CREATE PROCEDURE [dbo].[Prom_Puan_Birlestir]
(@firmano		int,
@SecKart_idin	varchar(8000),
@Mas_Kartid		int,
@Yertip         varchar(50),
@Tarih			datetime,
@Saat			varchar(10),
@Belno			varchar(30),
@Ack			varchar(100),
@Users			varchar(100),
@UsertarSaat	datetime)
AS
BEGIN
  

 declare @islemTip_id   int
 declare @islemTip_Ad   varchar(50)
 declare @YerAd   	varchar(50)
 declare @Puanid 	int

  declare @OdeTip_id   int
  declare @OdeTip_Ad   varchar(50)


 
  declare @Aktar_Puan	Float 
  declare @Aktar_Tutar	Float 
 
 
  select @YerAd=ad from yertipad where kod=@Yertip
  
  
  set @OdeTip_id=85 /*aktarılacak puan */
   select @OdeTip_Ad=ad from islemhrktip 
   where id=@OdeTip_id
  
   

 
  set @islemTip_id=10 /*aktarılacak puan */
   select @islemTip_Ad=ack_tr from Prom_Puan_Hrk_Tip
   where id=@islemTip_id
  
   select @Puanid=isnull(MAX(id),0)+1 from Prom_Puan_Hrk
   
    insert into Prom_Puan_Hrk
    (Firmano,Sil,Varno,Cartip_id,Cartip,Car_id,Carkod,
    Stktip_id,Stktip,Stk_id,Stkkod,
    Puan_Giren,Puan_Cikan,
    Tarih,Saat,islemTip_id,islemTip_Ad,OdeTip_id,OdeTip_Ad,
    Ack,OlusUser,OlusTarSaat,DegisUser,DegisTarSaat,
    Car_Plaka,Car_KartNo,Car_KartId,Brm_Fiyat_Kdvli,Kdv_Oran,
    Mik_Giren,Mik_Cikan,
    BelNo,Tutar_Kdvli,Fatid,Fisid,
    Promid,Puanid,Yertip,YerAd)
    
    select 
    @firmano,0,0,
    k.cartip_id,k.cartip,k.id,k.kod,
    0,'',0,'',
    0,k.Mevcut_Puan,@tarih,@saat,
    @islemTip_id,@islemTip_Ad,
    @OdeTip_id,@OdeTip_Ad,@Ack,@Users,@UsertarSaat,
    '',null,k.plaka,
    k.kartno,k.KartId,0,0,
    0,1,@Belno,k.Kal_Tutar,0,0,0,@Puanid,@Yertip,@YerAd 
    from Prom_Musteri_Listesi as k
     where k.KartId in (select * from CsvToInt(@SecKart_idin))
     and Mevcut_Puan>0
    
  
  
   select @Aktar_Puan=isnull(sum(Puan_Cikan),0),
   @Aktar_Tutar=isnull(sum(Tutar_Kdvli),0) from Prom_Puan_Hrk
   where Puanid=@Puanid and sil=0 and islemTip_id=@islemTip_id
    
  if @Aktar_Puan=0
   RETURN  
   
    set @islemTip_id=11 /*gelen puan */
    select @islemTip_Ad=ack_tr from Prom_Puan_Hrk_Tip
     where id=@islemTip_id   
     
     
    insert into Prom_Puan_Hrk
    (Firmano,Sil,Varno,Cartip_id,Cartip,Car_id,Carkod,
    Stktip_id,Stktip,Stk_id,Stkkod,
    Puan_Giren,Puan_Cikan,
    Tarih,Saat,islemTip_id,islemTip_Ad,OdeTip_id,OdeTip_Ad,
    Ack,OlusUser,OlusTarSaat,DegisUser,DegisTarSaat,
    Car_Plaka,Car_KartNo,Car_KartId,Brm_Fiyat_Kdvli,Kdv_Oran,
    Mik_Giren,Mik_Cikan,
    BelNo,Tutar_Kdvli,Fatid,Fisid,
    Promid,Puanid,Yertip,YerAd)
    
    select 
    @firmano,0,0,
    k.cartip_id,k.cartip,k.id,k.kod,
    0,'',0,'',
    @Aktar_Puan,0,@tarih,@saat,
    @islemTip_id,@islemTip_Ad,
    @OdeTip_id,@OdeTip_Ad,@Ack,@Users,@UsertarSaat,
    '',null,k.plaka,
    k.kartno,k.KartId,0,0,
    1,0,@Belno,@Aktar_Tutar,0,0,0,@Puanid,@Yertip,@YerAd 
    from Prom_Musteri_Listesi as k
     where k.KartId=@Mas_Kartid
     
    
    
  
  

END

================================================================================
