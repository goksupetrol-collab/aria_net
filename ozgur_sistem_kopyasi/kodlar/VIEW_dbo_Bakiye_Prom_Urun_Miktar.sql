-- View: dbo.Bakiye_Prom_Urun_Miktar
-- Tarih: 2026-01-14 20:06:08.465942
================================================================================

CREATE VIEW [dbo].[Bakiye_Prom_Urun_Miktar] AS
CREATE VIEW [dbo].Bakiye_Prom_Urun_Miktar 
AS

  SELECT k.id as Stk_id,k.tip_id,
  ISNULL(sum(h.Giren),0) as Giren_Miktar,
  ISNULL(sum(h.Cikan),0) as Cikan_Miktar,
  ISNULL(sum(h.Giren-h.Cikan),0) as Mevcut_Miktar
  from stokkart as k
  left join stkhrk as h 
  on h.stktip=k.tip and h.stkod=k.kod 
  and h.sil=0 
  and h.depkod=
  (select top 1 kod from depokart where id= 
  (select top 1 Prom_Depo from sistemtanim) )
  where k.Prom_Urun=1
  group by k.id,k.tip_id
   union all
  SELECT k.id as Stk_id,k.tip_id,
  ISNULL(sum(h.Giren),0) as Giren_Miktar,
  ISNULL(sum(h.Cikan),0) as Cikan_Miktar,
  ISNULL(sum(h.Giren-h.Cikan),0) as Mevcut_Miktar
  from gelgidkart as k
  left join stkhrk as h 
  on h.stktip='gelgid' and h.stkod=k.kod 
  and h.sil=0 
  and h.depkod=
  (select top 1 kod from depokart where id= 
  (select top 1 Prom_Depo from sistemtanim) )
  where k.Prom_Urun=1
  group by k.id,k.tip_id

================================================================================
