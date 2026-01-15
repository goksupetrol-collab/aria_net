-- View: dbo._Cari_Fis_Bakiye
-- Tarih: 2026-01-14 20:06:08.454862
================================================================================

CREATE VIEW [dbo].[_Cari_Fis_Bakiye] AS
CREATE VIEW [dbo]._Cari_Fis_Bakiye
AS
  SELECT v.carkod,v.cartip,
  COUNT(*) fis_adet,
  ISNULL(SUM(case when fistip='FISVERSAT' then toptut-isktop else -(toptut-isktop) end),0)
   as fis_bakiye,
  ISNULL(SUM(case when fistip='FISVERSAT' then toptut-isktop else 0 end),0)
   as fis_brcbakiye,
  ISNULL(SUM(case when fistip='FISALCSAT' then toptut-isktop else 0 end),0)
   as fis_alcbakiye
  from veresimas as v WITH (NOLOCK)
  where v.sil=0 and v.kayok=1 and Isnull(v.Devir,0)=0 and v.aktip in ('BK','BL','HV')
  /*and ( (varno>0 and varok=1) or (varno=0)) and (yertip<>'havuzislem') */
  group by v.cartip,v.carkod

================================================================================
