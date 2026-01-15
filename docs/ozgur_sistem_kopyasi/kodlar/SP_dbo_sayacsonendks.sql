-- Stored Procedure: dbo.sayacsonendks
-- Tarih: 2026-01-14 20:06:08.363439
================================================================================

CREATE PROCEDURE [dbo].sayacsonendks @sayackod varchar(20)
AS
BEGIN
declare @sonendks float
declare @sonmekendks float

select top 1
@sonendks=isnull(sonendks,0),
@sonmekendks=isnull(sonmekendks,0)
 from sayachrk as mas
where mas.sayackod=@sayackod and mas.sil=0 order by mas.id  desc

update sayackart set
     sonendks=@sonendks,
     sonmekendks=@sonmekendks
     where kod=@sayackod

END

================================================================================
