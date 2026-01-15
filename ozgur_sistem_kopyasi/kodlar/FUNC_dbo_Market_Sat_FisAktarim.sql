-- Function: dbo.Market_Sat_FisAktarim
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.665042
================================================================================

CREATE FUNCTION [dbo].Market_Sat_FisAktarim (
@marsatid int)
RETURNS
@TB_MARKET_ODEME TABLE (
    tip                  VARCHAR(10) COLLATE Turkish_CI_AS,
    hrk_id               float)
AS
BEGIN



    insert into @TB_MARKET_ODEME (tip,hrk_id)
    select 'poshrk',poshrkid from poshrk with (nolock) 
    where sil=0 and marsatid=@marsatid
    and aktip in ('AK')
      
    insert into @TB_MARKET_ODEME (tip,hrk_id)
    select 'veresimas',verid from veresimas with (nolock) 
    where sil=0 and marsatid=@marsatid
    and aktip in ('FT','CH')
    
    
 RETURN

END

================================================================================
