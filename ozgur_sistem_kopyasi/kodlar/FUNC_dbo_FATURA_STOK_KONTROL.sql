-- Function: dbo.FATURA_STOK_KONTROL
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.656206
================================================================================

CREATE FUNCTION [dbo].[FATURA_STOK_KONTROL](
@firmano int,
@BASTAR DATETIME,@BITTAR DATETIME,
@FATIN VARCHAR(200),
@AKSTKIN 		VARCHAR(8000),
@VERIN          VARCHAR(8000))
RETURNS
  @TB_FAT_STK_DRM TABLE (
    ACK                  VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(30) COLLATE Turkish_CI_AS,
    SAYAC_MIK            FLOAT,
    SAYAC_TUT            FLOAT,
    SAYAC_KDV            FLOAT,
    KES_MIK              FLOAT,
    KES_TUT              FLOAT,
    KES_KDV              FLOAT,
    VER_MIK              FLOAT,
    VER_TUT              FLOAT,
    VER_KDV              FLOAT,    
    MEV_MIK              FLOAT,
    MEV_TUT              FLOAT,
    MEV_KDV              FLOAT)
AS
BEGIN

   DECLARE  @EXTRA_FAT_STK_DRM TABLE (
    STOK_GRUP            VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_GENKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    SAYAC_MIK            FLOAT,
    SAYAC_TUT            FLOAT,
    SAYAC_KDV            FLOAT,
    KES_MIK              FLOAT,
    KES_TUT              FLOAT,
    KES_KDV              FLOAT,
    VER_MIK              FLOAT,
    VER_TUT              FLOAT,
    VER_KDV              FLOAT,    
    MEV_MIK              FLOAT,
    MEV_TUT              FLOAT,
    MEV_KDV              FLOAT)



  DECLARE @EKSTRE_TEMP TABLE (
  Firmano		  int,
  EVRAKTIP        VARCHAR(1)  COLLATE Turkish_CI_AS, 
  TIP             VARCHAR(1)  COLLATE Turkish_CI_AS,
  STOK_GENKOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
  STOK_TIP        VARCHAR(10)  COLLATE Turkish_CI_AS,
  STOK_MIK        FLOAT,
  STOK_MATRAH     FLOAT,
  TARIH           DATETIME,
  KDV_ORAN        FLOAT,
  MATRAH          FLOAT,
  KDV_TUTAR       FLOAT)


  insert into @EKSTRE_TEMP (Firmano,EVRAKTIP,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,'F',t.gc,h.stktip,h.stkod,h.mik,
  m.tarih,
  isnull(((h.brmfiy-(h.satisktut+h.genisktut))*mik),0),
  h.kdvtut*mik,h.kdvyuz
  from faturahrklistesi as h with (nolock)
  inner join faturamas as m with (nolock) on m.fatid=h.fatid
  and h.sil=0 and m.sil=0 and h.satirtip='S'
  inner join fattip as t with (nolock) on t.kod=m.fattip and t.tip='FAT'
  inner join raporlar as r with (nolock) on t.kod=r.rapkod 
  and m.fatrap_id=r.id  
  where h.kdvyuz>0 and
  m.tarih>=@BASTAR and m.tarih <=@BITTAR
  and m.fatrap_id in (select * from CsvToSTR(@FATIN))
  and m.firmano in (select * from FirmaList_Ver(@firmano))
  
  
  /*veresiye */
  insert into @EKSTRE_TEMP (Firmano,EVRAKTIP,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,'V',t.gc,h.stktip,h.stkod,h.mik,
  m.tarih,isnull(((h.brmfiy*(1-(h.iskyuz/100)))*mik),0),
  isnull(((h.brmfiy*(1-(h.iskyuz/100)))*mik),0)/(1+(h.kdvyuz/100)),
  h.kdvyuz
  from veresihrk as h
  inner join veresimas as m  with (nolock) on m.verid=h.verid
  and h.sil=0 and m.sil=0  and m.aktip='BK'
  inner join fattip as t with (nolock) on t.kod=m.fistip and t.tip='FIS'
  inner join raporlar as r with (nolock) on t.kod=r.rapkod 
  and m.fisrap_id=r.id  where h.kdvyuz>0 
  and m.tarih>=@BASTAR and m.tarih <=@BITTAR
  and m.fisrap_id in (select * from CsvToSTR(@VERIN))
  and m.firmano in (select * from FirmaList_Ver(@firmano)) 
  
  
 /*SAYAC SATIŞ */
  insert into @EKSTRE_TEMP (Firmano,EVRAKTIP,TIP,STOK_TIP,STOK_GENKOD,STOK_MIK,
  TARIH,STOK_MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,'S','C',h.stktip,h.stkod,h.cikan,
  m.tarih,isnull(((h.brmfiykdvli*(1-(0/100)))*h.cikan),0),
  isnull(((h.brmfiykdvli*(1-(0/100)))*h.cikan),0)/(1+(h.kdvyuz/100)),
  h.kdvyuz
  from stkhrk as h with (nolock)
  inner join pomvardimas as m with (nolock) on m.varno=h.varno
  and h.sil=0 and m.sil=0 and h.yertip='pomvardimas'
  and h.stktip='akykt'
  and h.tarih>=@BASTAR and h.tarih <=@BITTAR
  and m.firmano in (select * from FirmaList_Ver(@firmano)) 
 
  
    
   
  if @Firmano>0
   delete from @EKSTRE_TEMP where firmano not in (@Firmano,0)
  
  
  delete from @EKSTRE_TEMP
  where STOK_TIP='akykt' and  STOK_GENKOD not in (select * from CsvToSTR(@AKSTKIN))

 

  
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
   FROM
  Stok_Kart_Listesi AS k
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
   when k.grp2>0 then k.grp2
   when k.grp1>0 then k.grp1 end
   /*where k.firmano in (select * from FirmaList_Ver(@firmano))   */
   /*------------------------------------- */
  
 
   insert into @EXTRA_FAT_STK_DRM
   (STOK_TIP,STOK_GENKOD,
   SAYAC_MIK,SAYAC_TUT,SAYAC_KDV,
   KES_MIK,KES_TUT,KES_KDV,
   VER_MIK,VER_TUT,VER_KDV)

   select T.STOK_TIP,T.STOK_GENKOD,
   sum(case when T.EVRAKTIP='S' THEN T.STOK_MIK ELSE 0 END),
   sum(case when T.EVRAKTIP='S' THEN T.STOK_MATRAH ELSE 0 END),
   sum(case when T.EVRAKTIP='S' THEN T.KDV_TUTAR ELSE 0 END),
   
   
   sum(case when T.EVRAKTIP='F' THEN T.STOK_MIK ELSE 0 END),
   sum(case when T.EVRAKTIP='F' THEN T.STOK_MATRAH ELSE 0 END),
   sum(case when T.EVRAKTIP='F' THEN T.KDV_TUTAR ELSE 0 END),
   sum(case when T.EVRAKTIP='V' THEN T.STOK_MIK ELSE 0 END),
   sum(case when T.EVRAKTIP='V' THEN T.STOK_MATRAH ELSE 0 END),
   sum(case when T.EVRAKTIP='V' THEN T.KDV_TUTAR ELSE 0 END)
   

   FROM @EKSTRE_TEMP AS T WHERE
   T.TARIH>=@BASTAR and T.TARIH <=@BITTAR
   group by T.STOK_TIP,T.STOK_GENKOD


  
   UPDATE @EXTRA_FAT_STK_DRM SET
   STOK_GRUP=dt.STOK_GENAD,
   MEV_MIK=SAYAC_MIK-(KES_MIK+VER_MIK),
   MEV_TUT=SAYAC_TUT-(KES_TUT+VER_TUT),
   MEV_KDV=SAYAC_KDV-(KES_KDV+VER_KDV)
   FROM @EXTRA_FAT_STK_DRM as t
   join (
   select STOK_GENAD,STOK_TIP,STOK_GENKOD
   from @STK_TEMP AS k)
   dt on t.STOK_TIP=DT.STOK_TIP
   and t.STOK_GENKOD=dt.STOK_GENKOD
  
  
    insert into @TB_FAT_STK_DRM
    (ACK,STOK_TIP,
     SAYAC_MIK,SAYAC_TUT,SAYAC_KDV,
     KES_MIK,KES_TUT,KES_KDV,
     VER_MIK,VER_TUT,VER_KDV,
     MEV_MIK,MEV_TUT,MEV_KDV)
    select STOK_GRUP,
    CASE
    WHEN STOK_TIP='akykt' then 'AKARYAKIT'
    WHEN STOK_TIP='markt' then 'MARKET'
    WHEN STOK_TIP='gelgid' then 'GELIR-GIDER' END,
    isnull(sum(SAYAC_MIK),0),isnull(sum(SAYAC_TUT),0),isnull(sum(SAYAC_KDV),0),
    isnull(sum(KES_MIK),0),isnull(sum(KES_TUT),0),isnull(sum(KES_KDV),0),
    isnull(sum(VER_MIK),0),isnull(sum(VER_TUT),0),isnull(sum(VER_KDV),0),
    isnull(sum(MEV_MIK),0),isnull(sum(MEV_TUT),0),isnull(sum(MEV_KDV),0) 
    from @EXTRA_FAT_STK_DRM
    group by STOK_TIP,STOK_GRUP ORDER BY STOK_TIP



   




 RETURN

  
END

================================================================================
