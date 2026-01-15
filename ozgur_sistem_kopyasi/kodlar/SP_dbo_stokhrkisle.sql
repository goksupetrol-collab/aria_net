-- Stored Procedure: dbo.stokhrkisle
-- Tarih: 2026-01-14 20:06:08.382974
================================================================================

CREATE PROCEDURE [dbo].stokhrkisle 
@islmid 		float,
@tabload 		varchar(50),
@cevstkod 		varchar(30),
@kayok 			int,
@sil 			int,
@AnaKay_id		float
AS
BEGIN
/*-marketkart */

  declare @islmtip 	varchar(20)
  declare @islmtipad 	varchar(30)
  declare @newid 		float
  declare @islmtip1 	varchar(20)
  declare @islmtipad1 varchar(30)
  declare @say 		float
  declare @stktip 	varchar(20)
  declare @market_depo    varchar(30)

 
 declare @islmhrk varchar(20)
 declare @islmhrkad varchar(30)



/*-market satis */
  if @tabload='marsathrk'
   begin
 
  /*delete from stkhrk from stkhrk with(nolock) where tabload=@tabload  */
  /*and (marsatid>0 and marsatid=@AnaKay_id) */
  
  
  /* update stkhrk Set Sil=1  where tabload=@tabload and Sil=0 */
 /*  and (marsatid>0 and marsatid=@AnaKay_id) */
  

  if (@kayok=1) /*and (@sil=0) */
  begin
   select @islmtip=kod,@islmtipad=ad   from stkhrktip where kod='MARSAT'
   select @islmtip1=kod,@islmtipad1=ad from stkhrktip where kod='MARIAD'

   /*Update Recetesiz Urun Ve Receteli Ana Urun */
   update stkhrk Set firmano=dt.firmano,sil=dt.sil,
   stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
   tarih=dt.tarih,saat=dt.saat,
   stktip_id=dt.stktip_id,stktip=dt.stktip,
  /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
   islmtip=dt.islmtip,islmtipad=dt.islmtipad,
   yertip=dt.yertip,yerad=dt.yerad,
   giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
   depkod=dt.depkod,brmfiykdvli=dt.brmfiykdvli,
   kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
   from stkhrk as t join 
    ( select h.id,m.firmano,h.sil,
      stk_id,stkod,h.barkod,m.tarih,m.saat,stktip_id,stktip,
      /*m.degistarsaat,m.degisuser, */
      case when m.islmtip='iade' then @islmtip1 else @islmtip end islmtip,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end islmtipad,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then mik else 0 end giren,
      case when m.islmtip='satis' then mik else 0 end cikan,
      case when m.islmtip='iade' then mik else 0 end siademik,
      depkod,(brmfiy*(1-indyuz))*h.kur brmfiykdvli,kdvyuz ,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid
      where h.marsatid=@AnaKay_id /*and isnull(h.Recete,0)=0 */
      and h.id in (Select stkhrkid From stkhrk with (nolock) 
      where marsatid=@AnaKay_id ) ) dt 
      on dt.id=t.stkhrkid and dt.marsatid=t.marsatid 


      /*Update Urun Receteli Ana Urun Giris Hrk */
       update stkhrk Set firmano=dt.firmano,sil=dt.sil,
       UrunId=dt.UrunId,stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
       tarih=dt.tarih,saat=dt.saat,
       stktip_id=dt.stktip_id,stktip=dt.stktip,
      /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
       islmtip=dt.islmtip,islmtipad=dt.islmtipad,
       yertip=dt.yertip,yerad=dt.yerad,
       giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
       depkod=dt.depkod,brmfiykdvli=dt.brmfiykdvli,
       kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
      from stkhrk as t join 
      ( select h.id,rh.MarSatRecHrkId RecHrkId,rh.UrunId,m.firmano,h.sil,
      h.Stk_id as stk_id,h.stkod as stkod,
      h.barkod,m.tarih,m.saat,
      h.stktip_id as stktip_id,h.stktip as stktip,
      /*m.degistarsaat,m.degisuser, */
      case when m.islmtip='iade' then @islmtip1 else @islmtip end islmtip,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end islmtipad,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then 0 else mik end giren,
      case when m.islmtip='satis' then 0 else mik end cikan,
      case when m.islmtip='iade' then 0 else mik end siademik,
      depkod,(rh.BirimMaliyetFiyat/mik) brmfiykdvli,kdvyuz ,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid
      inner join V_MarketSatisUrunIdReceteMaliyet as rh 
      on rh.MarSatId=m.marsatid and rh.MarSatHrkId=h.id
      where h.marsatid=@AnaKay_id and isnull(h.Recete,0)=1  
      and EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.marsatid=@AnaKay_id and h.id = sh.stkhrkid  
      and rh.MarSatRecHrkId = isnull(sh.MarSatRecHrkId,0) )
      /*and h.id in (Select stkhrkid From stkhrk with (nolock)  */
      /*where marsatid=@AnaKay_id )  */
      ) dt 
      on dt.id=t.stkhrkid and dt.marsatid=t.marsatid and dt.RecHrkId=t.MarSatRecHrkId 



      /*Update Urun Recete Hrk */
       update stkhrk Set firmano=dt.firmano,sil=dt.sil,
       UrunId=dt.UrunId,stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
       tarih=dt.tarih,saat=dt.saat,
       stktip_id=dt.stktip_id,stktip=dt.stktip,
      /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
       islmtip=dt.islmtip,islmtipad=dt.islmtipad,
       yertip=dt.yertip,yerad=dt.yerad,
       giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
       depkod=dt.depkod,brmfiykdvli=dt.brmfiykdvli,
       kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
      from stkhrk as t join 
      ( select h.id,rh.Id RecHrkId,rh.UrunId,m.firmano,h.sil,
      rh.StokId as stk_id,rh.StokKod as stkod,
      h.barkod,m.tarih,m.saat,
      rh.StokTipId as stktip_id,rh.StokTip as stktip,
      /*m.degistarsaat,m.degisuser, */
      case when m.islmtip='iade' then @islmtip1 else @islmtip end islmtip,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end islmtipad,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then rh.miktar else 0 end giren,
      case when m.islmtip='satis' then rh.miktar else 0 end cikan,
      case when m.islmtip='iade' then rh.miktar else 0 end siademik,
      depkod,BirimFiyat brmfiykdvli,kdvyuz ,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid
      inner join MarSatRecHrk as rh with (nolock) on 
      Rh.MarSatHrkId=H.id 
      where h.marsatid=@AnaKay_id and isnull(h.Recete,0)=1 and rh.UretimTipId=1 
      and EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.marsatid=@AnaKay_id and h.id = sh.stkhrkid  and rh.Id = isnull(sh.MarSatRecHrkId,0) )
      /*and h.id in (Select stkhrkid From stkhrk with (nolock)  */
      /*where marsatid=@AnaKay_id )  */
      ) dt 
      on dt.id=t.stkhrkid and dt.marsatid=t.marsatid and dt.RecHrkId=t.MarSatRecHrkId 
       
      
      
      
      
      
      

      /*insert  Recetesiz Urun Ve Receteli Ana Urun  */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,marsatid,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno)
      
      select m.firmano,h.id,
      stk_id,stkod,h.barkod,m.tarih,m.saat,stktip_id,stktip,m.olustarsaat,m.olususer,
      case when m.islmtip='iade' then @islmtip1 else @islmtip end,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then mik else 0 end,
      case when m.islmtip='satis' then mik else 0 end,
      case when m.islmtip='iade' then mik else 0 end,
      depkod,(brmfiy*(1-indyuz))*h.kur,kdvyuz,@tabload,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0),
      m.varno
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid
      and m.sil=0 and h.sil=0
      where h.marsatid=@AnaKay_id and h.sil=0 
      /*and isnull(h.Recete,0)=0 */
      and h.id not in (Select stkhrkid From stkhrk with (nolock) 
      where marsatid=@AnaKay_id and isnull(MarSatRecHrkId,0)=0 )
      
      
      /*insert Receteli Urun Giris Hrk */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,marsatid,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno,MarSatRecHrkId,UrunId)
      
      select m.firmano,h.id,
      stk_id,stkod,h.barkod,m.tarih,m.saat,stktip_id,stktip,m.olustarsaat,m.olususer,
      case when m.islmtip='iade' then @islmtip1 else @islmtip end,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then 0 else mik end,
      case when m.islmtip='satis' then 0 else mik end,
      case when m.islmtip='iade' then 0 else mik end,
      depkod,(rm.BirimMaliyetFiyat/mik),kdvyuz,@tabload,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0),
      m.varno,rm.MarSatRecHrkId,rm.UrunId
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid and m.sil=0 and h.sil=0
      inner join V_MarketSatisUrunIdReceteMaliyet as rm 
      on rm.MarSatId=m.marsatid and rm.MarSatHrkId=h.id
      where h.marsatid=@AnaKay_id and h.sil=0 
      and isnull(h.Recete,0)=1
      and NOT EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.marsatid=@AnaKay_id and h.id = sh.stkhrkid  
      AND rm.MarSatRecHrkId = isnull(sh.MarSatRecHrkId,0) )
      
     /* and h.id not in (Select stkhrkid From stkhrk with (nolock) 
      where marsatid=@AnaKay_id and isnull(MarSatRecHrkId,0)=0 )
     */ 
      
      
      
      /*insert Urun Recete Hrk */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,marsatid,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno,MarSatRecHrkId,UrunId)
      
      select m.firmano,h.id,
      rh.StokId,rh.StokKod,h.barkod,m.tarih,m.saat,
      rh.StokTipId,rh.StokTip,m.olustarsaat,m.olususer,
      case when m.islmtip='iade' then @islmtip1 else @islmtip end,
      case when m.islmtip='iade' then @islmtipad1 else @islmtipad end,
      m.yertip,m.yerad,m.marsatid,
      case when m.islmtip='iade' then rh.Miktar else 0 end,
      case when m.islmtip='satis' then rh.Miktar else 0 end,
      case when m.islmtip='iade' then rh.Miktar else 0 end,
      depkod,rh.BirimFiyat,kdvyuz,@tabload,
      LTRIM(STR(m.marsatid, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' MARKET SATIŞI' 
      from marvardimas with (nolock) where varno=m.varno and m.sil=0),
      m.varno,rh.Id,rh.UrunId
      from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid
      and m.sil=0 and h.sil=0
      inner join MarSatRecHrk as Rh with (nolock) on 
      Rh.MarSatHrkId=H.id and Rh.Sil=0     
      where h.marsatid=@AnaKay_id and h.sil=0 
      and isnull(h.Recete,0)=1 and rh.UretimTipId=1 /*recete */
      and NOT EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.marsatid=@AnaKay_id and h.id = sh.stkhrkid  AND rh.Id = isnull(sh.MarSatRecHrkId,0) )

    /*  and h.id not in (Select stkhrkid From stkhrk with (nolock) 
      where marsatid=@AnaKay_id and isnull(MarSatRecHrkId,0)>0 )
     */ 
     
      
     
     /*delete  */
     update stkhrk set Sil=1 where marsatid=@AnaKay_id
     and stkhrkid not in (select h.id  from marsathrk h with (nolock)
      inner join marsatmas as m  with (nolock)
      on m.marsatid=h.marsatid  where h.marsatid=@AnaKay_id)
    
    
      
    end


    exec SpLog_MarketSatis @AnaKay_id
    exec SpLog_MarketSatisHareket @AnaKay_id
   
    exec SpLog_MarketSatisUrunHareket @AnaKay_id


   RETURN
  end
