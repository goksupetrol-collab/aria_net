-- View: dbo.___Son_Car_Alc_Hrk
-- Tarih: 2026-01-14 20:06:08.451088
================================================================================

CREATE VIEW [dbo].[___Son_Car_Alc_Hrk] AS
CREATE VIEW [dbo].___Son_Car_Alc_Hrk
AS

  SELECT t.cartip,t.carkod,son_id = MAX(t.id)
  FROM carihrk t
   JOIN (SELECT cartip,carkod,
   max(tarih+cast(saat as datetime)) as tarih
  FROM carihrk where ISDATE(saat)=1 and sil=0 
  and alacak>0
GROUP BY cartip,carkod) AS u ON
 t.cartip = u.cartip
 AND t.carkod = u.carkod and ISDATE(saat)=1
 and t.tarih+cast(saat as datetime)=u.tarih
GROUP BY t.cartip,t.carkod

================================================================================
