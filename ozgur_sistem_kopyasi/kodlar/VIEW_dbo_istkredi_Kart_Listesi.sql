-- View: dbo.istkredi_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.473048
================================================================================

CREATE VIEW [dbo].[istkredi_Kart_Listesi] AS
CREATE VIEW [dbo].istkredi_Kart_Listesi
AS
  select k.*,
  isnull((bak.borc-bak.alacak),0) top_bakiye,
  (k.lim+(bak.borc-bak.alacak)) kal_limit,
  (bak.vad_gelen) vad_gelen,
  
  DATEADD(day,k.heskesgun-1,DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0))
  hes_kes_tar,
  DATEADD(day,k.hessongun-1,DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0))
  son_ode_tar
  
  from istkart as k with (nolock)
  inner join Bakiye_istkredi as bak on bak.kod=k.kod

================================================================================