/*------------------------------------------------------------------------------------------- */


 /*-Resturant satis */
  if @tabload='ResSatHrk'
   begin
 /* 
  delete from stkhrk from stkhrk with(nolock) where tabload=@tabload 
  and (ResSatId>0 and ResSatId=@AnaKay_id)
  */
  if (@kayok=1) /*and (@sil=0) */
  begin
   select @islmtip=kod,@islmtipad=ad   from stkhrktip where kod='RESSAT'
   select @islmtip1=kod,@islmtipad1=ad from stkhrktip where kod='RESIADE'


    
   /*Update Recetesiz Urun Ve Receteli Ana Urun */
   update stkhrk Set firmano=dt.firmano,sil=dt.sil,
   stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
   tarih=dt.tarih,saat=dt.saat,
   stktip_id=dt.stktip_id,stktip=dt.stktip,
  /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
   islmtip=dt.islmtip,islmtipad=dt.islmtipad,
   yertip=dt.yertip,yerad=dt.yerad,
   giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
   depkod=dt.depokod,brmfiykdvli=dt.brmfiykdvli,
   kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
   from stkhrk as t join 
    ( select h.Id,m.firmano,h.sil,
      H.StkId as stk_id,k.Kod stkod,k.barkod,m.tarih,m.saat,
      stktipId stktip_id,k.tip stktip,
      /*m.degistarsaat,m.degisuser, */
      case when m.Iade=1 then @islmtip1 else @islmtip end islmtip,
      case when m.Iade=1 then @islmtipad1 else @islmtipad end islmtipad,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1 then miktar else 0 end giren,
      case when m.Iade=1 then miktar else 0 end cikan,
      case when m.Iade=1 then miktar else 0 end siademik,
      m.depokod,(birimfiyat*(1-Indyuz))*h.kur brmfiykdvli,kdvyuz ,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId
      left join stokkart as k with (nolock) on k.id=h.StkId
      where h.ResSatId=@AnaKay_id /*and isnull(h.Recete,0)=0 */
      and h.Id in (Select stkhrkid From stkhrk with (nolock) 
      where ResSatId=@AnaKay_id ) ) dt 
      on dt.Id=t.stkhrkid and dt.ResSatId=t.ResSatId 


      /*Update Urun Receteli Ana Urun Giris Hrk */
       update stkhrk Set firmano=dt.firmano,sil=dt.sil,
       UrunId=dt.UrunId,stk_id=dt.stk_id,
       stkod=dt.stkod,barkod=dt.barkod,
       tarih=dt.tarih,saat=dt.saat,
       stktip_id=dt.stktip_id,stktip=dt.stktip,
      /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
       islmtip=dt.islmtip,islmtipad=dt.islmtipad,
       yertip=dt.yertip,yerad=dt.yerad,
       giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
       depkod=dt.depokod,brmfiykdvli=dt.brmfiykdvli,
       kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
      from stkhrk as t join 
      ( select h.Id,rh.ResSatRecHrkId RecHrkId,rh.UrunId,
      m.firmano,h.sil,
      h.StkId as stk_id,k.kod as stkod,k.barkod,
      m.tarih,m.saat,
      h.StktipId as stktip_id,k.tip as stktip,
      case when m.Iade=1 then @islmtip1 else @islmtip end islmtip,
      case when m.Iade=1 then @islmtipad1 else @islmtipad end islmtipad,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1 then 0 else miktar end giren,
      case when m.Iade=1 then 0 else miktar end cikan,
      case when m.Iade=1 then 0 else miktar end siademik,
      depokod,(rh.BirimMaliyetFiyat/miktar) brmfiykdvli,kdvyuz ,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId
      left join stokkart as k with (nolock) on k.id=h.StkId
      inner join V_ResSatisUrunIdReceteMaliyet as rh 
      on rh.ResSatId=m.Id and rh.ResSatHrkId=h.Id
      where h.ResSatId=@AnaKay_id and isnull(h.Recete,0)=1  
      and EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.ResSatId=@AnaKay_id and h.Id = sh.stkhrkid  
      and rh.ResSatRecHrkId = isnull(sh.ResSatRecHrkId,0) )
      ) dt 
      on dt.Id=t.stkhrkid and dt.ResSatId=t.ResSatId 
      and dt.RecHrkId=t.ResSatRecHrkId 



      /*Update Urun Recete Hrk */
       update stkhrk Set firmano=dt.firmano,sil=dt.sil,
       UrunId=dt.UrunId,stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
       tarih=dt.tarih,saat=dt.saat,
       stktip_id=dt.stktip_id,stktip=dt.stktip,
      /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
       islmtip=dt.islmtip,islmtipad=dt.islmtipad,
       yertip=dt.yertip,yerad=dt.yerad,
       giren=dt.giren,cikan=dt.cikan,siademik=dt.siademik,
       depkod=dt.depokod,brmfiykdvli=dt.brmfiykdvli,
       kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
      from stkhrk as t join 
      ( select h.Id,rh.Id RecHrkId,rh.UrunId,m.firmano,h.sil,
      rh.StokId as stk_id,rh.StokKod as stkod,
      k.barkod,m.tarih,m.saat,
      rh.StokTipId as stktip_id,rh.StokTip as stktip,
      case when m.Iade=1 then @islmtip1 else @islmtip end islmtip,
      case when m.Iade=1 then @islmtipad1 else @islmtipad end islmtipad,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1 then rh.miktar else 0 end giren,
      case when m.Iade=1 then rh.miktar else 0 end cikan,
      case when m.Iade=1 then rh.miktar else 0 end siademik,
      depokod,rh.BirimFiyat brmfiykdvli,kdvyuz,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0) ack,
      m.varno
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId
      left join stokkart as k with (nolock) on k.id=h.StkId
      inner join ResSatRecHrk as rh with (nolock) on 
      Rh.ResSatHrkId=H.Id 
      where h.ResSatId=@AnaKay_id and isnull(h.Recete,0)=1 and rh.UretimTipId=1 
      and EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.ResSatId=@AnaKay_id and h.Id = sh.stkhrkid  
      and rh.Id = isnull(sh.ResSatRecHrkId,0) )
      ) dt 
      on dt.Id=t.stkhrkid and dt.ResSatId=t.ResSatId 
      and dt.RecHrkId=t.ResSatRecHrkId 
       
      
      
      
 
      
      

      /*insert  Recetesiz Urun Ve Receteli Ana Urun  */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,ResSatId,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno)
      
      select m.firmano,h.Id,
      h.stkId stk_id,k.kod stkod,h.barkod,m.tarih,m.saat,
      h.stktipId stktip_id,k.tip stktip,
      m.olustarsaat,m.olususer,
      case when m.Iade=1 then @islmtip1 else @islmtip end,
      case when m.Iade=1 then @islmtipad1 else @islmtipad end,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1 then miktar else 0 end,
      case when m.Iade=0 then miktar else 0 end,
      case when m.Iade=1 then miktar else 0 end,
      depokod,(birimfiyat*(1-Indyuz))*h.kur,kdvyuz,@tabload,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0),
      m.varno
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId
      and m.sil=0 and h.sil=0
      left join stokkart as k with (nolock) on k.id=h.StkId
      where h.ResSatId=@AnaKay_id and h.sil=0 
      and h.Id not in (Select stkhrkid From stkhrk with (nolock) 
      where ResSatId=@AnaKay_id and isnull(ResSatRecHrkId,0)=0 )
 
 

      
      
      /*insert Receteli Urun Giris Hrk */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,ResSatId,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno,ResSatRecHrkId,UrunId)
      
      select m.firmano,h.Id,
      h.stkId stk_id,k.kod stkod,h.barkod,
      m.tarih,m.saat,
      h.stktipId stktip_id,k.tip stktip,      
      m.olustarsaat,m.olususer,
      case when m.Iade=1 then @islmtip1 else @islmtip end,
      case when m.Iade=1 then @islmtipad1 else @islmtipad end,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1 then 0 else miktar end,
      case when m.Iade=0 then 0 else miktar end,
      case when m.Iade=1 then 0 else miktar end,
      depokod,(rm.BirimMaliyetFiyat/miktar),kdvyuz,@tabload,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0),
      m.varno,rm.ResSatRecHrkId,rm.UrunId
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId and m.sil=0 and h.sil=0
      inner join V_ResSatisUrunIdReceteMaliyet as rm 
      on rm.ResSatId=m.Id and rm.ResSatHrkId=h.Id
      left join stokkart as k with (nolock) on k.id=h.StkId
      where h.ResSatId=@AnaKay_id and h.sil=0 
      and isnull(h.Recete,0)=1
      and NOT EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.ResSatId=@AnaKay_id and h.Id = sh.stkhrkid  
      AND rm.ResSatRecHrkId = isnull(sh.ResSatRecHrkId,0) )
      
       
 
      
      /*insert Urun Recete Hrk */
      insert stkhrk (firmano,stkhrkid,
      stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
      islmtipad,yertip,yerad,ResSatId,giren,cikan,siademik,
      depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno,ResSatRecHrkId,UrunId)
      
      select m.firmano,h.Id,
      rh.StokId,rh.StokKod,k.barkod,m.tarih,m.saat,
      rh.StokTipId,rh.StokTip,m.olustarsaat,m.olususer,
      case when m.Iade=1  then @islmtip1 else @islmtip end,
      case when m.Iade=1  then @islmtipad1 else @islmtipad end,
      'ResSatMas' YerTip,'Restaurant Satis' YerAd,m.Id as ResSatId,
      case when m.Iade=1  then rh.Miktar else 0 end,
      case when m.Iade=0  then rh.Miktar else 0 end,
      case when m.Iade=1  then rh.Miktar else 0 end,
      depokod,rh.BirimFiyat,kdvyuz,@tabload,
      LTRIM(STR(m.Id, 25, 0))  belno,
      (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
      from ResVardiMas with (nolock) where varno=m.varno and m.sil=0),
      m.varno,rh.Id,rh.UrunId
      from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId
      and m.sil=0 and h.sil=0
      inner join ResSatRecHrk as Rh with (nolock) on 
      Rh.ResSatHrkId=H.Id and Rh.Sil=0   
      left join stokkart as k with (nolock) on k.id=h.StkId  
      where h.ResSatId=@AnaKay_id and h.sil=0 
      and isnull(h.Recete,0)=1 and rh.UretimTipId=1 /*recete */
      and NOT EXISTS (SELECT id FROM stkhrk as sh with (nolock) 
      WHERE sh.ResSatId=@AnaKay_id and h.Id = sh.stkhrkid  
      AND rh.Id = isnull(sh.ResSatRecHrkId,0) )

    
  
     
     /*delete  */
     update stkhrk set Sil=1 where ResSatId=@AnaKay_id
     and stkhrkid not in (select h.Id  from ResSatHrk h with (nolock)
      inner join ResSatMas as m  with (nolock)
      on m.Id=h.ResSatId  where h.ResSatId=@AnaKay_id)
   
   


   /*
    insert stkhrk (firmano,stkhrkid,
    stk_id,stkod,barkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,islmtip,
    islmtipad,yertip,yerad,ResSatId,giren,cikan,siademik,
    depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,varno)
    select m.firmano,h.Id,
    stkId,k.kod,k.barkod,m.tarih,m.saat,stktipId,'markt',m.olustarsaat,m.olususer,
    case when m.Iade=1 then @islmtip1 else @islmtip end,
    case when m.Iade=1 then @islmtipad1 else @islmtipad end,
    'ResVardiMas','RESTAURAT VARDIYA',m.Id,
    case when m.Iade=1 then miktar else 0 end,
    case when m.Iade=0 then miktar else 0 end,
    case when m.Iade=1 then miktar else 0 end,
    m.depokod,(BirimFiyat*(1-Indyuz))*h.kur,kdvyuz,@tabload,
    LTRIM(STR(m.Id, 25, 0))  belno,
    (select top 1 cast(varad as varchar)+' RESTAURANT SATIŞI' 
    from resvardimas with (nolock) where 
    varno=m.varno and m.sil=0),
    m.varno
    from ressathrk h with (nolock)
    inner join ressatmas as m with (nolock)
    on m.Id=h.RessatId
    and m.sil=0 and h.sil=0
    inner join stokkart as k with (nolock) on
    k.id=h.stkId
    where h.RessatId=@AnaKay_id
    and h.sil=0
    */
    
    
    
     
    end

   RETURN
  end
