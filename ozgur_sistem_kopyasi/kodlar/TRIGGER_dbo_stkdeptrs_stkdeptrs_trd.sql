-- Trigger: dbo.stkdeptrs_trd
-- Tablo: dbo.stkdeptrs
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.028506
================================================================================

CREATE TRIGGER [dbo].[stkdeptrs_trd] ON [dbo].[stkdeptrs]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @idx      float
declare @stktrsid float

declare @stkod varchar(30),@islmtip varchar(10),
@stktip varchar(20),@cikdepkod varchar(30),@girdepkod varchar(30),
@miktar float,@tarx datetime


  select @stktrsid=stktrsid,@idx=id,@stkod=stkod,@stktip=stktip,
  @cikdepkod=cikdepkod,@girdepkod=girdepkod,@miktar=miktar,@tarx=olustarsaat from deleted;

   delete from stkhrk where DepTrsHrkId=@stktrsid and tabload='stkdeptrs'


   delete from sayachrk where islmid=@stktrsid and islmtip='YAGDOK'


END

================================================================================
