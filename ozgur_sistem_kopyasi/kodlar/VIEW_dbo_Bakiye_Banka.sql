-- View: dbo.Bakiye_Banka
-- Tarih: 2026-01-14 20:06:08.461340
================================================================================

CREATE VIEW [dbo].[Bakiye_Banka] AS
CREATE VIEW [dbo].Bakiye_Banka
 AS
 SELECT k.kod,
  ISNULL(SUM(ROUND(h.borc,sis.Para_Ondalik)),0) as borc,
  ISNULL(SUM(ROUND(h.alacak,sis.Para_Ondalik)),0) as alacak
  FROM bankakart as k 
  left join sistemtanim as sis on 1=1
  left join bankahrk as h on h.bankod=k.kod
  and h.sil=0 group by k.kod

================================================================================
