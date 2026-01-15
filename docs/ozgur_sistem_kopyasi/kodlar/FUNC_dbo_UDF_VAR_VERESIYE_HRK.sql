-- Function: dbo.UDF_VAR_VERESIYE_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.797307
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_VERESIYE_HRK (@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_VAR_VER_HRK TABLE (
    CARI_TIP      VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_ADI      VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP     VARCHAR(50)  COLLATE Turkish_CI_AS,
    SERINO        VARCHAR(50)  COLLATE Turkish_CI_AS,
    PLAKA         VARCHAR(50)  COLLATE Turkish_CI_AS,
    STOK_TIP      VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    STOK_AD       VARCHAR(100)  COLLATE Turkish_CI_AS,
    MIKTAR        FLOAT,
    BRMFIYAT      FLOAT,
    TUTAR         FLOAT)
AS
BEGIN


  INSERT @TB_VAR_VER_HRK (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,
  SERINO,PLAKA,STOK_TIP,STOK_KOD,MIKTAR,BRMFIYAT)
  select m.cartip,m.carkod,ck.ad,ck.grupad1,
  m.seri+cast(m.no as varchar),m.plaka,
  h.stktip,h.stkod,
  (case when fistip='FISVERSAT' THEN h.mik else -h.mik END),
  ((h.brmfiy*(1-case when isnull(h.iskyuz,0)>0 then 
  isnull(h.iskyuz,0)/100 else 0 end   )) -(h.fiyfarktop+h.vadfarktop))
  FROM  veresimas as m with (nolock)
  inner join veresihrk as h  with (nolock) on h.verid=m.verid and h.sil=0 and m.sil=0
  inner join Genel_Kart as ck  with (nolock) on ck.kod=m.carkod and m.cartip=ck.cartp
  where m.varno in (select * from CsvToInt(@VARNIN) )
  and h.sil=0 and m.sil=0 and m.yertip=@TIP order by ck.ad
  
  

  UPDATE @TB_VAR_VER_HRK set STOK_AD=dt.AD,TUTAR=BRMFIYAT*MIKTAR
  from @TB_VAR_VER_HRK t join
  (select sk.tip,sk.kod,sk.ad from gelgidlistok as sk  with (nolock) ) dt
  on dt.tip=t.STOK_TIP and dt.kod=t.STOK_KOD


  RETURN

end

================================================================================
