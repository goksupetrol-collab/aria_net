-- Trigger: dbo.stkdeptrs_tru
-- Tablo: dbo.stkdeptrs
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.028871
================================================================================

CREATE TRIGGER [dbo].[stkdeptrs_tru] ON [dbo].[stkdeptrs]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN


declare @sil int
declare @id float
declare @stktrsid float
declare @trsid   float


select @sil=sil,@id=id,@stktrsid=stktrsid,@trsid=trs_id from inserted;


if UPDATE(sil) and (@sil=1)
 begin
 
  delete from stkhrk where  tabload='stkdeptrs' 
  /*and DeptrsId=@trsid */
   and stkhrkid in (Select stktrsid From stkdeptrs Where Trs_id=@trsid)
  delete from sayachrk where islmid=@stktrsid and islmtip='YAGDOK'
 
 /*yeni */
  update stkhrk set Sil=1 where isnull(deptrshrkId,0)>0  and  deptrshrkId in 
  (select id from inserted Where sil=1 and Trs_id=@trsid and yertip='deptrsislem')
  
 
 
 end


if (@sil=0)
 begin
 
 /*stkhrkid=@stktrsid and */
 delete from stkhrk where  tabload='stkdeptrs' and DepTrsId=@trsid
  /*stkhrkid in (Select stktrsid From stkdeptrs Where Trs_id=@trsid) */

  delete from sayachrk where islmid=@stktrsid and islmtip='YAGDOK'
 
 update stkdeptrs set  stktrsid=id where 
 trs_id=@trsid and stktrsid=0
 
  /*cikis deposu */
  insert stkhrk (firmano,stkhrkid,DepTrsId,DepTrsHrkId,
  tabload,stkod,belno,ack,tarih,saat,stktip,
  olustarsaat,olususer,islmtip,islmtipad,
  yertip,yerad,giren,cikan,depkod,brmfiykdvli,kdvyuz)
  select m.cfirmano,h.stktrsid,h.trs_id,h.id,'stkdeptrs',h.stkod,h.belno,m.ack,
  h.tarih,h.saat,h.stktip,
  h.olustarsaat,h.olususer,h.islmtip,h.islmtipad,
  h.yertip,h.yerad,0,(h.miktar*h.carpan),
  h.cikdepkod,h.brmfiykdvli,h.kdvyuz
  from stkdeptrs  as h with (nolock)
  inner join stkdeptrsmas as m with (nolock) on m.id=h.trs_id
  where h.trs_id=@trsid and h.Sil=0

  /*giris deposu */
  
  insert stkhrk (firmano,stkhrkid,DepTrsId,DepTrsHrkId,tabload,stkod,belno,ack,
  tarih,saat,stktip,olustarsaat,olususer,islmtip,islmtipad,
  yertip,yerad,giren,cikan,depkod,brmfiykdvli,kdvyuz)
  select m.gfirmano,h.stktrsid,h.trs_id,h.id,'stkdeptrs',
  h.girstkod,h.belno,m.ack,m.tarih,m.saat,h.girstktip,h.olustarsaat,h.olususer,
  h.islmtip,h.islmtipad,
  h.yertip,h.yerad,case when h.gircarpan>0 then ((h.miktar*h.carpan)/h.gircarpan) else h.miktar end,
  0,h.girdepkod,case when h.gircarpan>0 then
  (h.brmfiykdvli*h.carpan)/(h.carpan/h.gircarpan) else h.brmfiykdvli end,
  h.kdvyuz from stkdeptrs  as h with (nolock)
  inner join stkdeptrsmas as m with (nolock) on m.id=h.trs_id
  where h.trs_id=@trsid and h.Sil=0
  
  
  update stkhrk set stkhrkid=id where DepTrsId=@trsid  
  
  
  end
END

================================================================================
