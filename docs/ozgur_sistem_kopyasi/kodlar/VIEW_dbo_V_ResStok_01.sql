-- View: dbo.V_ResStok_01
-- Tarih: 2026-01-14 20:06:08.487030
================================================================================

CREATE VIEW [dbo].[V_ResStok_01] AS
CREATE VIEW [dbo].[V_ResStok_01] AS
SELECT sk.id AS Id, sk.tip_id AS TipId, sk.firmano AS FirmaNo, 
      CASE WHEN sk.grp3 > 0 THEN sk.grp3 WHEN sk.grp2 > 0 THEN sk.grp2 WHEN sk.grp1 > 0 THEN sk.grp1 END AS GrupId,
	   sk.kod AS Kod, sk.ad AS Ad, 1 AS FiyNo, sk.sat1kdv AS SatKdv, sk.sat1pbrm AS ParaBrm,
		CASE WHEN sk.sat1kdvtip = 'Dahil' THEN 1 ELSE 0 END AS SatKdvTip, sk.sat1kdvtip AS SatKdvTipAd,
		ROUND(CASE WHEN sk.sat1kdvtip = 'Dahil' THEN sk.sat1fiy ELSE sk.sat1fiy * (1 + (sk.sat1kdv / 100)) END, 2) AS SatFiy,
        sk.brim AS Birim,
        case when (Select top 1 id From Stok_Recete  with (nolock)  
        Where Urun_id=sk.id and Sil=0 )>0 then 1 else 0 end Receteli
FROM stokkart AS sk with (nolock) 
WHERE ISNULL(sk.sil, 0) = 0 AND sk.tip_id = 2 and isnull(sk.Restaurant,0)=1
UNION ALL
SELECT sk.id AS Id, sk.tip_id AS TipId, sk.firmano AS FirmaNo,
       CASE WHEN sk.grp3 > 0 THEN sk.grp3 WHEN sk.grp2 > 0 THEN sk.grp2 WHEN sk.grp1 > 0 THEN sk.grp1 END AS GrupId,
	   sk.kod AS Kod, sk.ad AS Ad, sf.FiyNo, sf.Kdv AS SatKdv, sf.ParaBrm,
	   sf.KdvTip AS SatKdvTip, CASE WHEN sf.KdvTip=0 then 'Hariç' ELSE 'Dahil' END AS SatKdvTipAd,
	   ROUND(CASE sf.KdvTip WHEN 1 THEN sf.Fiyat ELSE sf.Fiyat * (1 + (sf.Kdv / 100)) END, 2) AS SatFiy, sk.brim AS Birim,
        case when (Select top 1 id From Stok_Recete  with (nolock)  
        Where Urun_id=sk.id and Sil=0 )>0 then 1 else 0 end Receteli
 FROM stokkart AS sk with (nolock)  INNER JOIN
	Stok_fiyat AS sf with (nolock)  
    ON sk.tip_id = sf.Stktip_id AND sk.id = sf.Stk_id AND sf.FiyTip = 2 AND sf.FiyNo=1 AND sk.firmano=sf.FirmaNo
WHERE ISNULL(sk.sil, 0) = 0 AND sk.tip_id = 2  and isnull(sk.Restaurant,0)=1

================================================================================
