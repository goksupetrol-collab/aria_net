-- Stored Procedure: dbo.Prom_Puan_Sifirla
-- Tarih: 2026-01-14 20:06:08.361475
================================================================================

CREATE PROCEDURE [dbo].[Prom_Puan_Sifirla]
(@firmano		int,
@kart_idin		varchar(8000),
@Yertip         varchar(50),
@Users			varchar(100),
@UsertarSaat	datetime)
AS
BEGIN
  

 declare @islemTip_id   int
 declare @islemTip_Ad   varchar(50)
 declare @YerAd   	varchar(50)
 declare @Tarih			datetime
 declare @Saat			varchar(10)
 declare @Puanid		int
 
 
  declare @OdeTip_id   int
  declare @OdeTip_Ad   varchar(50)
 
 
  select @YerAd=ad from yerad where kod=@Yertip
   
  set @OdeTip_id=85 /*aktarılacak puan */
   select @OdeTip_Ad=ad from islemhrktip 
   where id=@OdeTip_id
 
 
  set @Tarih=convert(varchar,@UsertarSaat,101)
  set @Saat=convert(varchar,@UsertarSaat,108)
 
 
 

  set @islemTip_id=7
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
    BelNo,Tutar_Kdvli,Fatid,Fisid,Promid,Puanid,
    Yertip,YerAd)
    
    select 
    @firmano,0,0,
    k.cartip_id,k.cartip,k.id,k.kod,
    0,'',0,'',
    0,k.Mevcut_Puan,@tarih,@saat,
    @islemTip_id,@islemTip_Ad,
    @OdeTip_id,@OdeTip_Ad,@islemTip_Ad,@Users,@UsertarSaat,
    '',null,k.plaka,
    k.kartno,k.KartId,0,0,
    0,1,'',k.Kal_Tutar,0,0,0,@Puanid,@Yertip,@YerAd 
    from Prom_Musteri_Listesi as k
     where ot_id in (select * from CsvToInt(@kart_idin))
     and Mevcut_Puan>0
     
     
     
     
    
    
  
  

END

================================================================================
