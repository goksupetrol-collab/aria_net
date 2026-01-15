-- Function: dbo.STOKAGIRLIKDONEM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.678006
================================================================================

CREATE FUNCTION STOKAGIRLIKDONEM (
/*@firmano          int, */
@DEPO_IN		  VARCHAR(5000),
@MALIYET_TIP      int,
@HRK_KRITER       VARCHAR(4000),
@KDVTIP           VARCHAR(10),
@DS_HSPTIP        int,
@STOK_TIP         VARCHAR(10),
@STOK_IN          VARCHAR(8000),
@TARIH1           DATETIME,
@TARIH2           DATETIME)
RETURNS
   @AGIRLIKLI_STK TABLE (
    TARIH                 DATETIME,
    HRKTIP                VARCHAR(1) COLLATE Turkish_CI_AS,
    STOK_KOD              VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD               VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_TIP              VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_GRUP             VARCHAR(100) COLLATE Turkish_CI_AS,
    DBASIMIKTAR           Decimal(30,12) DEFAULT 0,
    DBALSMIKTAR           Decimal(30,12) DEFAULT 0,
    DBASITUTAR            Decimal(30,12) DEFAULT 0,
    DBBRMORTFIYAT         Decimal(30,12) DEFAULT 0,
    ALISMIKTAR            Decimal(30,12) DEFAULT 0,
    ALISBRMORTFIYAT       Decimal(30,12) DEFAULT 0,
    ALISTUTAR             decimal(20,12) DEFAULT 0,
    ALISIADEMIKTAR        Decimal(30,12) DEFAULT 0,
    ALISIADETUTAR         Decimal(30,12) DEFAULT 0,
    ALISMIKTARIADESIZ     Decimal(30,12) DEFAULT 0,
    ALISTUTARIADESIZ      Decimal(30,12) DEFAULT 0,
    SATISMIKTAR           Decimal(30,12) DEFAULT 0,
    SATISTUTAR            Decimal(30,12) DEFAULT 0,
    SATISIADEMIKTAR       Decimal(30,12) DEFAULT 0,
    SATISIADETUTAR        Decimal(30,12) DEFAULT 0,
    SATISMIKTARIADESIZ    Decimal(30,12) DEFAULT 0,
    SATISTUTARIADESIZ     Decimal(30,12) DEFAULT 0,
    SATISMALIYET          Decimal(30,12) DEFAULT 0,
    ALISKARTUTAR          Decimal(30,12) DEFAULT 0,
    SATISKARTUTAR         Decimal(30,12) DEFAULT 0,
    SATISKARYUZDE         Decimal(30,12) DEFAULT 0,
    ALISKARYUZDE          Decimal(30,12) DEFAULT 0,
    DONEMSONUMIKTAR       Decimal(30,12) DEFAULT 0,
    DONEMSONUTUTAR        Decimal(30,12) DEFAULT 0,
    BRMORTFIYAT           Decimal(30,12) DEFAULT 0,
    BRMSAT1FIYAT          Decimal(30,12) DEFAULT 0,
    BRMSAT2FIYAT          Decimal(30,12) DEFAULT 0,
    BRMSAT3FIYAT          Decimal(30,12) DEFAULT 0,
    BRMSAT4FIYAT          Decimal(30,12) DEFAULT 0,
    BRMALSFIYAT           Decimal(30,12) DEFAULT 0,
    BRMSONALSFIYAT        Decimal(30,12) DEFAULT 0,
    BRMSONSATFIYAT        Decimal(30,12) DEFAULT 0,
    
    SATISMIKTAR2           Decimal(30,12) DEFAULT 0,
    SATISTUTAR2            Decimal(30,12) DEFAULT 0,
    
    FATURA_ALIS_MIK		  Decimal(30,12) DEFAULT 0,
    FATURA_ALIS_TUT		  Decimal(30,12) DEFAULT 0,	
    FATURA_SATIS_MIK	  Decimal(30,12) DEFAULT 0,
    FATURA_SATIS_TUT	  Decimal(30,12) DEFAULT 0,
    SAYAC_MIK		  	  Decimal(30,12) DEFAULT 0,
    SAYAC_TUT		  	  Decimal(30,12) DEFAULT 0,	
    FIRE_CIKIS_MIK	  	  Decimal(30,12) DEFAULT 0,
    FIRE_CIKIS_TUT	  	  Decimal(30,12) DEFAULT 0,
    FIRE_GIRIS_MIK	  	  Decimal(30,12) DEFAULT 0,
    FIRE_GIRIS_TUT	  	  Decimal(30,12) DEFAULT 0
    
    
    
    
    )
