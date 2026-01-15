-- View: dbo.__Son_Cek_Hrk
-- Tarih: 2026-01-14 20:06:08.452676
================================================================================

CREATE VIEW [dbo].[__Son_Cek_Hrk] AS
CREATE VIEW dbo.__Son_Cek_Hrk 
As
SELECT t.cekid,t.drm drm,(t.tarih+t.Saat) as tarih,son_id = t.id
  FROM cekhrk t WITH (NOLOCK) JOIN 
  (SELECT cekid,MAX(id) as cekhrkid FROM cekhrk WITH (NOLOCK) 
  GROUP BY cekid) AS u ON
 t.cekid = u.cekid and t.id=u.cekhrkid

================================================================================
