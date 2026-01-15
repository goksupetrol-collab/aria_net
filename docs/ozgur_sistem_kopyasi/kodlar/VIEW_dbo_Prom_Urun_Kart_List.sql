-- View: dbo.Prom_Urun_Kart_List
-- Tarih: 2026-01-14 20:06:08.478157
================================================================================

CREATE VIEW [dbo].[Prom_Urun_Kart_List] AS
CREATE VIEW [dbo].Prom_Urun_Kart_List 
AS
  SELECT k.id,k.Firmano,k.tip_id,k.sil,k.kod,k.ad,k.Prom_Sat_Puan,
  k.AcMik,k.AlsFiy,k.AlsKdv,
  K.Prom_Sat_Tip,k.Prom_Kac_Satis,
  ( SELECT AD_TR FROM Prom_Urun_Sat_Tip with (nolock)
  WHERE id=K.Prom_Sat_Tip) as Sat_Tip_Ad,
  /* dbo.Fn_Prom_Urun_Sat_Tip(K.Prom_Sat_Tip) as Sat_Tip_Ad, */
  ISNULL(h.Giren_Miktar,0) Giren_Miktar,
  ISNULL(h.Cikan_Miktar,0) Cikan_Miktar,
  ISNULL(h.Mevcut_Miktar,0) Mevcut_Miktar
  from Stokkart as k with (nolock)
  left JOIN Bakiye_Prom_Urun_Miktar h with (nolock)
  on k.id=h.Stk_id and h.tip_id=k.tip_id
  where k.prom_urun=1
  union all
   SELECT k.id,k.Firmano,k.tip_id,k.sil,k.kod,k.ad,
   k.Prom_Sat_Puan,0 AcMik,k.Fiyat,k.Kdv,
   K.Prom_Sat_Tip,k.Prom_Kac_Satis,
  ( SELECT AD_TR FROM Prom_Urun_Sat_Tip  with (nolock)
  WHERE id=K.Prom_Sat_Tip) as Sat_Tip_Ad,
  /* dbo.Fn_Prom_Urun_Sat_Tip(K.Prom_Sat_Tip) as Sat_Tip_Ad, */
  ISNULL(h.Giren_Miktar,0) Giren_Miktar,
  ISNULL(h.Cikan_Miktar,0) Cikan_Miktar,
  ISNULL(h.Mevcut_Miktar,0) Mevcut_Miktar
  from gelgidkart as k with (nolock)
  left JOIN Bakiye_Prom_Urun_Miktar h with (nolock)
  on k.id=h.Stk_id and h.tip_id=3
  where k.prom_urun=1

================================================================================
