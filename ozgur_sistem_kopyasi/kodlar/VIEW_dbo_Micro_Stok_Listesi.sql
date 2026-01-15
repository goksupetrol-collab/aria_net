-- View: dbo.Micro_Stok_Listesi
-- Tarih: 2026-01-14 20:06:08.473727
================================================================================

CREATE VIEW [dbo].[Micro_Stok_Listesi] AS
CREATE VIEW [dbo].Micro_Stok_Listesi
AS
  select kod stokkod,ad stokad,
  (select ad from stkbrm where kod=brim)birimad,
  sat1fiy=case when sat1kdvtip='Dahil'  then
  sat1fiy/(1+(sat1kdv/100)) else sat1fiy end,
  sat2fiy=case when sat2kdvtip='Dahil'  then
  sat2fiy/(1+(sat2kdv/100)) else sat2fiy end,
  sat3fiy=case when sat3kdvtip='Dahil'  then
  sat3fiy/(1+(sat3kdv/100)) else sat3fiy end,
  sat4fiy=case when sat4kdvtip='Dahil'  then
  sat4fiy/(1+(sat4kdv/100)) else sat4fiy end,
  case when isnull(sat1pbrm,'')=''     then 0 else
  case when isnull(sat1pbrm,'')='YTL'  then 0 else
  case when isnull(sat1pbrm,'')='USD'  then 1 else
  case when isnull(sat1pbrm,'')='EURO' then 2 else
  case when isnull(sat1pbrm,'')='GBP'  then 12 end end end end end sat1pbrm,
  case when isnull(sat2pbrm,'')=''     then 0 else
  case when isnull(sat2pbrm,'')='YTL'  then 0 else
  case when isnull(sat2pbrm,'''')='USD'  then 1 else
  case when isnull(sat2pbrm,'''')='EURO' then 2 else
  case when isnull(sat2pbrm,'''')='GBP'  then 12 end end end end end sat2pbrm,
  case when isnull(sat3pbrm,'''')=''     then 0 else
  case when isnull(sat3pbrm,'''')='YTL'  then 0 else
  case when isnull(sat3pbrm,'''')='USD'  then 1 else
  case when isnull(sat3pbrm,'''')='EURO' then 2 else
  case when isnull(sat3pbrm,'''')='GBP'  then 12 end end end end end sat3pbrm,
  case when isnull(sat4pbrm,'''')=''     then 0 else
  case when isnull(sat4pbrm,'''')='YTL'  then 0 else
  case when isnull(sat4pbrm,'''')='USD'  then 1 else
  case when isnull(sat4pbrm,'')='EURO' then 2 else
  case when isnull(sat4pbrm,'')='GBP'  then 12 end end end end end sat4pbrm,
  case when isnull(sat1kdv,0)=0 then 1 else 
  case when isnull(sat1kdv,0)=1  then 2 else
  case when isnull(sat1kdv,0)=8  then 3 else
  case when isnull(sat1kdv,0)=18  then 4  end end end end sat1kdv
  from stokkart where sil=0

================================================================================