AS
BEGIN
/*
1= ALIS FIFO ORT
2= SATIS FIFO ORT
*/

DECLARE @STOKAGIRLIKLI_TEMP TABLE (
    ID          Decimal(30,12),
    STOK_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_TIP    VARCHAR(10) COLLATE Turkish_CI_AS,
    HRKTIP      VARCHAR(1)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    GIRMIKTAR     Decimal(30,12),
    GIRIADEMIKTAR Decimal(30,12),
    GIRBRMTUT     Decimal(30,12),
    CIKMIKTAR     Decimal(30,12),
    CIKIADEMIKTAR Decimal(30,12),
    CIKBRMTUT     Decimal(30,12))

  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_STOK_TIP    VARCHAR(10)
  DECLARE @HRK_HRKTIP      VARCHAR(30)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_GIRMIKTAR    Decimal(30,12)
  DECLARE @HRK_GIRIADEMIK   Decimal(30,12)
  DECLARE @HRK_GIRBRMTUT    Decimal(30,12)
  DECLARE @HRK_CIKMIKTAR    Decimal(30,12)
  DECLARE @HRK_CIKIADEMIK   Decimal(30,12)
  DECLARE @HRK_CIKBRMTUT    Decimal(30,12)

  DECLARE @KALANMIK         Decimal(30,12)

  DECLARE @DUSMIK           Decimal(30,12)
  DECLARE @DUSIADEMIK       Decimal(30,12)


    /*
     --if @firmano>0
      INSERT @AGIRLIKLI_STK (STOK_KOD,STOK_AD,STOK_TIP,TARIH,HRKTIP,STOK_GRUP,
      DBASIMIKTAR,DBALSMIKTAR,
      DBASITUTAR,ALISMIKTAR,ALISTUTAR,ALISIADEMIKTAR,ALISIADETUTAR,
      ALISMIKTARIADESIZ,ALISTUTARIADESIZ,SATISMIKTAR,SATISIADEMIKTAR,
      SATISIADETUTAR,SATISTUTAR,SATISMIKTARIADESIZ,SATISTUTARIADESIZ,
      SATISMALIYET,ALISKARTUTAR,SATISKARTUTAR,SATISKARYUZDE,ALISKARYUZDE,
      DONEMSONUMIKTAR,DONEMSONUTUTAR,BRMORTFIYAT)
      SELECT k.kod,k.ad,k.tip,null,'X',g.ad,
      isnull(sum((h.giren-h.cikan)),0),
      isnull(sum( h.giren),0),
      sum( isnull(((h.giren)),0)
      *isnull((CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
      h.brmfiykdvli/(1+h.kdvyuz) END),0)),
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      case when sum(h.giren)>0 then
      round(((sum( isnull( ((h.giren)),0)
      *isnull((CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
      h.brmfiykdvli/(1+h.kdvyuz) END),0)))/sum(h.giren)),6)
      else 0 end
      FROM stokkart as k left join grup as g
      on g.id=k.grp1 
      left join stkhrk as h
      on h.firmano=@firmano and h.stkod=k.kod and h.stktip=k.tip
      and h.islmtip not in (select kod from Stk_Kriter where raptip=@RAP_TIP and sec=0)
      and (h.tarih < @TARIH1) and k.sil=0 and h.sil=0
      WHERE k.kod in (select * from CsvToSTR(@STOK_IN))
      AND k.tip=@STOK_TIP
      group by k.kod,k.ad,k.tip,g.ad
     */ 
           
      /*if @firmano=0 */
      INSERT @AGIRLIKLI_STK (STOK_KOD,STOK_AD,STOK_TIP,TARIH,HRKTIP,STOK_GRUP,
      DBASIMIKTAR,DBALSMIKTAR,
      DBASITUTAR,ALISMIKTAR,ALISTUTAR,ALISIADEMIKTAR,ALISIADETUTAR,
      ALISMIKTARIADESIZ,ALISTUTARIADESIZ,SATISMIKTAR,SATISIADEMIKTAR,
      SATISIADETUTAR,SATISTUTAR,SATISMIKTARIADESIZ,SATISTUTARIADESIZ,
      SATISMALIYET,ALISKARTUTAR,SATISKARTUTAR,SATISKARYUZDE,ALISKARYUZDE,
      DONEMSONUMIKTAR,DONEMSONUTUTAR,BRMORTFIYAT,ALISBRMORTFIYAT)
      SELECT k.kod,k.ad,k.tip,null,'X',g.ad,
      isnull(sum((h.giren-h.cikan)),0),
      isnull(sum( h.giren),0),
      sum( isnull(((h.giren)),0)
      *isnull((CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
      h.brmfiykdvli/(1+h.kdvyuz) END),0)),
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      case when sum(h.giren)>0 then
      round(((sum( isnull( ((h.giren)),0)
      *isnull((CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
      h.brmfiykdvli/(1+h.kdvyuz) END),0)))/sum(h.giren)),6)
      else 0 end,0 alisortfiyat
      FROM stokkart as k with (NOLOCK) left join grup as g with (NOLOCK)
      on g.id=k.grp1 
      left join stkhrk as h with (NOLOCK)
      on h.stkod=k.kod and h.stktip=k.tip
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
       and h.depkod in (select * from CsvToSTR(@DEPO_IN))
      and (h.tarih < @TARIH1) and k.sil=0 and h.sil=0
      WHERE k.kod in (select * from CsvToSTR(@STOK_IN))
      AND k.tip=@STOK_TIP
      group by k.kod,k.ad,k.tip,g.ad 
      
   
    /*satis miktar market */
        UPDATE @AGIRLIKLI_STK SET 
         SATISMIKTAR2=SAT_MIK,
         SATISTUTAR2=SAT_TUT
         FROM @AGIRLIKLI_STK AS T JOIN
         (select stkod,stktip,           /*S.aiademik */
         sum(case when S.cikan>0 then S.cikan else 0 end) SAT_MIK,
         SUM(CASE WHEN  @KDVTIP='Dahil' then  S.cikan*S.brmfiykdvli ELSE
         S.cikan*(S.brmfiykdvli/(1+s.kdvyuz)) END) SAT_TUT
         FROM stkhrk AS S with (NOLOCK) WHERE 
         s.stkod in (select * from CsvToSTR(@STOK_IN))
         and s.depkod in (select * from CsvToSTR(@DEPO_IN))
         and s.islmtip in ('MARSAT') 
          and s.stktip=@STOK_TIP
          AND (s.cikan>0 ) and s.sil=0
         AND (tarih >= @TARIH1) AND (tarih <= @TARIH2)
         GROUP BY  stkod,stktip) DT ON
         DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP

        
      if @DS_HSPTIP=0   /*'SON ALIS'  */
      BEGIN
       DECLARE STK_KART CURSOR FAST_FORWARD FOR
         SELECT STOK_TIP,STOK_KOD from @AGIRLIKLI_STK
       OPEN  STK_KART
       FETCH NEXT FROM STK_KART INTO
         @HRK_STOK_TIP,@HRK_STOK_KOD
          WHILE @@FETCH_STATUS = 0
            BEGIN  
             
             UPDATE @AGIRLIKLI_STK SET BRMSONALSFIYAT=BRMSONALSFIY
                 FROM @AGIRLIKLI_STK AS T JOIN
                 (SELECT TOP 1 
                    isnull(case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                    ,0) AS BRMSONALSFIY
                    from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                     and h.islmtip not in 
                    (select * from CsvToSTR(@HRK_KRITER))
                    and h.depkod in (select * from CsvToSTR(@DEPO_IN))
                    and h.tarih<=@TARIH2 and h.sil=0 and h.giren>0
                    order by h.tarih desc,h.saat desc )
                    dt on t.STOK_TIP=@HRK_STOK_TIP
                    and t.STOK_KOD=@HRK_STOK_KOD
           
             FETCH NEXT FROM STK_KART INTO
            @HRK_STOK_TIP,@HRK_STOK_KOD         
          END
   
       CLOSE STK_KART
       DEALLOCATE STK_KART

   
      END
      
      
      if @DS_HSPTIP=1   /*'SON SATIS'  */
      BEGIN
       DECLARE STK_KART CURSOR FAST_FORWARD FOR
         SELECT STOK_TIP,STOK_KOD from @AGIRLIKLI_STK
       OPEN  STK_KART
       FETCH NEXT FROM STK_KART INTO
         @HRK_STOK_TIP,@HRK_STOK_KOD
          WHILE @@FETCH_STATUS = 0
            BEGIN  
             
             UPDATE @AGIRLIKLI_STK SET BRMSONSATFIYAT=BRMSONSATFIY
                 FROM @AGIRLIKLI_STK AS T JOIN
                 (SELECT TOP 1 
                    isnull(case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                    ,0) AS BRMSONSATFIY
                    from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from CsvToSTR(@HRK_KRITER))
                    and h.depkod in (select * from CsvToSTR(@DEPO_IN))
                    and h.tarih<=@TARIH2 and h.sil=0 and h.cikan>0
                    order by h.tarih desc,h.saat desc )
                    dt on t.STOK_TIP=@HRK_STOK_TIP
                    and t.STOK_KOD=@HRK_STOK_KOD
           
             FETCH NEXT FROM STK_KART INTO
            @HRK_STOK_TIP,@HRK_STOK_KOD         
          END
   
       CLOSE STK_KART
       DEALLOCATE STK_KART

   
      END
      
 
      update @AGIRLIKLI_STK set
      BRMSAT1FIYAT=dt.BRMSAT1FIY,
      BRMSAT2FIYAT=dt.BRMSAT2FIY,
      BRMSAT3FIYAT=dt.BRMSAT3FIY,
      BRMSAT4FIYAT=dt.BRMSAT4FIY,
      BRMALSFIYAT=BRMALSFIY FROM 
      @AGIRLIKLI_STK as t join
      (select k.tip,k.kod,
       BRMSAT1FIY=case
       when k.sat1kdvtip=@KDVTIP then k.sat1fiy
       when k.sat1kdvtip='Hariç' and @KDVTIP='Dahil' then k.sat1fiy*(1+(k.sat1kdv/100))
       when k.sat1kdvtip='Dahil' and @KDVTIP='Hariç' then k.sat1fiy/(1+(k.sat1kdv/100)) end,
       BRMSAT2FIY=case when k.sat2kdvtip=@KDVTIP then k.sat2fiy
       when k.sat2kdvtip='Hariç' and @KDVTIP='Dahil' then k.sat2fiy*(1+(k.sat2kdv/100))
       when k.sat2kdvtip='Dahil' and @KDVTIP='Hariç' then k.sat2fiy/(1+(k.sat2kdv/100)) end,
       BRMSAT3FIY=case when k.sat3kdvtip=@KDVTIP then k.sat3fiy
       when k.sat3kdvtip='Hariç' and @KDVTIP='Dahil' then k.sat3fiy*(1+(k.sat3kdv/100))
       when k.sat3kdvtip='Dahil' and @KDVTIP='Hariç' then k.sat3fiy/(1+(k.sat3kdv/100)) end,
       BRMSAT4FIY=case when k.sat4kdvtip=@KDVTIP then k.sat4fiy
       when k.sat4kdvtip='Hariç' and @KDVTIP='Dahil' then k.sat4fiy*(1+(k.sat4kdv/100))
       when k.sat4kdvtip='Dahil' and @KDVTIP='Hariç' then k.sat4fiy/(1+(k.sat4kdv/100)) end,
       BRMALSFIY=case when k.alskdvtip=@KDVTIP then k.alsfiy
       when k.alskdvtip='Hariç' and @KDVTIP='Dahil' then k.alsfiy*(1+(k.alskdv/100))
       when k.alskdvtip='Dahil' and @KDVTIP='Hariç' then k.alsfiy/(1+(k.alskdv/100)) end
       FROM stokkart as k with (NOLOCK) WHERE k.kod in (select * from CsvToSTR(@STOK_IN))
       AND k.tip=@STOK_TIP) DT ON
       DT.kod=T.STOK_KOD AND DT.tip=T.STOK_TIP

     UPDATE @AGIRLIKLI_STK SET
     ALISMIKTAR=DT.ALISMIK,
     ALISTUTAR=DT.ALISTUT,
     ALISIADEMIKTAR=DT.ALISIADEMIK,
     ALISIADETUTAR=DT.ALISIADETUT,
     /*ALISMIKTARIADESIZ=DT.ALISMIKIADESIZ, */
     /*ALISTUTARIADESIZ= */
     SATISMIKTAR=DT.SATISMIK,
     SATISTUTAR=DT.SATISTUT,
     SATISIADEMIKTAR=DT.SATISIADEMIK,
     SATISIADETUTAR=DT.SATISIADETUT,
     /*SATISMIKTARIADESIZ= */
     /*SATISTUTARIADESIZ= */
     
   
      
      ALISBRMORTFIYAT=
     case when (DT.ALISMIK)>0 then
     round(((DT.ALISTUT)/(DT.ALISMIK)),6)
      else 0 end,
      
      
      DBBRMORTFIYAT=case 
      when @MALIYET_TIP=1 then /*normal agırlıklı ort. */
     ( case when (DBALSMIKTAR)>0 then
      round(((DBASITUTAR)/(DBALSMIKTAR)),6) else
      0 end)
      when @MALIYET_TIP=2 then /*donem ici agırlıklı ort. */
     ( case when (DBALSMIKTAR)>0 then
      round(((DBASITUTAR)/(DBALSMIKTAR)),6) else
      0 end)
     when @MALIYET_TIP=3 then /*kart alis fiyat */
     (BRMALSFIYAT)
     end
     
     
      
     FROM @AGIRLIKLI_STK AS T JOIN
     (select k.kod,k.tip,
     isnull(sum((h.giren)),0) AS ALISMIK,
     isnull(sum( ((h.giren))
     *(CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
     h.brmfiykdvli/(1+h.kdvyuz) END)),0) AS ALISTUT,
     isnull(sum((h.aiademik)),0) AS ALISIADEMIK,
     sum( ((h.aiademik))
     *(CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
     h.brmfiykdvli/(1+h.kdvyuz) END)) AS ALISIADETUT,

     isnull(sum((h.cikan)),0) AS SATISMIK,
     sum( ((h.cikan))
     *(CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
     h.brmfiykdvli/(1+h.kdvyuz) END)) AS SATISTUT,
     isnull(sum((h.siademik)),0) AS SATISIADEMIK,
     sum( ((h.siademik))
     *(CASE WHEN  @KDVTIP='Dahil' then h.brmfiykdvli ELSE
     h.brmfiykdvli/(1+h.kdvyuz) END)) AS SATISIADETUT

     FROM stokkart as k with (NOLOCK) inner join stkhrk as h
     on h.stkod=k.kod and h.stktip=k.tip
     and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
     and k.sil=0 and h.sil=0
     WHERE k.kod in (select * from CsvToSTR(@STOK_IN))
     and h.islmtip not in 
     (select * from CsvToSTR(@HRK_KRITER))
     AND k.tip=@STOK_TIP
     and h.depkod in (select * from CsvToSTR(@DEPO_IN))
     group by k.kod,k.tip) DT ON
     DT.kod=T.STOK_KOD AND DT.tip=T.STOK_TIP
     

    update @AGIRLIKLI_STK SET 
     BRMORTFIYAT=
     case when (ALISMIKTAR+DBASIMIKTAR)>0 then
     round(((ALISTUTAR+(DBASIMIKTAR*DBBRMORTFIYAT))/(ALISMIKTAR+DBASIMIKTAR)),6)
      else 0 end,
      SATISMALIYET=
      case 
     when @MALIYET_TIP=1 then /*normal agırlıklı ort. */
     ( SATISMIKTAR*
     case when (ALISMIKTAR+DBASIMIKTAR)>0 then
     round(((ALISTUTAR+(DBASIMIKTAR*DBBRMORTFIYAT))/(ALISMIKTAR+DBASIMIKTAR)),6) else
     0 end )
     when @MALIYET_TIP=2 then /*donem ici agırlıklı ort. */
     ( SATISMIKTAR*
     case when (ALISMIKTAR)>0 then
     round(((ALISTUTAR)/(ALISMIKTAR)),6) else
     0 end)
     when @MALIYET_TIP=3 then /*kart alis fiyat */
     (SATISMIKTAR*BRMALSFIYAT)
     end      
      
     
     
  /* FATURA ALIS SATIS MIKTAR TUTAR */
  update @AGIRLIKLI_STK set 
  FATURA_ALIS_MIK=dt.FAT_ALS_MIK,
  FATURA_SATIS_MIK=dt.FAT_SAT_MIK,
  FATURA_ALIS_TUT=dt.FAT_ALS_TUT,
  FATURA_SATIS_TUT=dt.FAT_SAT_TUT
  from @AGIRLIKLI_STK as t join
  (select h.stktip,h.stkod,
    sum(giren) FAT_ALS_MIK,
    sum(cikan) FAT_SAT_MIK,
    sum(case when @KDVTIP='Dahil' then
    (giren*H.brmfiykdvli) ELSE
    giren* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    FAT_ALS_TUT,
    sum(case when @KDVTIP='Dahil' then
    (cikan*H.brmfiykdvli) ELSE
    cikan* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    FAT_SAT_TUT
    from stkhrk as h with (NOLOCK) where 
    h.sil=0  and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
    and islmtip in (SELECT kod from fattip with (NOLOCK) where tip='FAT' )
    and h.depkod in (select * from CsvToSTR(@DEPO_IN))
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP 
    
    
    
    update @AGIRLIKLI_STK set 
    SAYAC_MIK=dt.SYC_MIK,
    SAYAC_TUT=dt.SYC_TUT
    from @AGIRLIKLI_STK as t join
    (select h.stktip,h.stkod,
    sum(cikan) SYC_MIK,
    sum(case when @KDVTIP='Dahil' then
    (cikan*H.brmfiykdvli) ELSE
    cikan* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    SYC_TUT
    from stkhrk as h with (NOLOCK) where 
    h.sil=0 and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
    and  islmtip in ('POMSAYSAT')
    and h.depkod in (select * from CsvToSTR(@DEPO_IN))
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP 
    
    
   update @AGIRLIKLI_STK set 
   FIRE_CIKIS_MIK=dt.FR_CIKIS_MIK,
   FIRE_CIKIS_TUT=dt.FR_CIKIS_TUT,
   FIRE_GIRIS_MIK=dt.FR_GIRIS_MIK,
   FIRE_GIRIS_TUT=dt.FR_GIRIS_TUT
   from @AGIRLIKLI_STK as t join
  (select h.stktip,h.stkod,
    sum(giren) FR_GIRIS_MIK,
    sum(cikan) FR_CIKIS_MIK,
    sum(case when @KDVTIP='Dahil' then
    (giren*H.brmfiykdvli) ELSE
    giren* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    FR_GIRIS_TUT,
    sum(case when @KDVTIP='Dahil' then
    (cikan*H.brmfiykdvli) ELSE
    cikan* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    FR_CIKIS_TUT
    from stkhrk as h with (NOLOCK) where 
    h.sil=0 and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
    and islmtip in ('STKFIRE')
    and h.depkod in (select * from CsvToSTR(@DEPO_IN))
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP      
    
     
     
     
     


    update @AGIRLIKLI_STK SET
    DBASITUTAR=DBASIMIKTAR*DBBRMORTFIYAT,
    ALISKARTUTAR=SATISTUTAR-SATISMALIYET,
    SATISKARTUTAR=SATISTUTAR-SATISMALIYET,
    SATISKARYUZDE=CASE WHEN ABS(SATISTUTAR)>0 THEN (SATISTUTAR-SATISMALIYET)/SATISTUTAR ELSE 0 END*100,
    ALISKARYUZDE=CASE WHEN ABS(SATISMALIYET)>0 THEN ((SATISTUTAR-SATISMALIYET))/(SATISMALIYET) ELSE 0 END*100,
    DONEMSONUMIKTAR=CASE WHEN ABS((ALISMIKTAR+DBASIMIKTAR)-SATISMIKTAR)>0 THEN ((ALISMIKTAR+DBASIMIKTAR))-(SATISMIKTAR) ELSE 0 END
   /* DONEMSONUTUTAR=((ALISMIKTAR+DBASIMIKTAR)-(SATISMIKTAR))*BRMORTFIYAT */



    if @DS_HSPTIP=0   /*'son tarihteki alis' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSONALSFIYAT
    
    if @DS_HSPTIP=1   /*'son tarihteki satis' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSONSATFIYAT
    
    
    
    if @DS_HSPTIP=2   /*'ALSFIY' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMALSFIYAT

    if @DS_HSPTIP=3   /*'SATFIY1' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT1FIYAT

    if @DS_HSPTIP=4   /*'SATFIY2' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT2FIYAT

    if @DS_HSPTIP=5   /*'SATFIY3' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT3FIYAT

    if @DS_HSPTIP=6   /*'SATFIY4' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT4FIYAT

    if @DS_HSPTIP=7   /*'ORTALS' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMORTFIYAT
    
   /*
   if @DS_HSPTIP=8   --'ORTALS'
   
   */ 
    

    if @DS_HSPTIP=9   /*'(DB+ALS)-MALIYET' */
    update @AGIRLIKLI_STK SET DONEMSONUTUTAR=
    (DBASITUTAR+ALISTUTAR)-SATISMALIYET
     





 update @AGIRLIKLI_STK set STOK_AD=DT.STOKAD,STOK_GRUP=dt.grupad from
  @AGIRLIKLI_STK as t join
 (select s.tip,s.kod,S.AD AS STOKAD,gp.ad as grupad from stokkart as s with (NOLOCK)
 left join grup as gp with (NOLOCK) on gp.id=s.grp1 )
 dt ON DT.KOD=T.STOK_KOD AND DT.tip=T.STOK_TIP



RETURN


END

================================================================================
