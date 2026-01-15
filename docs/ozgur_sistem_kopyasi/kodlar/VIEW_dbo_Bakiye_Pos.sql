-- View: dbo.Bakiye_Pos
-- Tarih: 2026-01-14 20:06:08.465011
================================================================================

CREATE VIEW [dbo].[Bakiye_Pos] AS
CREATE VIEW [dbo].Bakiye_Pos
AS
  SELECT k.kod,
  ISNULL(SUM(giren-cikan),0) as bek_bak,
  ISNULL(SUM((giren*bankomyuz)+((giren*bankomyuz)*extrakomyuz)+(giren*ekkomyuz)),0)
  as kom_bak,
  sum(case when h.vadetar <= GETDATE() then (h.giren-h.cikan) else 0 end
  ) vad_gelen
  
  FROM poskart as k left join poshrk as h on h.poskod=k.kod
  and h.sil=0 and h.aktip in ('BK','BL') and PosIsle=1
  group by k.kod

================================================================================
