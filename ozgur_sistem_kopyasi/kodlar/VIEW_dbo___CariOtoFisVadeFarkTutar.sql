-- View: dbo.__CariOtoFisVadeFarkTutar
-- Tarih: 2026-01-14 20:06:08.452361
================================================================================

CREATE VIEW [dbo].[__CariOtoFisVadeFarkTutar] AS
CREATE VIEW dbo.__CariOtoFisVadeFarkTutar 
AS
  SELECT carkod,cartip,car_id,borc As FisOtoVadeFarkTutar 
  from carihrk with (nolock) where islmtip='VAD' and islmhrk='OFV'
  and sil=0

================================================================================
