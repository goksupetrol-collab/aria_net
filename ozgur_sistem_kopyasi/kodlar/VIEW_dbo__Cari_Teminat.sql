-- View: dbo._Cari_Teminat
-- Tarih: 2026-01-14 20:06:08.458658
================================================================================

CREATE VIEW [dbo].[_Cari_Teminat] AS
CREATE VIEW [dbo]._Cari_Teminat 
AS
  SELECT kod,tip,sum(tutar) tutar,max(ack) ack from cariteminat
  where tip='TMK'
  group by kod,tip

================================================================================
