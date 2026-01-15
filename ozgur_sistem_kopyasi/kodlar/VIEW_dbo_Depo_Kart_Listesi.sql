-- View: dbo.Depo_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.468850
================================================================================

CREATE VIEW [dbo].[Depo_Kart_Listesi] AS
CREATE VIEW [dbo].Depo_Kart_Listesi
AS
  SELECT k.id,1 Tip_id,('tank') as tip,'TANK KART' AS tipad,
  k.firmano,k.kod,
  k.ad,k.stktip,k.bagak,k.sil,k.drm,'1-'+Cast(K.id as varchar(5)) 
  as TipID  from tankkart as k
  union
  SELECT k.id,2 Tip_id,('markt') as tip,'MARKET KART' AS tipad,
  k.firmano,k.kod,
  k.ad,('markt') as stktip,('') as bagak,k.sil,k.drm,
  '2-'+Cast(K.id as varchar(5)) as TipID  from depokart as k

================================================================================
