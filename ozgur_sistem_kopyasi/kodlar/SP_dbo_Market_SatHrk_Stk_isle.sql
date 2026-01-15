-- Stored Procedure: dbo.Market_SatHrk_Stk_isle
-- Tarih: 2026-01-14 20:06:08.345235
================================================================================

CREATE PROCEDURE [dbo].Market_SatHrk_Stk_isle (
@marsatid float,@kayok int,@sil int)
AS
BEGIN

declare @islmtip varchar(20)
declare @islmtipad varchar(30)
declare @islmtip1 varchar(20);
declare @islmtipad1 varchar(30);
declare @tabload   varchar(20)

/*market satıs stok isle */
  if @sil=0 and @kayok=1
   begin
   set @tabload='marsathrk'
   
   delete from stkhrk where tabload=@tabload
   and stkhrkid in (select id from marsathrk as mh where
   mh.marsatid=@marsatid and mh.kayok=1)
   
   select @islmtip=kod,@islmtipad=ad from stkhrktip where kod='MARSAT'
   select @islmtip1=kod,@islmtipad1=ad from stkhrktip where kod='MARIAD'

   insert stkhrk (stkhrkid,stkod,tarih,saat,stktip,stktipad,olustarsaat,olususer,islmtip,islmtipad,
   yertip,yerad,giren,cikan,siademik,depkod,brmfiykdvli,kdvyuz,tabload,belno)
   select mh.id,stkod,tarih,saat,stktip,stktipad,
   mh.olustarsaat,mh.olususer,case when islmtip='iade' then
   @islmtip1 else @islmtip end,
   case when islmtip='iade' then @islmtipad1 else @islmtipad end,
   yertip,yerad,case when islmtip='iade' then mik else 0 end,
   case when islmtip='satis' then mik else 0 end,
   case when islmtip='iade' then mik else 0 end,
   depkod,brmfiy*kur,kdvyuz,@tabload,cast(marsatid as varchar)
   from marsathrk  as mh where mh.marsatid=@marsatid and mh.kayok=1

   end
   
   /*market satıs stok sil */
   if @sil=1 and @kayok=1
   begin
   set @tabload='marsathrk'

   delete from stkhrk where tabload=@tabload
   and stkhrkid in (select id from marsathrk as mh where
   mh.marsatid=@marsatid and mh.kayok=1)
   end
   

   update stokkart set
   alsmik=dt.giren,
   alskdvlitoptut=dt.alistoptut,
   satmik=dt.cikan,
   satkdvlitoptut=dt.satistoptut,
   alsiademik=dt.alsiade,
   alsiadekdvlitoptut=dt.alsiadekdvtoptut,
   satiademik=dt.satiade,
   satiadekdvlitoptut=dt.satiadekdvtoptut
   from stokkart as t
   JOIN (select s.stktip,s.stkod,
   isnull(sum(s.giren),0) as giren,
   isnull(sum(s.giren*s.brmfiykdvli),0) alistoptut,
   isnull(sum(s.cikan),0) as cikan,
   isnull(sum(s.cikan*s.brmfiykdvli),0) as satistoptut,
   /*-aide miktar */
   isnull(sum(s.aiademik),0) as alsiade,
   isnull(sum(s.aiademik*s.brmfiykdvli),0) alsiadekdvtoptut,
   isnull(sum(s.siademik),0) as satiade,
   isnull(sum(s.siademik*s.brmfiykdvli),0) as satiadekdvtoptut
   from stkhrk as s inner join marsathrk as mh on
   s.stktip=mh.stktip and s.stkod=mh.stkod and s.sil=0
   and mh.marsatid=@marsatid and mh.kayok=1
   group by s.stktip,s.stkod ) dt
   on t.kod=dt.stkod and t.tip=dt.stktip
 
  
END

================================================================================
