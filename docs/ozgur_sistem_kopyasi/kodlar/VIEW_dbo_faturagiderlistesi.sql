-- View: dbo.faturagiderlistesi
-- Tarih: 2026-01-14 20:06:08.469214
================================================================================

CREATE VIEW [dbo].[faturagiderlistesi] AS
CREATE VIEW [dbo].faturagiderlistesi
AS
  select h.id,f.fatid,k.kod,k.ad,k.muhkod,k.muhonkod,(h.kdvyuz*100) as kdv,
  case when f.kdvtip='Dahil' then h.borc else h.borc/(1+h.kdvyuz) end as tutar
  from carihrk as h WITH (NOLOCK) inner join gelgidkart as k WITH (NOLOCK) on k.kod=h.carkod and cartip='gelgidkart'
  inner join faturamas  as f WITH (NOLOCK) on f.fatid=h.fisfatid
  where h.sil=0 and h.islmtip='FAT' AND h.islmhrk='GID' and h.yertip='faturamas'

================================================================================
