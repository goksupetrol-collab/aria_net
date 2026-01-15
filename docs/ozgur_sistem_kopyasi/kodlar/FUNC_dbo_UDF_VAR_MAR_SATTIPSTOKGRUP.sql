-- Function: dbo.UDF_VAR_MAR_SATTIPSTOKGRUP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.782948
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_MAR_SATTIPSTOKGRUP
(@VARNOIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
   @TB_VAR_STOKGRP_ODEME TABLE (
    STOK_GRUP     	VARCHAR(100)  COLLATE Turkish_CI_AS,
    KDV_ORAN		FLOAT,
    SATILAN_MIK   	FLOAT,
    IADE_MIK      	FLOAT,
    NAKIT_TUT     	FLOAT,
    POS_TUT       	FLOAT,
    VER_TUT   		FLOAT)

AS
BEGIN


  DECLARE   @TB_VAR_STOKGRP TABLE (
    STOK_TIP      	VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD      	VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_ANAGRUP     	VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_ANAGRPID		INT,
    STOK_GRUP     	VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_GRPID		INT,
    KDV_ORAN		FLOAT,
    SATILAN_MIK   	FLOAT,
    IADE_MIK      	FLOAT,
    NAKIT_TUT     	FLOAT,
    POS_TUT       	FLOAT,
    VER_TUT   		FLOAT)



 /* marsatmas  */
 /*MAR GIDER */
 /*FISVERSAT VERESIYE */
 /*POS    POS */
 /*NAK    NAKİT */


 /*stoklar */
 insert into @TB_VAR_STOKGRP
 (STOK_TIP,STOK_KOD,KDV_ORAN,
 SATILAN_MIK,IADE_MIK,
 NAKIT_TUT,POS_TUT,VER_TUT)
 
 select h.stktip,h.stkod,h.kdvyuz*100,
 ISNULL(sum(case when m.islmtip='satis' then h.mik else 0 END),0),
 ISNULL(SUM(case when m.islmtip='iade' then h.mik else 0 END),0),
 ISNULL(SUM(case when m.islmtip='satis' and m.islmhrk='NAK' then  
 (h.mik*(h.brmfiy*(1-h.indyuz))) 
 when m.islmtip='iade' and m.islmhrk='NAK' then -1*(h.mik*(h.brmfiy*(1-h.indyuz))) END),0),
 ISNULL(SUM(case when m.islmtip='satis' and m.islmhrk='POS' then (h.mik*(h.brmfiy*(1-h.indyuz)))
 when m.islmtip='iade' and m.islmhrk='POS' then -1*(h.mik*(h.brmfiy*(1-h.indyuz))) END),0),
 ISNULL(SUM(case when m.islmhrk='FISVERSAT' then (h.mik*(h.brmfiy*(1-h.indyuz))) else 0 END),0)
 from marsatmas as m with (nolock)
 inner join marsathrk as h with (nolock) on h.varno=m.varno and m.marsatid=h.marsatid
 and m.varno in (select * from dbo.CsvToInt_Max(@VARNOIN))
 and m.sil=0 and h.sil=0  
 group by h.stktip,h.stkod,h.kdvyuz
 
 
 
   update @TB_VAR_STOKGRP set 
   STOK_ANAGRPID=dt.grp1,
   STOK_GRPID=dt.grpid from @TB_VAR_STOKGRP
   t join (select tip,kod,s.grp1,
   grpid=case when s.grp3>0 then s.grp3
   when s.grp2>0 then s.grp2
   when s.grp1>0 then s.grp1 end 
   from stokkart as s  with (nolock) )
   dt on t.STOK_TIP=dt.tip and t.STOK_KOD=kod
   
   
   update @TB_VAR_STOKGRP set STOK_GRUP=dt.ad from @TB_VAR_STOKGRP
   t join (select id,ad from grup with (nolock) )
   dt on t.STOK_GRPID=dt.id 
 
 
  
  insert into @TB_VAR_STOKGRP_ODEME
   (STOK_GRUP,KDV_ORAN,
    SATILAN_MIK,IADE_MIK,
    NAKIT_TUT,POS_TUT,VER_TUT) 
   select STOK_GRUP,KDV_ORAN,
    SUM(SATILAN_MIK),SUM(IADE_MIK),
    SUM(NAKIT_TUT),SUM(POS_TUT),
    SUM(VER_TUT)
    FROM @TB_VAR_STOKGRP
    group by STOK_GRUP,KDV_ORAN 
 

RETURN

END

================================================================================
