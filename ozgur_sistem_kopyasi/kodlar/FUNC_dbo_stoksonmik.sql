-- Function: dbo.stoksonmik
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.681866
================================================================================

CREATE FUNCTION dbo.stoksonmik (@depkod varchar(20),
@stktip varchar(20),@stkod varchar(20))
RETURNS float
AS
BEGIN
declare @miktar float;

if @stktip='markt'
select top 1 @miktar=sum(giren-cikan) from stkhrk as h with (NOLOCK)
where h.depkod=@depkod and h.stktip=@stktip and h.stkod=@stkod
and h.sil=0

if @stktip='akykt'
select top 1 @miktar=sum(giren-cikan) from stkhrk as h with (NOLOCK)
where h.depkod=@depkod and h.stktip=@stktip and h.stkod=@stkod
and h.sil=0


if @miktar is null
set @miktar=0

return @miktar

END

================================================================================
