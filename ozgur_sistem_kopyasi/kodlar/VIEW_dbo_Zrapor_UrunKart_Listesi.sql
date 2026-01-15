-- View: dbo.Zrapor_UrunKart_Listesi
-- Tarih: 2026-01-14 20:06:08.491294
================================================================================

CREATE VIEW [dbo].[Zrapor_UrunKart_Listesi] AS
CREATE VIEW [dbo].Zrapor_UrunKart_Listesi
AS

 SELECT firmano,kod,ad,sat1kdv as kdv,('akykt') tip,1 tip_id,
  case when sat1kdvtip='Dahil' then sat1fiy 
  else sat1fiy*(1+(sat1kdv/100)) end brimfiy,K.brim,
  isnull(k.muhonkod,'') as muhonkod,k.muhgrskod,k.muhckskod  
  from stokkart as k  with (nolock) where k.tip='akykt' and k.sil=0
  union
  SELECT firmano,cast(id as varchar(20))kod,cast(ad as varchar(100)),kdv,
  ('markt')tip,2 tip_id,
  0 brimfiy,'AD' brim,
  isnull(k.muhonkod,'') muhonkod,k.muhgrskod,k.muhckskod   
  from grup as k with (nolock) where k.tabload='markgrp' and k.sil=0

================================================================================
