-- Trigger: dbo.stkhrk_trd
-- Tablo: dbo.stkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.031421
================================================================================

CREATE TRIGGER [dbo].[stkhrk_trd] ON [dbo].[stkhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @say int
declare @idx float
declare @stkod varchar(30),@islmtip varchar(10),
@stktip varchar(20),@depkod varchar(30),
@giren float,@cikan float,@tarx datetime

DECLARE stokhrksilx CURSOR LOCAL FOR SELECT id,stkod,islmtip,stktip,depkod,giren,cikan,olustarsaat
from deleted
 OPEN stokhrksilx
  FETCH NEXT FROM stokhrksilx INTO  @idx,@stkod,@islmtip,@stktip,@depkod,@giren,@cikan,@tarx
  WHILE @@FETCH_STATUS <> -1
  BEGIN

if @idx is not null
  begin

    
    if  (@islmtip='FATAKALS') or (@islmtip='FATMRALS') 
     OR (@islmtip='IRSAKALS') or (@islmtip='IRSMRALS') 
     or (@islmtip='FATYGALS') or (@islmtip='KARTAC')
     UPDATE stokkart  SET
     ortalsfiykdvli=DT.ortalsfiy,
     alsfiy=isnull((select top 1 case when k.alskdvtip='Dahil' then 
      brmfiykdvli else (brmfiykdvli/(1+kdvyuz)) end
     from stkhrk as h with (nolock) 
     inner join stokkart as k with(nolock) on 
     k.kod=h.stkod and k.tip=h.stktip
     where h.stkod=@stkod and h.stktip=@stktip
     and h.brmfiykdvli>0
     and h.sil=0 and islmtip in 
     ('KARTAC','FATAKALS','FATMRALS',
     'IRSAKALS','IRSMRALS','FATYGALS')
     order by h.tarih desc),alsfiy)
     from stokkart as t  JOIN
     (select h.stkod,h.stktip,
     isnull(case when sum((h.giren-(h.aiademik+h.siademik))) >0  then
     sum((h.giren-(h.aiademik+h.siademik))*brmfiykdvli)
     / sum((h.giren-(h.aiademik+h.siademik)))
     else 0 end,0)   as ortalsfiy
     from stkhrk as h with (nolock) where h.stkod=@stkod and h.stktip=@stktip
     and h.sil=0 group by h.stkod,h.stktip ) DT on
     DT.stkod=T.kod AND DT.stktip=T.tip
     
     
     



end

FETCH NEXT FROM stokhrksilx INTO  @idx,@stkod,@islmtip,@stktip,@depkod,@giren,@cikan,@tarx
END
CLOSE stokhrksilx
DEALLOCATE stokhrksilx

END

================================================================================
