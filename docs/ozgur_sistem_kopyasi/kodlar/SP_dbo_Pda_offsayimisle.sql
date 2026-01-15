-- Stored Procedure: dbo.Pda_offsayimisle
-- Tarih: 2026-01-14 20:06:08.352291
================================================================================

CREATE PROCEDURE [dbo].Pda_offsayimisle
@sayid           float,
@offsayid        int,
@tarih           datetime,
@users           varchar(50)
AS
BEGIN



 update sayimhrk set sayimmik=sayimmik+dt.miktar,
 saydrm='S' from sayimhrk t join
 (select stk_kod,miktar from
 Pda_OffSayim_Hrk where offsayid=@offsayid  )
 as dt on t.stkod=dt.stk_kod
 and t.sayid=@sayid
 
 
 update Pda_OffSayim_Mas set
       drm='OK',
       aktarid=@sayid,
       aktartarsaat=@tarih,
       aktaruser=@users
    where id=@offsayid
    
    
    
 select stk_barkod as barkod,('YOK') as stokad,miktar
 from Pda_OffSayim_Hrk
 where offsayid=@offsayid and stk_kod not in
 (select stkod from sayimhrk where sayid=@sayid)




END

================================================================================
