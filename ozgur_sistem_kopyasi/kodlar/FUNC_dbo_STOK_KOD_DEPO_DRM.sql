-- Function: dbo.STOK_KOD_DEPO_DRM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.674196
================================================================================

CREATE FUNCTION [dbo].STOK_KOD_DEPO_DRM
(@tip varchar(20),
@kod  varchar(30))
RETURNS
  @TB_STOK_DEPO_DRM TABLE (
    stok_tip             VARCHAR(10) COLLATE Turkish_CI_AS,
    stok_kod             VARCHAR(30) COLLATE Turkish_CI_AS,
    stok_ad              VARCHAR(150) COLLATE Turkish_CI_AS,
    depo_kod             VARCHAR(20) COLLATE Turkish_CI_AS,
    depo_ad              VARCHAR(100) COLLATE Turkish_CI_AS,
    giren                FLOAT,
    cikan                FLOAT,
    kalan                FLOAT)
AS
BEGIN


   insert into @TB_STOK_DEPO_DRM (stok_tip,stok_kod,stok_ad,
   depo_kod,depo_ad,giren,cikan,kalan)
   select k.tip,k.kod,k.ad,d.kod,d.ad,
   sum(giren),sum(cikan),sum(giren-cikan)
   from stokkart as k
   left join stkhrk as h on 
   k.tip=h.stktip and k.kod=h.stkod
   and h.sil=0 and k.sil=0
   left join Depo_Kart_Listesi as d on d.kod=h.depkod
   where k.tip=@tip and k.kod=@kod 
   group by k.tip,k.kod,k.ad,d.kod,d.ad


  RETURN

END

================================================================================