/*------------------------------------------------------------------------------------------- */



  /*-veresihrk satis */
  if @tabload='veresihrk'
  begin

   delete from stkhrk from stkhrk with(nolock) where tabload=@tabload
   and (fisid>0 and fisid=@AnaKay_id)
   /* and stkhrkid=@islmid */
   

  if (@kayok=1) and (@sil=0) 
   insert stkhrk (firmano,stkhrkid,stkod,tarih,saat,stktip,olustarsaat,olususer,islmtip,islmtipad,
   yertip,yerad,fisid,giren,cikan,depkod,brmfiykdvli,kdvyuz,tabload,belno,ack,
   Karsi_Karttip,Karsi_KartKod)
   select m.firmano,h.id,stkod,m.tarih,m.saat,h.stktip,h.olustarsaat,h.olususer,
   m.fistip,m.fisad,m.yertip,m.yerad,m.verid,0,mik,depkod,brmfiy,kdvyuz,@tabload,
   seri+cast([no] as varchar),ack,
   m.cartip,m.carkod
    from veresihrk as h WITH (NOLOCK)
   inner join veresimas as m WITH (NOLOCK) on m.verid=h.verid
   where h.verid=@AnaKay_id and h.depkod <>'' and m.hrk_stk_pro=1 
   and h.stktip in ('akykt','markt') and h.sil=0 
   
   
   
   /*emtia satis işle */
   delete from emtiasat from emtiasat with(nolock) where 
   (fis_id>0 and fis_id=@AnaKay_id)
  
  if (@kayok=1) and (@sil=0) 
   begin
   
   select @islmtip=kod,@islmtipad=ad from stkhrktip 
   where kod='POMMARSAT'
   
   
   select top 1 @market_depo=kod from depokart 
   where sil=0 and firmano=(select top 1 firmano from
    veresimas with(nolock) where verid=@AnaKay_id)
      
   insert emtiasat (emtid,firmano,tarih,saat,varno,perkod,adaid,
   stktip,islmtip,islmtipad,yertip,yerad,depkod,
   stkod,mik,brmfiy,tutar,olususer,olustarsaat,
   deguser,degtarsaat,kdvyuz,varok,sil,
   belno,ack,stk_id,stktip_id,fis_id)
     
   select h.id,m.firmano,m.tarih,m.saat,m.varno,m.perkod,m.adaid,
   h.stktip,@islmtip,@islmtipad,m.yertip,m.yerad,@market_depo,
   h.stkod,h.mik,h.brmfiy,h.mik*h.brmfiy,
   h.olususer,h.olustarsaat,h.deguser,h.degtarsaat,
   kdvyuz,m.varok,m.sil,seri+cast([no] as varchar),ack,
   h.stk_id,h.stktip_id,m.Verid 
   from veresihrk as h WITH (NOLOCK)
   inner join veresimas as m WITH (NOLOCK) on m.verid=h.verid
   where h.verid=@AnaKay_id  and m.emtia_isle=1 
   and h.stktip in ('markt') and h.sil=0 
   
   
   update emtiasat set emtid=id where fis_id=@AnaKay_id
   
   
  end 
   
   
   delete from carihrk  from carihrk with(nolock) where 
   (fisid>0 and fisid=@AnaKay_id) and (FisStkAnaid=@AnaKay_id) 
   /* fisstkhrkid=@islmid  */
   
   if (@kayok=1) and (@sil=0) 
    begin

   set @islmtip='FIS'
   set @islmhrk='FST'
   select @islmtipad=ad from islemturtip where tip=@islmtip
   select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
   

    select @newid=0
    insert into carihrk (firmano,carhrkid,gctip,
    fisstkhrkid,fisfattip,fisfatid,
    islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    cartip_id,cartip,car_id,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
    ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
    karsihestip,karsiheskod,parabrm,fisid,FisStkAnaid)
    select m.firmano,@newid,'',@islmid,'FIS',m.verid,@islmtip,
    @islmtipad,@islmhrk,@islmhrkad,m.yertip,m.yerad,
    3,'gelgidkart',h.stk_id,h.stkod,(h.brmfiy*h.mik),0,
    0,m.tarih,m.saat,h.olususer,h.olustarsaat,m.vadtar,m.seri+cast(m.[no] as varchar(20)),
    m.ack,0,1,0,0,1,'',0,h.olususer,h.olustarsaat,m.sil,
    '','',m.parabrm,m.verid,m.verid  from veresihrk as h WITH (NOLOCK)
    inner join veresimas as m WITH (NOLOCK) on m.verid=h.verid
    where h.verid=@AnaKay_id and h.depkod <>'' and m.hrk_stk_pro=1 
    and h.stktip in ('gelgid') and h.sil=0 

    select @newid=SCOPE_IDENTITY()
    update carihrk set carhrkid=@newid where id=@newid 
   
   
   end
   
  return
  end


