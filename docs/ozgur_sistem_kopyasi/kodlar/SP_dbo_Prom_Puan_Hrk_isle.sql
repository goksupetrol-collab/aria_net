-- Stored Procedure: dbo.Prom_Puan_Hrk_isle
-- Tarih: 2026-01-14 20:06:08.361087
================================================================================

CREATE PROCEDURE [dbo].Prom_Puan_Hrk_isle 
(@Evraktip   	varchar(30),
@Evrak_id		bigint,
@Sil			tinyint)
AS
BEGIN
  

 declare @islemTip_id   int
 declare @islemTip_Ad   varchar(50)
 
 
 if @Evraktip='FISPRSSAT'
  begin
  
  set @islemTip_id=6
   select @islemTip_Ad=ack_tr from Prom_Puan_Hrk_Tip
   where id=@islemTip_id
  
  
   delete from Prom_Puan_Hrk where 
   promid=@Evrak_id   
  
  



    insert into Prom_Puan_Hrk
    (Firmano,Sil,Varno,Cartip_id,Cartip,Car_id,Carkod,
    Stktip_id,Stktip,Stk_id,Stkkod,
    Puan_Giren,Puan_Cikan,
    Tarih,Saat,islemTip_id,islemTip_Ad,OdeTip_id,OdeTip_Ad,
    Ack,OlusUser,OlusTarSaat,DegisUser,DegisTarSaat,
    Car_Plaka,Car_KartNo,Car_KartId,Brm_Fiyat_Kdvli,Kdv_Oran,
    Mik_Giren,Mik_Cikan,
    BelNo,Tutar_Kdvli,Fatid,Fisid,Promid,Yertip,YerAd)
    
    select 
    M.firmano,m.sil,m.varno,
    m.Cartip_id,m.Cartip,m.Car_id,m.Carkod,
    h.stktip_id,h.stktip,h.stk_id,h.stkod,
    h.Kaz_Top_Puan,0,m.tarih,m.saat,
    @islemTip_id,@islemTip_Ad,
    m.OdeTip_id,m.OdeTip_Ad,
    m.ack,m.olususer,m.olustarsaat,
    m.deguser,m.degtarsaat,m.plaka,
    m.Kartno,m.KartId,h.brmfiy,h.kdvyuz*100,
    0,h.mik,m.seri+cast(m.no as varchar(30)),
    h.Tut_isk_Kdvli,
    0,0,m.promid,m.yertip,m.yerad
    From Prom_Sat_Baslik as M inner join 
    Prom_Sat_Hrk as h on m.promid=h.promid
    and m.sil=0 and h.sil=0
    where m.Promid=@Evrak_id and h.Kaz_Top_Puan>0

  end



if @Evraktip='FISPRSTES'
  begin
  
  set @islemTip_id=9
   select @islemTip_Ad=ack_tr from Prom_Puan_Hrk_Tip
   where id=@islemTip_id
  
  
   delete from Prom_Puan_Hrk where 
   promid=@Evrak_id   
  
  



    insert into Prom_Puan_Hrk
    (Firmano,Sil,Varno,Cartip_id,Cartip,Car_id,Carkod,
    Stktip_id,Stktip,Stk_id,Stkkod,
    Puan_Giren,Puan_Cikan,
    Tarih,Saat,islemTip_id,islemTip_Ad,OdeTip_id,OdeTip_Ad,
    Ack,OlusUser,OlusTarSaat,DegisUser,DegisTarSaat,
    Car_Plaka,Car_KartNo,Car_KartId,Brm_Fiyat_Kdvli,Kdv_Oran,
    Mik_Giren,Mik_Cikan,
    BelNo,Tutar_Kdvli,Fatid,Fisid,Promid,Yertip,YerAd)
    
    select 
    M.firmano,m.sil,m.varno,
    m.Cartip_id,m.Cartip,m.Car_id,m.Carkod,
    h.stktip_id,h.stktip,h.stk_id,h.stkod,
    0,h.Sat_Top_Puan,m.tarih,m.saat,
    @islemTip_id,@islemTip_Ad,
    m.OdeTip_id,m.OdeTip_Ad,
    m.ack,m.olususer,m.olustarsaat,
    m.deguser,m.degtarsaat,m.plaka,
    m.Kartno,m.KartId,h.brmfiy,h.kdvyuz*100,
    0,h.mik,m.seri+cast(m.no as varchar(30)),
    h.Tut_isk_Kdvli,
    0,0,m.promid,m.yertip,m.yerad
    From Prom_Sat_Baslik as M inner join 
    Prom_Sat_Hrk as h on m.promid=h.promid
    and m.sil=0 and h.sil=0
    where m.Promid=@Evrak_id and h.Sat_Top_Puan>0

  end








END

================================================================================
