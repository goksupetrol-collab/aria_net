-- Stored Procedure: dbo.siparisisle
-- Tarih: 2026-01-14 20:06:08.364658
================================================================================

CREATE PROCEDURE [dbo].siparisisle @fatid float
AS
BEGIN
declare @fattip varchar(10)

if (select top 1 kaptip from faturamas where fatid=@fatid)='SIP'
update siparishrk set tesmik=isnull(dt.tesmik,0) from siparishrk t join
(select kaphrkid,sum(mik) as tesmik from faturahrk where sil=0 and kayok=1
and fatid=@fatid and kaptip='SIP' group by kaphrkid) dt on
t.id=dt.kaphrkid

/*------------------------------------------------------------------------------------------ */

END

================================================================================
