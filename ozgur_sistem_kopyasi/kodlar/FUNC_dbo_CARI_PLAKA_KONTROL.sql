-- Function: dbo.CARI_PLAKA_KONTROL
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.645902
================================================================================

CREATE FUNCTION [dbo].CARI_PLAKA_KONTROL
(@cartip varchar(30),
@carkod varchar(30),
@plaka varchar(30)
)
RETURNS
    @TB_CARI_PLAKA_KONT TABLE (
    CAR_TUR        VARCHAR(30) COLLATE Turkish_CI_AS,
    CAR_KOD        VARCHAR(30) COLLATE Turkish_CI_AS,
    CAR_UNVAN      VARCHAR(100) COLLATE Turkish_CI_AS,
    PLAKA          VARCHAR(30) COLLATE Turkish_CI_AS)
AS
BEGIN

  insert @TB_CARI_PLAKA_KONT (CAR_TUR,CAR_KOD,CAR_UNVAN,PLAKA)
  select vc.tip,vc.kod,vc.ad,o.plaka from otomasgenkod as o
  inner join  Genel_Kart as vc
  on o.cartip=vc.cartp and o.kod=vc.kod
  where o.plaka=@plaka and o.cartip=@cartip and o.kod<>@carkod



 RETURN

  
END

================================================================================
