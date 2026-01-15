-- Stored Procedure: dbo.sayimonayla
-- Tarih: 2026-01-14 20:06:08.364405
================================================================================

CREATE PROCEDURE [dbo].sayimonayla @sayid float,@drm varchar(5)
AS
BEGIN
declare @islmtip varchar(20)
declare @islmtipad varchar(30)
declare @islmtip1 varchar(20)
declare @islmtipad1 varchar(30)

declare @tabload varchar(30)

set @tabload='sayimhrk'

 
 delete from stkhrk where tabload=@tabload
 and stkhrkid in (select id from sayimhrk as h with (nolock) where h.sayid=@sayid)
 
 if @drm='B'
    RETURN

   select @islmtip=kod,@islmtipad=ad from stkhrktip where kod='SAYSON'

   insert stkhrk (Firmano,stkhrkid,sayid,stkod,tarih,saat,stktip,olustarsaat,olususer,islmtip,islmtipad,
   yertip,yerad,giren,cikan,depkod,brmfiykdvli,kdvyuz,tabload,belno,ack)
 
   select mas.firmano,h.id,h.sayid,stkod,
   case when h.OnlineSayimTarihSaat is null then  mas.onaytarih
   else CONVERT(varchar(10), h.OnlineSayimTarihSaat, 121) end,
   case when h.OnlineSayimTarihSaat is null then mas.onaysaat 
   else CONVERT(varchar(8), h.OnlineSayimTarihSaat, 108) end,
   stktip,h.olustarsaat,h.olususer,@islmtip,@islmtipad,mas.yertip,mas.yerad,
   case when (h.sayimmik-h.mevcutmik)>0 then abs(h.sayimmik-h.mevcutmik) else 0 end,
   case when (h.sayimmik-h.mevcutmik)<0 then abs(h.sayimmik-h.mevcutmik) else 0 end,
   h.depkod,brmfiy,kdvyuz,@tabload,cast(h.sayid as varchar(20)),
   mas.onayack from sayimhrk as h  with (nolock)
   inner join sayimmas as mas on mas.sayid=h.sayid and mas.sayid=@sayid
   and abs(h.sayimmik-h.mevcutmik)>0

END

================================================================================
