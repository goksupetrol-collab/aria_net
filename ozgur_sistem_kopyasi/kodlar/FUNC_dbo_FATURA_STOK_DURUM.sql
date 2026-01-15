-- Function: dbo.FATURA_STOK_DURUM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.655785
================================================================================

CREATE FUNCTION FATURA_STOK_DURUM(
@firmano int,
@MEV_CHK int,
@BASTAR DATETIME,@BITTAR DATETIME,
@FATIN VARCHAR(200),
@ZRAPIN VARCHAR(200),
@AKSTKIN 		VARCHAR(8000),
@MARSTKGRPIN  	VARCHAR(8000),
@GELSTKIN  		VARCHAR(8000),
@VERIN          VARCHAR(8000))
RETURNS
  @TB_FAT_STK_DRM TABLE (
    ACK                  VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(30) COLLATE Turkish_CI_AS,
    DEVIR_MIK            FLOAT,
    DEVIR_TUT            FLOAT,
    DEVIR_KDV            FLOAT,
    ALIS_MIK             FLOAT,
    ALIS_TUT             FLOAT,
    ALIS_KDV             FLOAT,
    SATIS_MIK            FLOAT,
    SATIS_TUT            FLOAT,
    SATIS_KDV            FLOAT,
    ALS_SAT_KDV          FLOAT,
    KES_MIK              FLOAT,
    KES_TUT              FLOAT,
    KES_KDV              FLOAT,
    MEV_MIK              FLOAT,
    MEV_TUT              FLOAT,
    MEV_KDV              FLOAT)
