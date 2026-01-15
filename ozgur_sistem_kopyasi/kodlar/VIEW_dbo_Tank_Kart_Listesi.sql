-- View: dbo.Tank_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.484562
================================================================================

CREATE VIEW [dbo].[Tank_Kart_Listesi] AS
CREATE VIEW [dbo].Tank_Kart_Listesi
AS

 select t.*,
 mk.gir_miktar,
 mk.cik_miktar,
 mk.mev_miktar,
 mk.gir_topkdvli,
 mk.gir_topkdvsiz,
 mk.cik_topkdvli,
 mk.cik_topkdvsiz,

 case when sat1kdvtip='Dahil' then
 sat1fiy else sat1fiy*(1+(sat1kdv/100)) end satfiykdvli,
 case when sat1kdvtip='Hariç' then
 sat1fiy else sat1fiy/(1+(sat1kdv/100)) end satfiykdvsiz,
 case when alskdvtip='Dahil' then alsfiy
 else alsfiy*(1+(alskdv/100)) end alsfiykdvli,
 case when alskdvtip='Hariç' then
 alsfiy else alsfiy/(1+(alskdv/100)) end alsfiykdvsiz,
 case when sat1kdvtip='Hariç' then (mev_miktar)*sat1fiy
 else (mev_miktar)*(sat1fiy/(1+(sat1kdv/100))) end kalsattopkdvsiz,
 case when sat1kdvtip='Dahil' then (mev_miktar)*sat1fiy
 else (mev_miktar)*(sat1fiy*(1+(sat1kdv/100))) end kalsattopkdvli,
 case when alskdvtip='Hariç' then (mev_miktar)*alsfiy
 else (mev_miktar)*(alsfiy/(1+(alskdv/100))) end kalalstopkdvsiz,
 case when alskdvtip='Dahil' then (mev_miktar)*alsfiy
 else (mev_miktar)*(alsfiy*(1+(alskdv/100))) end kalalstopkdvli
 from tankkart as t with (NOLOCK)
 left join stokkart as s with (NOLOCK)
 on t.bagak=s.kod and tip=t.stktip
 left join Bakiye_Tank as mk with (NOLOCK) on mk.kod=t.kod

================================================================================