/*-prom_Sat_hrk satis */
if @tabload='Prom_Sat_Hrk'
begin

 delete from stkhrk from stkhrk with(nolock) where tabload=@tabload
 and (Promid>0 and Promid=@AnaKay_id)
 /* and stkhrkid=@islmid */
 

if (@kayok=1) and (@sil=0) 
 insert stkhrk (firmano,stkhrkid,stkod,tarih,saat,stktip,
 olustarsaat,olususer,islmtip,islmtipad,
 yertip,yerad,promid,giren,cikan,depkod,brmfiykdvli,kdvyuz,tabload,belno,ack)
 select m.firmano,h.id,h.stkod,m.tarih,m.saat,h.stktip,h.olustarsaat,h.olususer,
 m.fistip,m.fisad,m.yertip,m.yerad,m.promid,0,mik,depkod,brmfiy,kdvyuz,@tabload,
 seri+cast([no] as varchar),ack from Prom_Sat_Hrk as h with (nolock)
 inner join Prom_Sat_Baslik as m with (nolock) on m.promid=h.promid
 where h.promid=@AnaKay_id and h.depkod <>'' and m.hrk_stk_pro=1 
 and h.stktip in ('akykt','markt') and h.sil=0 
 
 
 delete from carihrk from carihrk with(nolock) where 
 (promid>0 and promid=@AnaKay_id) and (PromStkAnaid=@AnaKay_id) 
 /* fisstkhrkid=@islmid  */
 
 if (@kayok=1) and (@sil=0) 
  begin

 set @islmtip='FIS'
 set @islmhrk='FST'
 select @islmtipad=ad from islemturtip where tip=@islmtip
 select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
 


  select @newid=0
  insert into carihrk (firmano,carhrkid,gctip,
  fisstkhrkid,fisfattip,fisfatid,
  islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip_id,cartip,car_id,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm,Promid,PromStkAnaid)
  select m.firmano,@newid,'',@islmid,'PRS',m.promid,@islmtip,
  @islmtipad,@islmhrk,@islmhrkad,m.yertip,m.yerad,
  3,'gelgidkart',h.stk_id,h.stkod,(h.brmfiy*h.mik),0,
  0,m.tarih,m.saat,h.olususer,h.olustarsaat,m.vadtar,m.seri+cast(m.[no] as varchar(20)),
  m.ack,0,1,0,0,1,'',0,h.olususer,h.olustarsaat,m.sil,
  '','',m.parabrm,m.promid,m.promid  from Prom_Sat_Hrk as h with (NOLOCK)
  inner join Prom_Sat_Baslik as m with (nolock) on m.promid=h.promid
  where h.promid=@AnaKay_id and h.depkod <>'' and m.hrk_stk_pro=1 
  and h.stktip in ('gelgid') and h.sil=0 
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid
 
 
 
 end
 
