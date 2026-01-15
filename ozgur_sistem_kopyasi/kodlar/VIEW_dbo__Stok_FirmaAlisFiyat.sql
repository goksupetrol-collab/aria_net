-- View: dbo._Stok_FirmaAlisFiyat
-- Tarih: 2026-01-14 20:06:08.460595
================================================================================

CREATE VIEW [dbo].[_Stok_FirmaAlisFiyat] AS
create VIEW [dbo]._Stok_FirmaAlisFiyat
AS
  SELECT t.id,t.Firmano,t.stktip,t.stkod,
  t.brmfiykdvli AlisFiyatKdvli,
  Son_Id = u.Id 
  FROM stkhrk t WITH (NOLOCK) JOIN 
  (SELECT Firmano,stktip,stkod,
  MAX(id) as Id 
  FROM stkhrk WITH (NOLOCK) 
  where Giren>0 and Sil=0 and fatid>0
  GROUP BY Firmano,stktip,stkod) AS u ON
  (t.id)=u.Id

================================================================================
