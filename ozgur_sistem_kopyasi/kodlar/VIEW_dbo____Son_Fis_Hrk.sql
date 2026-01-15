-- View: dbo.___Son_Fis_Hrk
-- Tarih: 2026-01-14 20:06:08.451982
================================================================================

CREATE VIEW [dbo].[___Son_Fis_Hrk] AS
CREATE VIEW [dbo].___Son_Fis_Hrk
AS
  
 SELECT t.cartip,t.carkod,son_id = MAX(t.id)
  FROM veresimas t WITH (NOLOCK)
   JOIN (SELECT cartip,carkod,
   max(tarih+cast(saat as datetime)) as tarih
  FROM veresimas WITH (NOLOCK) WHERE sil=0
GROUP BY cartip,carkod) AS u ON
 t.cartip = u.cartip
 AND t.carkod = u.carkod
 and t.tarih+cast(saat as datetime)=u.tarih
 and t.sil=0
GROUP BY t.cartip,t.carkod

================================================================================
