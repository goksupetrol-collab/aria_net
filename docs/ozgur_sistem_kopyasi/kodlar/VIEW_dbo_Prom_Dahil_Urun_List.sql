-- View: dbo.Prom_Dahil_Urun_List
-- Tarih: 2026-01-14 20:06:08.476842
================================================================================

CREATE VIEW [dbo].[Prom_Dahil_Urun_List] AS
create VIEW [dbo].Prom_Dahil_Urun_List 
AS
  SELECT p.id,P.Firmano,k.id as Stk_id,k.kod,k.ad,k.tip,k.tip_id,p.sil,
  P.grp1,
  (SELECT ack_Tr FROM Stk_Tip with (nolock) WHERE id=k.Tip_id) as Stok_Tip_Ad,
  p.Puan_Tip,p.Puan_Brm,p.Puan_Otomas,p.Puan_Otomas2,
  p.Puan_Nakit,p.Puan_kk,p.Puan_Fis,
  (SELECT AD_TR FROM Prom_Urun_Puan_Tip with (nolock) WHERE id=p.Puan_Tip)
  as Puan_Tip_Ad,
    
  case when k.sat1kdvtip='Dahil' then 
  k.sat1fiy else k.sat1fiy*(1+(k.sat1kdv/100)) end
   as Sat_Fiy_kdvli
    
  from stokkart as k with (nolock) inner join Prom_Urun_Puan  as p with (nolock)
  on k.id=p.Urun_id and k.tip_id=p.Urun_tip_id

================================================================================
