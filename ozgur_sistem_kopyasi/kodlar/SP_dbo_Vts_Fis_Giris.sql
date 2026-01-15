-- Stored Procedure: dbo.Vts_Fis_Giris
-- Tarih: 2026-01-14 20:06:08.389739
================================================================================

CREATE PROCEDURE [dbo].Vts_Fis_Giris (@vtsid float,@sil int)
AS
BEGIN

if @sil=0
update otomasonlineoku set
aktarid=dt.verid,
sattip=dt.sattip,
cartip=dt.cartip,
carkod=dt.carkod,
carad=dt.carad
from otomasonlineoku as t join
(select verid,'Veresiye' as sattip,cartip,carkod,k.ad as carad
from veresimas as v with (nolock) inner join Genel_Kart as k 
on k.cartp=v.cartip and k.kod=v.carkod where v.varno=0 and 
v.vtsid=@vtsid and v.sil=0) 
dt on otomasid=@vtsid and varno=0

if @sil=1
update otomasonlineoku set
aktarid=0,sattip='Nakit',cartip='',carkod='',carad=''
from otomasonlineoku where otomasid=@vtsid



END

================================================================================
