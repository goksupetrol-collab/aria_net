-- Stored Procedure: dbo.stokbakiye
-- Tarih: 2026-01-14 20:06:08.382441
================================================================================

CREATE PROCEDURE [dbo].stokbakiye @id float
AS
BEGIN


  DECLARE @kalan           float
  declare @idx              float
  declare @giren            float
  declare @cikan            float
  declare @stktip varchar(20),@depkod varchar(20),@stkod varchar(20)
/*
  select @stktip=stktip,@depkod=depkod,@stkod=stkod from stkhrk where id=@id
  

    select @kalan=isnull(sum(giren-cikan),0) from stkhrk where depkod=@depkod and stktip=@stktip and
    stkod=@stkod and id< @id;

    set @kalan=isnull(@kalan,0);


  DECLARE stokbakiyeduz CURSOR FAST_FORWARD FOR
    SELECT id,giren,cikan FROM stkhrk WHERE depkod=@depkod and stktip=@stktip and
    stkod=@stkod and id >= @id order by id

  OPEN stokbakiyeduz

  FETCH NEXT FROM stokbakiyeduz INTO @idx,@giren,@cikan
  WHILE @@FETCH_STATUS = 0
  BEGIN

   update stkhrk set kalan=@kalan+(@giren-@cikan),pro=0 where id=@idx

   set @kalan=@kalan+(@giren-@cikan);


    FETCH NEXT FROM stokbakiyeduz  INTO @idx,@giren,@cikan
  END

  CLOSE stokbakiyeduz
  DEALLOCATE stokbakiyeduz

*/




END

================================================================================
