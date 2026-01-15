-- Trigger: dbo.sayimstkgrp_tru
-- Tablo: dbo.sayimstkgrp
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.021922
================================================================================

CREATE TRIGGER [dbo].[sayimstkgrp_tru] ON [dbo].[sayimstkgrp]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

declare @sayid float
declare @id float
declare @stgrp1id int
declare @stgrp2id int
declare @stgrp3id int

 select @sayid=sayid,@id=id,
 @stgrp1id=stkgrp1,
 @stgrp2id=stkgrp2,
 @stgrp3id=stkgrp3
 from inserted;

exec sayimgiris @sayid,@stgrp1id,@stgrp2id,@stgrp3id


END

================================================================================