return
end


/*-Prom_Puan_Hrk //giris cikis kaydi */
  if @tabload='Prom_Puan_Hrk'
   begin
 
  delete from stkhrk from stkhrk with(nolock) where tabload=@tabload 
  and (Puanid>0 and Puanid=@AnaKay_id)
 

  if (@kayok=1) and (@sil=0)
  begin
  
   select @islmtip=kod,@islmtipad=ad  from stkhrktip where 
   kod='PRSGIRCIK'

    insert stkhrk (firmano,stkhrkid,
    stk_id,stkod,tarih,saat,stktip_id,stktip,olustarsaat,olususer,
    islmtip,islmtipad,yertip,yerad,Puanid,
    giren,cikan,siademik,depkod,brmfiykdvli,kdvyuz,tabload,
    belno,ack)
    select h.firmano,h.id,
    stk_id,stkkod,tarih,saat,stktip_id,stktip,h.olustarsaat,h.olususer,
    @islmtip,@islmtipad,
    yertip,yerad,h.Puanid,
    h.mik_giren,
    h.mik_cikan,0,
    Dep_Kod,Brm_Fiyat_Kdvli*kur,
    case when Kdv_Oran>0 then Kdv_Oran/100 else Kdv_Oran end,
    @tabload,h.belno,h.ack
    from Prom_Puan_Hrk h with (nolock) where h.Puanid=@AnaKay_id
    and h.sil=0 
    end

   RETURN
  end




