-- Function: dbo.UDF_TANK_STOK_DRM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.772491
================================================================================

CREATE FUNCTION [dbo].[UDF_TANK_STOK_DRM]
(@TARIH DATETIME)
RETURNS
  @TB_STOK_DEPO_DRM TABLE (
    ID					INT,
    FIRMA_NO			INT,
    FIRMA_UNVAN		     VARCHAR(150) COLLATE Turkish_CI_AS,
    TANK_KOD             VARCHAR(30) COLLATE Turkish_CI_AS,
    TANK_AD              VARCHAR(150) COLLATE Turkish_CI_AS,
    GIREN                FLOAT,
    CIKAN                FLOAT,
    KALAN                FLOAT)
AS
BEGIN

   insert into @TB_STOK_DEPO_DRM (ID,FIRMA_NO,TANK_KOD,TANK_AD,
   GIREN,CIKAN,KALAN)
   select K.id,K.firmano,k.kod,k.ad,
   sum(giren),sum(cikan),sum(giren-cikan)
   from tankkart as k with (nolock)
   inner join stkhrk as h with (nolock) on 
   k.kod=h.depkod 
   and h.sil=0 and k.sil=0
   and h.tarih<=@TARIH
   group by K.id,K.firmano,k.kod,k.ad
   order by K.firmano 
 
   update @TB_STOK_DEPO_DRM set FIRMA_UNVAN=DT.ad from @TB_STOK_DEPO_DRM as t
   join (select id,ad from firma) dt on dt.id=t.FIRMA_NO

  RETURN

END

================================================================================
