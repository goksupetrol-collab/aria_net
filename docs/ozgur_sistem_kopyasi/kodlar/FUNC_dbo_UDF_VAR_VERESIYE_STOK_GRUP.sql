-- Function: dbo.UDF_VAR_VERESIYE_STOK_GRUP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.797730
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_VERESIYE_STOK_GRUP] 
(@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_VAR_VER_HRK TABLE (
    SIRA            VARCHAR(250)  COLLATE Turkish_CI_AS,
    FISTIP          VARCHAR(5)  COLLATE Turkish_CI_AS,
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_ADI        VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP       VARCHAR(70)  COLLATE Turkish_CI_AS,
    STOK_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(100)  COLLATE Turkish_CI_AS,
    MIKTAR          FLOAT,
    BRMFIYATKDVSIZ  FLOAT,
    BRMFIYATKDVLI   FLOAT,
    KDV				FLOAT,
    KDVTUTAR		FLOAT,
    TUTARKDVSIZ     FLOAT,
    TUTARKDVLI      FLOAT)
AS
BEGIN


    DECLARE @TB_VAR_HRK TABLE (
    FISTIP          VARCHAR(5)  COLLATE Turkish_CI_AS,
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_ADI        VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP       VARCHAR(70)  COLLATE Turkish_CI_AS,
    STOK_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(100)  COLLATE Turkish_CI_AS,
    MIKTAR          FLOAT,
    BRMFIYATKDVSIZ  FLOAT,
    BRMFIYATKDVLI   FLOAT,
    KDV				FLOAT,
    KDVTUTAR		FLOAT,
    TUTARKDVSIZ     FLOAT,
    TUTARKDVLI      FLOAT)






  INSERT @TB_VAR_HRK (FISTIP,CARI_TIP,CARI_KOD,
  STOK_TIP,STOK_KOD,MIKTAR,TUTARKDVLI,KDV)
  select 'IRS',m.cartip,m.carkod,
  h.stktip,h.stkod,
  sum(case when fistip='FISVERSAT' THEN h.mik else -h.mik END),
  sum(case when fistip='FISVERSAT' THEN
  h.mik*(h.brmfiy-(h.fiyfarktop+h.vadfarktop))
  else -h.mik*(h.brmfiy-(h.fiyfarktop+h.vadfarktop)) END),
  h.kdvyuz*100
  FROM  veresimas as m with (nolock)
  inner join veresihrk as h with (nolock) on h.verid=m.verid
  where m.varno in (select * from CsvToInt_Max(@VARNIN) )
  and h.sil=0 and m.sil=0 and m.yertip=@TIP
  and m.otomas_id>0
  group by m.cartip,m.carkod,
  h.stktip,h.stkod,h.kdvyuz
  
  
  
  INSERT @TB_VAR_HRK (FISTIP,CARI_TIP,CARI_KOD,
  STOK_TIP,STOK_KOD,MIKTAR,TUTARKDVLI,KDV)
  select 'FAT',m.cartip,m.carkod,
  h.stktip,h.stkod,
  sum(case when fistip='FISVERSAT' THEN h.mik else -h.mik END),
  sum(case when fistip='FISVERSAT' THEN
  h.mik*(h.brmfiy-(h.fiyfarktop+h.vadfarktop))
  else -h.mik*(h.brmfiy-(h.fiyfarktop+h.vadfarktop)) END),
  h.kdvyuz*100
  FROM  veresimas as m with (nolock)
  inner join veresihrk as h with (nolock) on h.verid=m.verid
  inner join Genel_Kart as ck with (nolock) on ck.kod=m.carkod and m.cartip=ck.cartp
  where m.varno in (select * from CsvToInt_Max(@VARNIN) )
  and h.sil=0 and m.sil=0 and m.yertip=@TIP
  and m.otomas_id is null
  group by m.cartip,m.carkod,
  h.stktip,h.stkod,h.kdvyuz
  
  
  
  INSERT @TB_VAR_VER_HRK (FISTIP,CARI_TIP,CARI_KOD,
  STOK_TIP,STOK_KOD,MIKTAR,TUTARKDVLI,KDV)
  SELECT FISTIP,CARI_TIP,CARI_KOD,
  STOK_TIP,STOK_KOD,SUM(MIKTAR),SUM(TUTARKDVLI),KDV
  FROM @TB_VAR_HRK
  GROUP BY 
  FISTIP,CARI_TIP,CARI_KOD,
  STOK_TIP,STOK_KOD,KDV

  


     UPDATE @TB_VAR_VER_HRK 
     SET CARI_ADI=DT.AD,
     CARI_GRUP=DT.grupad1
     FROM @TB_VAR_VER_HRK AS T 
     join (select kod,cartp,ad,grupad1 from Genel_Kart )
     dt on dt.kod=t.CARI_KOD and dt.cartp=t.CARI_TIP
 


    UPDATE @TB_VAR_VER_HRK set 
    STOK_AD=dt.AD,
    BRMFIYATKDVLI=case when MIKTAR>0 then
    TUTARKDVLI/MIKTAR else 0 end
    from @TB_VAR_VER_HRK t join
    (select sk.tip,sk.kod,sk.ad from gelgidlistok as sk) dt
    on dt.tip=t.STOK_TIP and dt.kod=t.STOK_KOD



    UPDATE @TB_VAR_VER_HRK set 
    SIRA=FISTIP+CAST(CARI_KOD AS VARCHAR(200)),
    BRMFIYATKDVSIZ=BRMFIYATKDVLI/(1+(KDV/100)),
    TUTARKDVSIZ=TUTARKDVLI/(1+(KDV/100)),
    KDVTUTAR=TUTARKDVLI-(TUTARKDVLI/(1+(KDV/100)))
  
  RETURN

end

================================================================================