/*------------------------------------------------------------------------------------------- */
/*irsaliye */
if @tabload='irsaliyehrk'
 begin

  delete from stkhrk from stkhrk with(nolock) 
  where tabload=@tabload  and (irid>0 and irid=@AnaKay_id)
/*  and stkhrkid=@islmid */

 if (@kayok=1) and (@sil=0) 
 insert stkhrk (firmano,stkhrkid,stkod,tarih,saat,stktip,
 olustarsaat,olususer,
 islmtip,islmtipad,yertip,yerad,irid,giren,cikan,depkod,brmfiykdvli,
 kdvyuz,tabload,belno,ack,
 Karsi_Karttip,Karsi_KartKod)
 select m.firmano,h.id,stkod,m.tarih,m.saat,h.stktip,h.olustarsaat,h.olususer,
 m.irtip,m.irad,
 m.yertip,m.yerad,m.irid,
 case when m.gctip=1 then mik else 0 end,
 case when m.gctip=2 then mik else 0 end,
 depkod,
 ((h.brmfiy+isnull(h.otvbrim,0))-isnull(h.satisktut+h.genisktut,0))
 *(1+kdvyuz),kdvyuz,@tabload,
 irseri+cast([irno] as varchar),ack,
 m.cartip,m.carkod 
 from irsaliyehrk as h WITH (NOLOCK)
 inner join irsaliyemas as m WITH (NOLOCK) on m.irid=h.irid 
 where h.irid=@AnaKay_id and h.depkod <>'' and m.hrk_stk_pro=1
 and m.sil=0 and h.sil=0 and h.stktip in ('akykt','markt') 
 
 
 
    /*--DELETE */
    delete from carihrk from carihrk with(nolock) where 
     (irsid>0 and irsid=@AnaKay_id) and (irsStkAnaid=@AnaKay_id)
     
     
     
    set @islmtip='IRS'
    set @islmhrk='SHR'
    select @islmtipad=ad from islemturtip where tip=@islmtip
    select @islmhrkad=ad from islemhrktip where tip=@islmtip 
    and hrk=@islmhrk

    if (@kayok=1) and (@sil=0)
    begin

        select @newid=0
        insert into carihrk (firmano,carhrkid,
        gctip,fatstkhrkid,fisfattip,fisfatid,islmtip,islmtipad,
        islmhrk,islmhrkad,yertip,yerad,
        cartip_id,cartip,car_id,carkod,borc,alacak,
        bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,pro,varok,perkod,
        adaid,deguser,degtarsaat,sil,
        karsihestip,karsiheskod,parabrm,irsid,irsStkAnaid,belrap_id,
        Karsi_Karttip,Karsi_KartKod)
        select m.firmano,@newid,'',@islmid,'FAT',m.irid,@islmtip,
        @islmtipad,@islmhrk,@islmhrkad,m.yertip,m.yerad,
        3,'gelgidkart',
        h.stk_id,h.stkod,
        case when m.gctip=1 then 
        (((h.brmfiy+isnull(h.otvbrim,0))-isnull(h.satisktut+h.genisktut,0)) / 
        ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz))*h.mik
        else 0 end,
        case when m.gctip=2 then 
        (((h.brmfiy+isnull(h.otvbrim,0))-isnull(h.satisktut+h.genisktut,0)) / 
        ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz))*h.mik
        else 0 end,
        0,m.tarih,m.saat,h.olususer,h.olustarsaat,m.vadtar,m.irseri+cast(m.irno as varchar(20)),
        m.ack,0,1,0,0,1,'',0,h.olususer,h.olustarsaat,m.sil,
        '','','TL',m.irid,m.irid,m.irsrap_id,
        m.cartip,m.carkod  from irsaliyehrk as h WITH (NOLOCK)
        inner join irsaliyemas as m WITH (NOLOCK) on 
        m.irid=h.irid 
        where h.irid=@AnaKay_id 
        and h.sil=0  and m.hrk_stk_pro=1
        and h.stktip in ('gelgid')
    
        select @newid=SCOPE_IDENTITY()
        update carihrk set carhrkid=@newid where id=@newid  
        
        
     end
     
     
     
     
     
 

 end



