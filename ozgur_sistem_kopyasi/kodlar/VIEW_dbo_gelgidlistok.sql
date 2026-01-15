-- View: dbo.gelgidlistok
-- Tarih: 2026-01-14 20:06:08.471455
================================================================================

CREATE VIEW [dbo].[gelgidlistok] AS
CREATE VIEW [dbo].gelgidlistok
AS
  SELECT id,Tip_id,kod,tip,ad,
  stktur=case when tip='akykt' then 
  'Akaryakıt' else 'Market' end,
  brim,sat1kdv,sat1kdvtip,sat1fiy,sat2kdv,sat2kdvtip,sat2fiy,
  grp1,grp2,grp3,Gtip,
  muhonkod,muhgrskod,muhckskod from stokkart as s with (nolock)
  union all
  SELECT id,Tip_id,kod,('gelgid')tip,ad,('Gelir-Gider') stktur,
  brim,kdv,kdvtip,fiyat,kdv,kdvtip,fiyat, 
  grp1,grp2,grp3,'' Gtip,
  muhonkod,muhkod muhgrskod,muhkod muhckskod
  from gelgidkart with (nolock)

================================================================================
