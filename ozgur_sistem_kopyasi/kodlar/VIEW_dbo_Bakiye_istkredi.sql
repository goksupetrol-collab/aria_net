-- View: dbo.Bakiye_istkredi
-- Tarih: 2026-01-14 20:06:08.463334
================================================================================

CREATE VIEW [dbo].[Bakiye_istkredi] AS
CREATE VIEW [dbo].Bakiye_istkredi
AS
  SELECT k.kod,
  ISNULL(SUM(h.borc),0) as borc,
  ISNULL(SUM(h.alacak),0) as alacak,
  sum(case when 
  h.vadetar 
  < DATEADD(day,k.heskesgun-1,DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0))
   then (h.borc-h.alacak) else 0 end) vad_gelen
 
  FROM istkart as k left join istkhrk as h on h.istkkod=k.kod
  and h.sil=0 group by k.kod

================================================================================