/*-faturahrk satis */
if @tabload='faturahrk'
 begin
/*perakende fatura dan stok dusumu olmazzz...! */
/*veresiye faturadan stok dusumu olmaz.....! */

 declare @mik float
 declare @kdvyuz float
 declare @kdvsizbrmfiyat float
 declare @kdvsizgidertut float
 declare @fattip varchar(20)
 declare @fattur varchar(20)
 declare @kaptip varchar(20)
 /*declare @fatturad varchar(30) */
 declare @aliskdvsatirlitut float
 declare @satiskdvsatirlitut float
 declare @girenmik float
 declare @cikanmik float
 declare @Fat_Isk_Kart  varchar(50)
 
 set @aliskdvsatirlitut=0
 set @satiskdvsatirlitut=0

 set @girenmik=0
 set @cikanmik=0
 
 
 select @kaptip=m.kaptip from faturamas as m  WITH (NOLOCK)
 where m.fatid=@AnaKay_id
 
  if @kaptip='IRS'
      return
   
   Select @Fat_Isk_Kart=Isnull(fat_iskonto_kart,'') from Sistemtanim


   /*stok hrk işlenmesii */

   /*delete from stkhrk from stkhrk with(nolock) where tabload=@tabload  */
   /*and (fatid>0 and fatid=@AnaKay_id)  */
   /*update stkhrk Set Sil=1 Where  tabload=@tabload and Sil=0  */
   /*and (fatid>0 and fatid=@AnaKay_id)  */
   
  /* delete from stkhrk from stkhrk with(nolock) where tabload=@tabload  */
  /* and stkhrkid in (select id from faturahrk WITH (NOLOCK) where fatid=@AnaKay_id) */
  /* update stkhrk Set Sil=1 Where tabload=@tabload  and Sil=0  */
  /* and stkhrkid in (select id from faturahrk WITH (NOLOCK) where fatid=@AnaKay_id)  */


   if (@kayok=1) /*and (@sil=0) */
     begin  
     
     
      /*Update  */
     update stkhrk Set firmano=dt.firmano,sil=dt.sil,
     stk_id=dt.stk_id,stkod=dt.stkod,barkod=dt.barkod,
     tarih=dt.tarih,saat=dt.saat,
     stktip_id=dt.stktip_id,stktip=dt.stktip,
     /* degistarsaat=dt.degistarsaat,degisuser=dt.degisuser, */
     islmtip=dt.islmtip,islmtipad=dt.islmtipad,
     yertip=dt.yertip,yerad=dt.yerad,
     giren=dt.giren,cikan=dt.cikan,
     aiademik=dt.aiademik,siademik=dt.siademik,
     depkod=dt.depkod,brmfiykdvli=dt.brmfiykdvli,
     kdvyuz=dt.kdvyuz,belno=dt.belno,ack=dt.ack
     from stkhrk as t join 
      ( select h.id,m.firmano,h.sil,stk_id,stkod,h.barkod,
      m.tarih,m.saat,stktip_id,stktip,
      h.olustarsaat,h.olususer,
      m.fattip islmtip,m.fatad islmtipad,
      m.yertip,m.yerad,m.fatid,
      case when m.gctip=1 then mik*carpan else 0 end giren,
      case when m.gctip=2 then mik*carpan else 0 end cikan,
      /*@girenmik,@cikanmik, */
      /*alistan iade */
      (case when m.fattip='FATIADALS' then mik*carpan else 0 end) aiademik,
      /*satistan iade */
      (case when m.fattip='FATIADSAT' then mik*carpan else 0 end) siademik,
      depkod,
      case when (m.gctip=1) then
      ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz)
      when (m.gctip=2) and (@Fat_Isk_Kart='')  then
      ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz)
      when (m.gctip=2) and (@Fat_Isk_Kart<>'') then
      ((h.brmfiy+h.otvbrim)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz) 
      end brmfiykdvli,kdvyuz,
      fatseri+cast([fatno] as varchar) belno,m.ack ack,
      m.cartip Karsi_KartTip,m.carkod Karsi_KartKod 
      from faturahrk h WITH (NOLOCK)
      inner join faturamas m WITH (NOLOCK) on m.fatid=h.fatid 
      and m.hrk_stk_pro=1 
      and h.stktip in ('akykt','markt') where h.fatid=@AnaKay_id
      and h.id in (Select stkhrkid From stkhrk with (nolock) 
      where fatid=@AnaKay_id ) ) dt 
      on dt.id=t.stkhrkid and dt.fatid=t.fatid 
     
     
     
      /*insert  */
      insert stkhrk (firmano,stkhrkid,stk_id,stkod,barkod,tarih,saat,
      stktip_id,stktip,olustarsaat,olususer,
      islmtip,islmtipad,yertip,yerad,
      fatid,giren,cikan,aiademik,siademik,depkod,
      brmfiykdvli,kdvyuz,tabload,belno,ack,
      Karsi_Karttip,Karsi_KartKod)
      select m.firmano,h.id,stk_id,stkod,h.barkod,m.tarih,m.saat,stktip_id,
      stktip,h.olustarsaat,h.olususer,
      m.fattip,m.fatad,m.yertip,m.yerad,m.fatid,
      case when m.gctip=1 then mik*carpan else 0 end,
      case when m.gctip=2 then mik*carpan else 0 end,
      /*@girenmik,@cikanmik, */
      /*alistan iade */
      (case when m.fattip='FATIADALS' then mik*carpan else 0 end),
      /*satistan iade */
      (case when m.fattip='FATIADSAT' then mik*carpan else 0 end),
      depkod,case when (m.gctip=1) then
      ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz)
      when (m.gctip=2) and (@Fat_Isk_Kart='')  then
      ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz)
      when (m.gctip=2) and (@Fat_Isk_Kart<>'') then
      ((h.brmfiy+h.otvbrim)) / 
      ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz) 
      end,kdvyuz,@tabload,fatseri+cast([fatno] as varchar),m.ack,
      m.cartip,m.carkod from faturahrk h WITH (NOLOCK)
      inner join faturamas m WITH (NOLOCK) on m.fatid=h.fatid 
      and m.sil=0  and h.sil=0 and m.hrk_stk_pro=1 
      and h.stktip in ('akykt','markt') where h.fatid=@AnaKay_id
      and h.id not in (Select stkhrkid From stkhrk with (nolock) 
      where fatid=@AnaKay_id ) 
    
           
      /*delete  */
      update stkhrk set Sil=1 where fatid=@AnaKay_id
      and stkhrkid not in (select h.id  from faturahrk h with (nolock)
      inner join faturamas as m  with (nolock)
      on m.fatid=h.fatid  where h.fatid=@AnaKay_id) 
    
    
    end  
      
      
      
    
      

  /*--DELETE */
    delete from carihrk from carihrk with(nolock) where 
     (fatid>0 and fatid=@AnaKay_id) and (FatStkAnaid=@AnaKay_id)
     /*fatstkhrkid=@islmid */

  set @islmtip='FAT'
  set @islmhrk='SHR'
   select @islmtipad=ad from islemturtip where tip=@islmtip
   select @islmhrkad=ad from islemhrktip where tip=@islmtip 
   and hrk=@islmhrk

    if (@kayok=1) and (@sil=0)
    begin
       
        select @newid=0
        insert into carihrk (firmano,carhrkid,
        gctip,fatstkhrkid,fisfattip,fisfatid,islmtip,islmtipad,
        islmhrk,islmhrkad,yertip,yerad,
        cartip_id,cartip,car_id,carkod,borc,alacak,
        bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
        ack,varno,kur,dataok,pro,varok,perkod,
        adaid,deguser,degtarsaat,sil,
        karsihestip,karsiheskod,parabrm,fatid,FatStkAnaid,belrap_id,
        Karsi_Karttip,Karsi_KartKod)
        select m.firmano,@newid,'',@islmid,'FAT',m.fatid,@islmtip,
        @islmtipad,@islmhrk,@islmhrkad,m.yertip,m.yerad,
        3,'gelgidkart',
        h.stk_id,h.stkod,
        case when m.gctip=1 then 
        (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
        ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz))*h.mik
        else 0 end,
        case when m.gctip=2 then 
        (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) / 
        ( case when h.carpan=0 then 1 else h.carpan end )*(1+kdvyuz))*h.mik
        else 0 end,
        0,m.tarih,m.saat,h.olususer,h.olustarsaat,m.vadtar,m.fatseri+cast(m.fatno as varchar(20)),
        m.ack,0,1,0,0,1,'',0,h.olususer,h.olustarsaat,m.sil,
        '','',m.parabrm,m.fatid,m.fatid,m.fatrap_id,
        m.cartip,m.carkod  from faturahrk as h WITH (NOLOCK)
        inner join faturamas as m WITH (NOLOCK) on 
        m.fatid=h.fatid 
        /*and m.fattip  --not in ('FATPERSAT')  */
        where h.fatid=@AnaKay_id 
        and h.sil=0  and m.hrk_stk_pro=1
        and h.stktip in ('gelgid')
        
          update carihrk set carhrkid=id where FatStkAnaid=@AnaKay_id  
        
        
     end
     
     
     
     
     exec SpLog_Fatura @AnaKay_id
     exec SpLog_FaturaHareket @AnaKay_id 
     
     
     exec SpLog_FaturaUrunHareket @AnaKay_id
     
     
     
