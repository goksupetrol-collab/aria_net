-- Function: dbo.Udf_Mikro_Faturalan_Ver
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.754680
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Faturalan_Ver]
(@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_MIKRO_FAT_VER TABLE (
  fat_id                   int,
  ver_id                   int
)
AS
BEGIN

/* http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/stok_hareketleri.htm */

  insert into @TB_MIKRO_FAT_VER
  (fat_id,ver_id)
  
    select m.fatid,h.verid 
    from faturamas as m
    inner join veresimas as h on
    h.fatid=m.fatid and h.sil=0
    inner join Genel_Cari_Kart as car on
    m.carkod=car.kod and m.cartip=car.cartip
     where m.sil=0
      and m.tarih>=@Bastar and m.tarih<=@Bittar
    order by m.fatid




 RETURN


END

================================================================================
