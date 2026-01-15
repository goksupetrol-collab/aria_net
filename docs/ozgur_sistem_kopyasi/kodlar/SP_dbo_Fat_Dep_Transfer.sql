-- Stored Procedure: dbo.Fat_Dep_Transfer
-- Tarih: 2026-01-14 20:06:08.322972
================================================================================

CREATE PROCEDURE [dbo].Fat_Dep_Transfer (
@Fatid int,
@Sil   int)
AS
BEGIN

  DECLARE @islmtip varchar(50)
  DECLARE @islmtipad varchar(50)
  
  
  if @Sil=1
   begin
    delete from stkhrk where tabload='fat_dep' and FatDep_id=@Fatid
    RETURN
   end 
  
  
  set @islmtip='FATSTKTRS'
  
  select  @islmtipad=ad from stkhrktip WITH (NOLOCK) where kod=@islmtip
 

  delete from stkhrk where tabload='fat_dep' and FatDep_id=@Fatid

   
  /*cikis deposu */
  insert Stkhrk (Firmano,stkhrkid,tabload,stkod,belno,ack,tarih,saat,
  stktip,olustarsaat,olususer,islmtip,islmtipad,
  yertip,yerad,giren,cikan,depkod,brmfiykdvli,kdvyuz,FatDep_id)
  
  select d.cfirmano,d.id,'fat_dep',
  d.CStk_kod,d.belno,d.ack,d.tarih,d.saat,
  d.CStktip,d.olustarsaat,d.olususer,@islmtip,@islmtipad,
  d.yertip,d.yerad,0,(miktar),d.Cdepkod,
  ((f.brmfiy+f.otvbrim)-(f.satisktut+f.genisktut)) / 
  ( case when f.carpan=0 then 1 else f.carpan end )*(1+f.kdvyuz),
  f.kdvyuz,@Fatid
  
  from Fat_Dep as d WITH (NOLOCK) inner join 
  faturahrk as f WITH (NOLOCK) on f.fatid=d.fatid 
  and f.sil=0 and d.sil=0 and f.fatid=@Fatid
  and d.Miktar>0 and f.id=d.fathrk_id


  /*giris deposu */

  insert stkhrk (Firmano,stkhrkid,tabload,stkod,belno,ack,tarih,saat,
  stktip,olustarsaat,olususer,islmtip,islmtipad,
  yertip,yerad,giren,cikan,depkod,brmfiykdvli,kdvyuz,FatDep_id)
  
  select d.gfirmano,d.id,'fat_dep',
  d.gStk_kod,d.belno,d.ack,d.tarih,d.saat,
  d.gStktip,d.olustarsaat,d.olususer,@islmtip,@islmtipad,
  d.yertip,d.yerad,(miktar),0,d.gdepkod,
  ((f.brmfiy+f.otvbrim)-(f.satisktut+f.genisktut)) / 
  ( case when f.carpan=0 then 1 else f.carpan end )*(1+f.kdvyuz),
  f.kdvyuz,@Fatid
  
  from Fat_Dep as d WITH (NOLOCK) inner join 
  faturahrk as f WITH (NOLOCK) on f.fatid=d.fatid 
  and f.sil=0 and d.sil=0 and f.fatid=@Fatid
  and d.Miktar>0 and f.id=d.fathrk_id
 


END

================================================================================