end

/*---------------------------------------------------------------------- */

/*pompacı vardiya emtia satis */
if @tabload='emtiasat'
begin

  delete from stkhrk from stkhrk with(nolock) 
  where tabload=@tabload 
  and (pomsatid>0 and pomsatid=@AnaKay_id)
  /*and stkhrkid=@islmid; */

  select @islmtip=kod,@islmtipad=ad from stkhrktip 
  where kod='POMMARSAT'

  if (@kayok=1) and (@sil=0)
  insert stkhrk (firmano,stkhrkid,pomsatid,stk_id,stkod,tarih,saat,stktip_id,stktip,
  stktipad,olustarsaat,olususer,islmtip,islmtipad,
  yertip,yerad,tabload,giren,cikan,depkod,brmfiykdvli,kdvyuz,varno,
  ack)
  select m.firmano,h.id,h.id,h.stk_id,h.stkod,
  h.tarih,h.saat,h.stktip_id,h.stktip,h.stktipad,
  h.olustarsaat,h.olususer,@islmtip,@islmtipad,
  h.yertip,h.yerad,@tabload,0,h.mik,h.depkod,h.brmfiy,
  h.kdvyuz,m.varno,m.varad
  from emtiasat as h WITH (NOLOCK)
  inner join pomvardimas as m WITH (NOLOCK)
  on m.varno=h.varno and m.sil=0 and h.sil=0
  where h.id=@islmid and h.sil=0




end

END

================================================================================
