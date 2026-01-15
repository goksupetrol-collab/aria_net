-- Trigger: dbo.pomvardimas_tri
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.998533
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_tri] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

declare @varno float,@varok int,@sil int;
declare @d_varok int;
declare @yertip varchar(20);
set @yertip='pomvardimas';

select @varno=ins.varno,@varok=ins.varok,@sil=ins.sil
from inserted as ins 


END

================================================================================