AS
BEGIN

   DECLARE  @EXTRA_FAT_STK_DRM TABLE (
    STOK_GRUP            VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_GENKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    DEVIR_MIK            FLOAT,
    DEVIR_TUT            FLOAT,
    DEVIR_KDV            FLOAT,
    ALIS_MIK             FLOAT,
    ALIS_TUT             FLOAT,
    ALIS_KDV             FLOAT,
    SATIS_MIK            FLOAT,
    SATIS_TUT            FLOAT,
    SATIS_KDV            FLOAT,
    ALS_SAT_KDV          FLOAT,
    KES_MIK              FLOAT,
    KES_TUT              FLOAT,
    KES_KDV              FLOAT,
    MEV_MIK              FLOAT,
    MEV_TUT              FLOAT,
    MEV_KDV              FLOAT)



  DECLARE @EKSTRE_TEMP TABLE (
  Firmano		  int,
  TIP             VARCHAR(1)  COLLATE Turkish_CI_AS,
  STOK_GENKOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
  STOK_TIP        VARCHAR(10)  COLLATE Turkish_CI_AS,
  STOK_MIK        FLOAT,
  STOK_MATRAH     FLOAT,
  TARIH           DATETIME,
  KDV_ORAN        FLOAT,
  MATRAH          FLOAT,
  KDV_TUTAR       FLOAT)


  insert into @EKSTRE_TEMP (Firmano,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,t.gc,h.stktip,h.stkod,h.mik,
  m.tarih,isnull(((h.brmfiy-(h.satisktut+h.genisktut))*mik),0),
  h.kdvtut*mik,h.kdvyuz
  from faturahrklistesi as h with (nolock)
  inner join faturamas as m with (nolock) on m.fatid=h.fatid
  and h.sil=0 and m.sil=0 and h.satirtip='S'
  inner join fattip as t with (nolock) on t.kod=m.fattip and t.tip='FAT'
  inner join raporlar as r with (nolock) on t.kod=r.rapkod 
  and m.fatrap_id=r.id  where h.kdvyuz>0 and m.fatrap_id 
   in (select * from CsvToSTR(@FATIN))
   and m.firmano in (select * from FirmaList_Ver(@firmano)) 
  
  /*veresiye */
  insert into @EKSTRE_TEMP (Firmano,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,t.gc,h.stktip,h.stkod,h.mik,
  m.tarih,isnull(((h.brmfiy*(1-(h.iskyuz/100)))*mik),0),
  isnull(((h.brmfiy*(1-(h.iskyuz/100)))*mik),0)/(1+(h.kdvyuz/100)),h.kdvyuz
  from veresihrk as h with (nolock)
  inner join veresimas as m with (nolock) on m.verid=h.verid
  and h.sil=0 and m.sil=0  and m.aktip='BK'
  inner join fattip as t with (nolock) on t.kod=m.fistip and t.tip='FIS'
  inner join raporlar as r with (nolock) on t.kod=r.rapkod 
  and m.fisrap_id=r.id  where h.kdvyuz>0 and m.fisrap_id 
   in (select * from CsvToSTR(@VERIN))
   and m.firmano in (select * from FirmaList_Ver(@firmano)) 
  
  
 /* update @EKSTRE_TEMP set STOK_GRP=STOK_KOD */
 /* where STOK_TIP in ('akykt','gelgid') */
  
  update @EKSTRE_TEMP set STOK_GENKOD=
  case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  from @EKSTRE_TEMP as t inner join stokkart as k with (nolock)
  on k.kod=t.STOK_GENKOD and t.STOK_TIP='markt'
  and t.STOK_TIP ='markt'

  
  insert into @EKSTRE_TEMP (Firmano,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,'C',h.tip,h.kod,h.miktar,m.tarih,
  ((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  (h.brmfiy*h.miktar)-((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  h.kdvyuz
  from zraporhrk as h with (nolock)
  inner join zrapormas as m with (nolock) on m.zrapid=h.zrapid
  and h.sil=0 and m.sil=0 
  /*inner join fattip as t on t.kod=m.zraptip and t.tip='ZRP' */
  where h.kdvyuz>0 and m.zraptip in (select * from CsvToSTR(@ZRAPIN))
  and m.firmano in (select * from FirmaList_Ver(@firmano)) 
  
  if @Firmano>0
   delete from @EKSTRE_TEMP where firmano not in (@Firmano,0)
  
  
  delete from @EKSTRE_TEMP
  where STOK_TIP='akykt' and  STOK_GENKOD not in (select * from CsvToSTR(@AKSTKIN))

  delete from @EKSTRE_TEMP
  where STOK_TIP='gelgid' and STOK_GENKOD not in (select * from CsvToSTR(@GELSTKIN))
  
  delete from @EKSTRE_TEMP
  where STOK_TIP='markt' and STOK_GENKOD not in (select * from CsvToSTR(@MARSTKGRPIN))
  

  
  DECLARE @STK_TEMP TABLE (
  STOK_TIP        VARCHAR(10)  COLLATE Turkish_CI_AS,
  STOK_GENKOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
  STOK_GENAD      VARCHAR(100)  COLLATE Turkish_CI_AS,
  MEV_MIKTAR      FLOAT,
  SAT1_KDVLI      FLOAT,
  SAT1_KDVSIZ     FLOAT,
  SAT1_KDV        FLOAT)
  
  
 /*--geçiçi kod stok gruplu tablo */
  insert into @STK_TEMP
  (STOK_TIP,STOK_GENKOD,STOK_GENAD,MEV_MIKTAR,SAT1_KDVLI,
  SAT1_KDVSIZ,SAT1_KDV)
  select k.tip,
  case when k.tip='akykt' then k.kod
   when k.tip='gelgid' then  k.kod
   when k.tip='markt' then  cast(g.id as varchar) end,
  case when k.tip='akykt' then k.ad
   when k.tip='gelgid' then  k.ad
   when k.tip='markt' then  g.ad end,
   k.mev_miktar,k.sat1fiykdvli,k.sat1fiykdvsiz,k.sat1kdv
   FROM Stok_Kart_Listesi AS k
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
   when k.grp2>0 then k.grp2
   when k.grp1>0 then k.grp1 end 
  /* where k.firmano in (select * from FirmaList_Ver(@firmano))  */
/*------------------------------------- */
  
  DECLARE @STK_DVR_TEMP TABLE (
  STOK_TIP        VARCHAR(10)  COLLATE Turkish_CI_AS,
  STOK_GENKOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
  STOK_MIK        FLOAT,
  STOK_MATRAH     FLOAT,
  STOK_KDVTUT     FLOAT)
  
  insert into @STK_DVR_TEMP
  (STOK_TIP,STOK_GENKOD,STOK_MIK,STOK_MATRAH,STOK_KDVTUT)
  select STOK_TIP,STOK_GENKOD,
  ISNULL(sum(case when TIP='G' THEN
  STOK_MIK ELSE -1*STOK_MIK END),0),
  sum(case when TIP='G' THEN
  STOK_MATRAH ELSE -1*STOK_MATRAH END),
  sum(case when TIP='G' THEN
  KDV_TUTAR ELSE -1*KDV_TUTAR END)
  FROM
  @EKSTRE_TEMP where TARIH<@BASTAR
  GROUP BY STOK_TIP,STOK_GENKOD

  

   insert into @EXTRA_FAT_STK_DRM
   (STOK_TIP,STOK_GENKOD,
   ALIS_MIK,ALIS_TUT,ALIS_KDV,
   SATIS_MIK,SATIS_TUT,SATIS_KDV)
   select T.STOK_TIP,T.STOK_GENKOD,
   sum(case when T.TIP='G' THEN T.STOK_MIK ELSE 0 END),
   sum(case when T.TIP='G' THEN T.STOK_MATRAH ELSE 0 END),
   sum(case when T.TIP='G' THEN T.KDV_TUTAR ELSE 0 END),
   sum(case when T.TIP='C' THEN T.STOK_MIK ELSE 0 END),
   sum(case when T.TIP='C' THEN T.STOK_MATRAH ELSE 0 END),
   sum(case when T.TIP='C' THEN T.KDV_TUTAR ELSE 0 END)

   from @EKSTRE_TEMP AS T WHERE
   T.TARIH>=@BASTAR and T.TARIH <=@BITTAR
   group by T.STOK_TIP,T.STOK_GENKOD


   UPDATE @EXTRA_FAT_STK_DRM SET
   DEVIR_MIK=dt.DEVIR_MIK ,
   DEVIR_TUT=dt.DEVIR_TUT ,
   DEVIR_KDV=dt.DEVIR_KDV
   from @EXTRA_FAT_STK_DRM as t join
   (select STOK_TIP,STOK_GENKOD,
    isnull(sum(DVR.STOK_MIK),0) as DEVIR_MIK,
   isnull(sum(DVR.STOK_MATRAH),0) as DEVIR_TUT,
   isnull(sum(DVR.STOK_KDVTUT),0) as DEVIR_KDV
   from @STK_DVR_TEMP AS DVR GROUP BY STOK_TIP,STOK_GENKOD)
   dt on dt.STOK_TIP=T.STOK_TIP
   AND dt.STOK_GENKOD=T.STOK_GENKOD

   UPDATE @EXTRA_FAT_STK_DRM SET
   STOK_GRUP=dt.STOK_GENAD,
   ALS_SAT_KDV=ALIS_KDV-SATIS_KDV,
   KES_MIK=isnull(DEVIR_MIK,0)+isnull(ALIS_MIK,0)-isnull(SATIS_MIK,0),
   KES_TUT=isnull(DEVIR_TUT,0)+isnull(ALIS_TUT,0)-isnull(SATIS_TUT,0),
   KES_KDV=isnull(DEVIR_KDV,0)+isnull(ALIS_KDV,0)-isnull(SATIS_KDV,0),
   MEV_MIK=MEV_MIKTAR,
   MEV_TUT=dt.MEV_MIKTAR*dt.SAT1_KDVLI,
   MEV_KDV=(dt.MEV_MIKTAR*dt.SAT1_KDVSIZ)
   *(case when dt.SAT1_KDV=0 then 0 else (dt.SAT1_KDV/100) end)
   FROM @EXTRA_FAT_STK_DRM as t
   join (select STOK_GENAD,
   k.STOK_TIP,k.STOK_GENKOD,
   k.MEV_MIKTAR,k.SAT1_KDVLI,
   k.SAT1_KDVSIZ,k.SAT1_KDV
   from @STK_TEMP AS k)
   dt on t.STOK_TIP=DT.STOK_TIP
   and t.STOK_GENKOD=dt.STOK_GENKOD
  
   if @MEV_CHK=0
   insert into @TB_FAT_STK_DRM
    (ACK,STOK_TIP,DEVIR_MIK,DEVIR_TUT,DEVIR_KDV,ALIS_MIK,ALIS_TUT,
    ALIS_KDV,SATIS_MIK,SATIS_TUT,SATIS_KDV,ALS_SAT_KDV,
    KES_MIK,KES_TUT,KES_KDV,MEV_MIK,MEV_TUT,MEV_KDV)
    select STOK_GRUP,
    CASE
    WHEN STOK_TIP='akykt' then 'AKARYAKIT'
    WHEN STOK_TIP='markt' then 'MARKET'
    WHEN STOK_TIP='gelgid' then 'GELIR-GIDER' END,
    isnull(sum(DEVIR_MIK),0),isnull(sum(DEVIR_TUT),0),isnull(sum(DEVIR_KDV),0),
    isnull(sum(ALIS_MIK),0),isnull(sum(ALIS_TUT),0),isnull(sum(ALIS_KDV),0),
    sum(SATIS_MIK),sum(SATIS_TUT),sum(SATIS_KDV),sum(ALS_SAT_KDV),
    isnull(sum(KES_MIK),0),isnull(sum(KES_TUT),0),isnull(sum(KES_KDV),0),
    isnull(sum(MEV_MIK),0),isnull(sum(MEV_TUT),0),isnull(sum(MEV_KDV),0) from @EXTRA_FAT_STK_DRM
    group by STOK_TIP,STOK_GRUP ORDER BY STOK_TIP



   if @MEV_CHK=1
   insert into @TB_FAT_STK_DRM
    (ACK,STOK_TIP,DEVIR_MIK,DEVIR_TUT,DEVIR_KDV,ALIS_MIK,ALIS_TUT,
    ALIS_KDV,SATIS_MIK,SATIS_TUT,SATIS_KDV,ALS_SAT_KDV,
    KES_MIK,KES_TUT,KES_KDV,MEV_MIK,MEV_TUT,MEV_KDV)
    select STOK_GRUP,
    CASE
    WHEN STOK_TIP='akykt' then 'AKARYAKIT'
    WHEN STOK_TIP='markt' then 'MARKET'
    WHEN STOK_TIP='gelgid' then 'GELIR-GIDER' END,
    isnull(sum(DEVIR_MIK),0),isnull(sum(DEVIR_TUT),0),isnull(sum(DEVIR_KDV),0),
    isnull(sum(ALIS_MIK),0),isnull(sum(ALIS_TUT),0),isnull(sum(ALIS_KDV),0),
    sum(SATIS_MIK),sum(SATIS_TUT),sum(SATIS_KDV),sum(ALS_SAT_KDV),
    isnull(sum(KES_MIK),0)-isnull(sum(MEV_MIK),0),
    isnull(sum(KES_TUT),0)-isnull(sum(MEV_TUT),0),
    isnull(sum(KES_KDV),0)-isnull(sum(MEV_KDV),0),
    isnull(sum(MEV_MIK),0),isnull(sum(MEV_TUT),0),isnull(sum(MEV_KDV),0) from @EXTRA_FAT_STK_DRM
    group by STOK_TIP,STOK_GRUP ORDER BY STOK_TIP







 RETURN

  
END

================================================================================
