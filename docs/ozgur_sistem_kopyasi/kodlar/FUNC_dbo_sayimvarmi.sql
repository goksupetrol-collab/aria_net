-- Function: dbo.sayimvarmi
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.671378
================================================================================

CREATE FUNCTION dbo.sayimvarmi(
@firmano	int,
@depkod 	varchar(20),
@stktip 	varchar(10),
@stkod 		varchar(20))
RETURNS int
AS
BEGIN
 declare @sayid 	int
 declare @sonuc 	int
 declare @SayimKont int
 
   set @sonuc=0
 
  select @SayimKont=isnull(SayimKont,0) From sistemtanim
  

  
  if @SayimKont=1
   select @sayid=count(h.sayid) from sayimhrk as h with (NOLOCK)
    inner join sayimmas as m with (NOLOCK) on m.sayid=h.sayid
    and h.depkod=@depkod and h.saydrm='B'
    and h.stkod=@stkod and h.stktip=@stktip and m.drm='B' 
    and m.sil=0

   if @sayid>0
    set @sonuc=1



 RETURN @sonuc



END

================================================================================
