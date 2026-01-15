-- Function: dbo.STOKFIFODONEM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.680267
================================================================================

CREATE FUNCTION [dbo].[STOKFIFODONEM] (
@DEPO_IN		  VARCHAR(5000),
@MALIYET_TIP      int,
@HRK_KRITER       VARCHAR(4000),
@KDVTIP           VARCHAR(10),
@DS_HSPTIP        int,
@STOK_TIP         VARCHAR(20),
@STOK_IN          VARCHAR(8000),
@TARIH1           DATETIME,
@TARIH2           DATETIME)
RETURNS
   @FIFO_STK TABLE (
    TARIH                 DATETIME,
    HRKTIP                VARCHAR(1)    COLLATE Turkish_CI_AS,
    STOK_KOD              VARCHAR(30)   COLLATE Turkish_CI_AS,
    STOK_AD               VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_TIP              VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_GRUP             VARCHAR(100)  COLLATE Turkish_CI_AS,
    DBASIMIKTAR           FLOAT DEFAULT 0,
    DBASITUTAR            FLOAT DEFAULT 0,
    DBASIFIYAT            FLOAT DEFAULT 0,    
    ALISMIKTAR            FLOAT DEFAULT 0,
    ALISIADEMIKTAR        FLOAT DEFAULT 0,
    ALISIADETUTAR         FLOAT DEFAULT 0,
    ALISTUTAR             FLOAT DEFAULT 0,
    ALISMIKTARIADESIZ     FLOAT DEFAULT 0,
    ALISTUTARIADESIZ      FLOAT DEFAULT 0,
    SATISMIKTAR           FLOAT DEFAULT 0,
    SATISIADEMIKTAR       FLOAT DEFAULT 0,
    SATISIADETUTAR        FLOAT DEFAULT 0,
    SATISTUTAR            FLOAT DEFAULT 0,
    SATISMIKTARIADESIZ    FLOAT DEFAULT 0,
    SATISTUTARIADESIZ     FLOAT DEFAULT 0,
    SATISMALIYET          FLOAT DEFAULT 0,
    ALISKARTUTAR          FLOAT DEFAULT 0,
    SATISKARTUTAR         FLOAT DEFAULT 0,
    SATISKARYUZDE         FLOAT DEFAULT 0,
    ALISKARYUZDE          FLOAT DEFAULT 0,
    DONEMSONUMIKTAR       FLOAT DEFAULT 0,
    DONEMSONUTUTAR        FLOAT DEFAULT 0,
    BRMORTFIYAT           FLOAT DEFAULT 0,
    BRMSAT1FIYAT          FLOAT DEFAULT 0,
    BRMSAT2FIYAT          FLOAT DEFAULT 0,
    BRMSAT3FIYAT          FLOAT DEFAULT 0,
    BRMSAT4FIYAT          FLOAT DEFAULT 0,
    BRMALSFIYAT           FLOAT DEFAULT 0,
    BRMSONALSFIYAT        FLOAT DEFAULT 0,
    BRMSATFIYAT           FLOAT DEFAULT 0,
    BRMSONSATFIYAT        FLOAT DEFAULT 0,
    
    SATISMIKTAR2           FLOAT DEFAULT 0,
    SATISTUTAR2            FLOAT DEFAULT 0,
    
    FATURA_ALIS_MIK		  FLOAT DEFAULT 0,
    FATURA_ALIS_TUT		  FLOAT DEFAULT 0,	
    FATURA_SATIS_MIK	  FLOAT DEFAULT 0,
    FATURA_SATIS_TUT	  FLOAT DEFAULT 0,
    SAYAC_MIK		  	  FLOAT DEFAULT 0,
    SAYAC_TUT		  	  FLOAT DEFAULT 0,	
    FIRE_CIKIS_MIK	  	  FLOAT DEFAULT 0,
    FIRE_CIKIS_TUT	  	  FLOAT DEFAULT 0,
    FIRE_GIRIS_MIK	  	  FLOAT DEFAULT 0,
    FIRE_GIRIS_TUT	  	  FLOAT DEFAULT 0
    )
AS
BEGIN
/*
1= ALIS FIFO ORT
2= SATIS FIFO ORT
*/


declare @CSVSTOK_IN table
(Value   VARCHAR(30))
insert into @CSVSTOK_IN 
select * from CsvToSTR(@STOK_IN)

declare @CSVDEPO_IN table
(Value   VARCHAR(30))
insert into @CSVDEPO_IN 
select * from CsvToSTR(@DEPO_IN)

declare @CSVHRK_KRITER table
(Value   VARCHAR(30))
insert into @CSVHRK_KRITER 
select * from CsvToSTR(@HRK_KRITER)


DECLARE @STOKFIFO_TEMP TABLE (
    ID          	FLOAT,
    STOK_KOD    	VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP    	VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KDV    	FLOAT,
    HRKTIP      	VARCHAR(1)  COLLATE Turkish_CI_AS,
    TARIH       	DATETIME,
    GIRMIKTAR     	FLOAT,
    GIRIADEMIKTAR 	FLOAT,
    GIRBRMTUT     	FLOAT,
    CIKMIKTAR     	FLOAT,
    CIKIADEMIKTAR 	FLOAT,
    CIKBRMTUT     	FLOAT,
    DBSGIRBRMTUT    FLOAT)

      DECLARE @ID               FLOAT
      DECLARE @HRK_ID           FLOAT
      DECLARE @HRK_STOK_KOD     VARCHAR(30)
      DECLARE @HRK_STOK_TIP     VARCHAR(20)
      DECLARE @HRK_HRKTIP       VARCHAR(30)
      DECLARE @HRK_TARIH        DATETIME
      DECLARE @HRK_GIRMIKTAR    FLOAT
      DECLARE @HRK_GIRIADEMIK   FLOAT
      DECLARE @HRK_GIRBRMTUT    FLOAT
      DECLARE @HRK_CIKMIKTAR    FLOAT
      DECLARE @HRK_CIKIADEMIK   FLOAT
      DECLARE @HRK_CIKBRMTUT    FLOAT

      DECLARE @HRK_GIRTARIH     DATETIME
      DECLARE @HRK_DBSGIRBRMTUT FLOAT

      DECLARE @KALANMIK         FLOAT

      DECLARE @DUSMIK           FLOAT
      DECLARE @DUSIADEMIK       FLOAT


   /*-GIRISLER */
      INSERT @STOKFIFO_TEMP (ID,STOK_KOD,STOK_TIP,STOK_KDV,TARIH,
      HRKTIP,GIRMIKTAR,GIRIADEMIKTAR,
      GIRBRMTUT,CIKMIKTAR,CIKIADEMIKTAR,CIKBRMTUT,
      DBSGIRBRMTUT)
      
      SELECT max(S.id),s.stkod,S.stktip,S.kdvyuz,
      (S.tarih),'G',
      
      sum(case when S.giren>0 then S.giren else s.siademik  end) GIRMIKTAR,
      sum(case when S.siademik>0 then siademik else 0 end) GIRIADEMIKTAR,
      
      
      
      case when 
      sum(case when S.giren>0 then S.giren else S.aiademik end)>0 then 
      Sum(
      (CASE WHEN  @KDVTIP='Dahil' then  S.brmfiykdvli ELSE
      S.brmfiykdvli/(1+s.kdvyuz) END)*
      (case when S.giren>0 then S.giren else S.aiademik end)  ) / 
      sum(case when S.giren>0 then S.giren else S.aiademik end)
      else 0 end GIRBRMTUT,
      
      
      0,0,0,
      
      case when 
      sum(case when S.giren>0 then S.giren else S.aiademik end)>0 then 
      Sum(
      (CASE WHEN  @KDVTIP='Dahil' then  S.brmfiykdvli ELSE
      S.brmfiykdvli/(1+s.kdvyuz) END)*
      (case when S.giren>0 then S.giren else S.aiademik end)  ) / 
      sum(case when S.giren>0 then S.giren else S.aiademik end)
      else 0 end DBSGIRBRMTUT
      
      
      
      FROM stkhrk as s with (NOLOCK) WHERE s.stkod in 
      (select * from @CSVSTOK_IN)
      and s.depkod in (select * from @CSVDEPO_IN)
      and s.islmtip not in
      (select * from CsvToSTR(@HRK_KRITER))
      AND S.stktip=@STOK_TIP and s.sil=0
      AND (s.giren>0 or s.siademik>0)
      and (s.tarih <= @TARIH2)
      group by s.stkod,S.stktip,S.kdvyuz,S.tarih
      /*s.saat,S.brmfiykdvli */
      ORDER BY s.stkod,S.tarih
      /*,s.saat */
      

     /*--CIKISLAR */
    DECLARE STM_HRK CURSOR FAST_FORWARD FOR
    SELECT  max(S.id),
    s.stkod,S.stktip,'C',
    (S.tarih),
    /*+cast(saat as datetime)), */
    sum(case when S.cikan>0 then S.cikan else S.aiademik end) CikanMiktar,
    sum(case when S.aiademik>0 then S.aiademik else 0 end) CikanAideMiktar,
    
    
    case when 
    sum(case when S.cikan>0 then S.cikan else S.aiademik end)>0 then 
    
     Sum(
      (CASE WHEN  @KDVTIP='Dahil' then  S.brmfiykdvli ELSE
      S.brmfiykdvli/(1+s.kdvyuz) END)*
      (case when S.cikan>0 then S.cikan else S.aiademik end)  ) / 
      sum(case when S.cikan>0 then S.cikan else S.aiademik end)
 
    else 0 end CikanBirimFiyat
    
  
   
    /*0 CikanBirimFiyat */
    FROM stkhrk as s with (NOLOCK)
    WHERE s.stkod in (select * from @CSVSTOK_IN)
    and s.depkod in (select * from @CSVDEPO_IN)
    and s.islmtip not in 
    (select * from @CSVHRK_KRITER) 
    and s.stktip=@STOK_TIP
    AND (s.cikan>0 or s.aiademik>0) and s.sil=0
    AND (tarih <= @TARIH2)
    group by s.stkod,S.stktip,S.tarih
    /*,s.saat,S.brmfiykdvli,S.kdvyuz, */
    ORDER BY s.stkod,S.tarih
    /*,s.saat */

   OPEN STM_HRK

   FETCH NEXT FROM STM_HRK INTO
   @HRK_ID,@HRK_STOK_KOD ,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,
   @HRK_CIKMIKTAR,@HRK_CIKIADEMIK,@HRK_CIKBRMTUT
   WHILE @@FETCH_STATUS = 0
   BEGIN


     WHILE @HRK_CIKMIKTAR>0 BEGIN
     SET @HRK_GIRBRMTUT=0
     SET @KALANMIK=0

     SELECT top 1 @ID=ID,@KALANMIK=ISNULL((GIRMIKTAR-CIKMIKTAR),0),
     @HRK_GIRBRMTUT=ISNULL(GIRBRMTUT,0),
     @HRK_GIRTARIH=TARIH
     FROM @STOKFIFO_TEMP WHERE STOK_TIP=@HRK_STOK_TIP
     AND STOK_KOD=@HRK_STOK_KOD
     AND (GIRMIKTAR-CIKMIKTAR)>0 AND HRKTIP='G' ORDER BY TARIH
     
     
     /* DONEM BASI BRM FIYAT */
     SET @HRK_DBSGIRBRMTUT=0
     IF @HRK_GIRTARIH<@TARIH1
       SET @HRK_DBSGIRBRMTUT=@HRK_GIRBRMTUT




     IF @KALANMIK=0
     BEGIN
      SET @DUSMIK=@HRK_CIKMIKTAR
       SET @HRK_GIRBRMTUT=0
     END
     ELSE
      BEGIN

       /*IF (@HRK_CIKMIKTAR+@HRK_CIKIADEMIK)>=@KALANMIK */
       IF (@HRK_CIKMIKTAR)>=@KALANMIK
        BEGIN
         SET @DUSMIK=@KALANMIK
     /* SET @DUSIADEMIK=@HRK_CIKIADEMIK */
        END
       ELSE
        BEGIN
         SET @DUSMIK=@HRK_CIKMIKTAR
         /* SET @DUSIADEMIK=@HRK_CIKIADEMIK */
        END


      END /*else */

      INSERT @STOKFIFO_TEMP (ID,STOK_KOD,STOK_TIP,HRKTIP,TARIH,
      GIRMIKTAR,GIRIADEMIKTAR,GIRBRMTUT,CIKMIKTAR,
      CIKIADEMIKTAR,CIKBRMTUT,DBSGIRBRMTUT)
      VALUES (@HRK_ID,@HRK_STOK_KOD,@HRK_STOK_TIP,'C',
      @HRK_TARIH,-1*@DUSMIK,-1*@DUSIADEMIK,@HRK_GIRBRMTUT,
      @DUSMIK,@DUSIADEMIK,@HRK_CIKBRMTUT,@HRK_DBSGIRBRMTUT)

      /*------------------------------------------------- */
      UPDATE @STOKFIFO_TEMP SET CIKMIKTAR=CIKMIKTAR+@DUSMIK
      WHERE ID=@ID AND (GIRMIKTAR-CIKMIKTAR)>0
      /*-------------------------------------------------- */

      SET @HRK_CIKMIKTAR=@HRK_CIKMIKTAR-@DUSMIK
    END

   FETCH NEXT FROM STM_HRK INTO
   @HRK_ID,@HRK_STOK_KOD ,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIKTAR,@HRK_CIKIADEMIK,@HRK_CIKBRMTUT
  END

  CLOSE STM_HRK
  DEALLOCATE STM_HRK


/*
  INSERT @FIFO_STK (HRKTIP,TARIH,STOK_KOD,STOK_TIP,DBASIMIKTAR,DBASITUTAR,ALISMIKTAR,ALISTUTAR)
  select HRKTIP,TARIH,STOK_KOD,STOK_TIP,GIRMIKTAR,GIRBRMTUT,CIKMIKTAR,CIKBRMTUT    from @STOKFIFO_TEMP
*/
/*----DONEM BASI TUTAR ALINIYOR TARIHTEN ONCEKI STOKLAR VE TUTAR */

  
     INSERT @FIFO_STK (STOK_KOD,STOK_TIP,BRMORTFIYAT,
     BRMSAT1FIYAT,BRMSAT2FIYAT,BRMSAT3FIYAT,BRMSAT4FIYAT,BRMALSFIYAT,
     SATISMIKTAR2,SATISTUTAR2)
     SELECT s.kod,s.tip,0,
     case
     when s.sat1kdvtip=@KDVTIP then s.sat1fiy
     when s.sat1kdvtip='Hariç' and @KDVTIP='Dahil' then s.sat1fiy*(1+(s.sat1kdv/100))
     when s.sat1kdvtip='Dahil' and @KDVTIP='Hariç' then s.sat1fiy/(1+(s.sat1kdv/100)) end,
     case when s.sat2kdvtip=@KDVTIP then s.sat2fiy
     when s.sat2kdvtip='Hariç' and @KDVTIP='Dahil' then s.sat2fiy*(1+(s.sat2kdv/100))
     when s.sat2kdvtip='Dahil' and @KDVTIP='Hariç' then s.sat2fiy/(1+(s.sat2kdv/100)) end,
     case when s.sat3kdvtip=@KDVTIP then s.sat3fiy
     when s.sat3kdvtip='Hariç' and @KDVTIP='Dahil' then s.sat3fiy*(1+(s.sat3kdv/100))
     when s.sat3kdvtip='Dahil' and @KDVTIP='Hariç' then s.sat3fiy/(1+(s.sat3kdv/100)) end,
     case when s.sat4kdvtip=@KDVTIP then s.sat4fiy
     when s.sat4kdvtip='Hariç' and @KDVTIP='Dahil' then s.sat4fiy*(1+(s.sat4kdv/100))
     when s.sat4kdvtip='Dahil' and @KDVTIP='Hariç' then s.sat4fiy/(1+(s.sat4kdv/100)) end,
     case when s.alskdvtip=@KDVTIP then s.alsfiy
     when s.alskdvtip='Hariç' and @KDVTIP='Dahil' then s.alsfiy*(1+(s.alskdv/100))
     when s.alskdvtip='Dahil' and @KDVTIP='Hariç' then s.alsfiy/(1+(s.alskdv/100)) end,
     0,0
      from stokkart as s with (NOLOCK)
     where s.tip=@STOK_TIP and s.kod in (select * from @CSVSTOK_IN)
     /*VALUES (@STOK_KOD,@STOK_TIP) */
     
     /*satis miktar market  */
     
         UPDATE @FIFO_STK SET 
         SATISMIKTAR2=SAT_MIK,
         SATISTUTAR2=SAT_TUT
         FROM @FIFO_STK AS T JOIN
         (select stkod,stktip,           /*S.aiademik */
         sum(case when S.cikan>0 then S.cikan else 0 end) SAT_MIK,
         SUM(CASE WHEN  @KDVTIP='Dahil' then  S.cikan*S.brmfiykdvli ELSE
         S.cikan*(S.brmfiykdvli/(1+s.kdvyuz)) END) SAT_TUT
         FROM stkhrk AS S with (NOLOCK) WHERE 
         s.stkod in (select * from @CSVSTOK_IN)
         and s.depkod in (select * from @CSVDEPO_IN)
         and s.islmtip in ('MARSAT') 
          and s.stktip=@STOK_TIP
          AND (s.cikan>0 ) and s.sil=0
         AND (tarih >= @TARIH1) AND (tarih <= @TARIH2)
         GROUP BY  stkod,stktip) DT ON
         DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP
     
     
     
     
     
     if (@DS_HSPTIP=0) or (@DS_HSPTIP=1)   /*'SON ALIS'  */
      BEGIN
       DECLARE STK_KART CURSOR FAST_FORWARD FOR
         SELECT STOK_TIP,STOK_KOD from @FIFO_STK
       OPEN  STK_KART
       FETCH NEXT FROM STK_KART INTO
         @HRK_STOK_TIP,@HRK_STOK_KOD
          WHILE @@FETCH_STATUS = 0
            BEGIN  
            
            declare @SONTUTAR FLOAT
            
            declare @DBASIFIYAT FLOAT
            
            
            SET @SONTUTAR=0
            
            SET @DBASIFIYAT=0 
           
            
            
            if (@DS_HSPTIP=0) 
             begin
             
               declare @EvrakTarih datetime
               declare @EvrakSaat  datetime
               declare @KdvYuz  float
               
                       
             
                    SELECT TOP 1 @EvrakTarih=h.tarih,@EvrakSaat=h.saat,
                    @KdvYuz=h.kdvyuz,
                    @SONTUTAR=case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                     from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih<=@TARIH2 and h.sil=0 and h.giren>0
                    and h.brmfiykdvli>0 and h.islmtip<>'MARIAD'
                    order by h.tarih desc,h.saat desc 
                 
                  /*Ayn1 Zaman Dilinde 1 den fazla Kay1t Varsa  */
                    if (Select Count(id) from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih=@EvrakTarih and h.saat=@EvrakSaat 
                    and h.sil=0 and h.giren>0
                    and h.brmfiykdvli>0 and h.islmtip<>'MARIAD')>1
                    begin
                    
                      SELECT @SONTUTAR=case when @KDVTIP='Dahil' then 
                       sum(h.brmfiykdvli*h.giren)/sum(h.giren)
                       else
                         (sum(h.brmfiykdvli*h.giren)/sum(h.giren))/(1+@KdvYuz) 
                       end
                       from stkhrk as h with (NOLOCK)
                       where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                       and h.islmtip not in 
                       (select * from @CSVHRK_KRITER) 
                       and h.depkod in (select * from @CSVDEPO_IN)
                       and h.tarih=@EvrakTarih and h.saat=@EvrakSaat 
                       and h.sil=0 and h.giren>0
                       and h.brmfiykdvli>0 and h.islmtip<>'MARIAD'
                       

                     end 
          
          
          
                    SELECT TOP 1 @EvrakTarih=h.tarih,@EvrakSaat=h.saat,
                    @KdvYuz=h.kdvyuz,
                    @DBASIFIYAT=case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                     from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih<@TARIH1 and h.sil=0 and h.giren>0
                    and h.brmfiykdvli>0 and h.islmtip<>'MARIAD'
                    order by h.tarih desc,h.saat desc 
            
                    
                    /*Ayn1 Zaman Dilinde 1 den fazla Kay1t Varsa  */
                    if (Select Count(id) from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih=@EvrakTarih and h.saat=@EvrakSaat 
                    and h.sil=0 and h.giren>0
                    and h.brmfiykdvli>0 and h.islmtip<>'MARIAD')>1
                    begin
                    
                      SELECT @DBASIFIYAT=case when @KDVTIP='Dahil' then 
                       sum(h.brmfiykdvli*h.giren)/sum(h.giren) 
                        else
                         (sum(h.brmfiykdvli*h.giren)/sum(h.giren))/(1+@KdvYuz) 
                        end
                       from stkhrk as h with (NOLOCK)
                       where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                       and h.islmtip not in 
                       (select * from @CSVHRK_KRITER) 
                       and h.depkod in (select * from @CSVDEPO_IN)
                       and h.tarih=@EvrakTarih and h.saat=@EvrakSaat 
                       and h.sil=0 and h.giren>0
                       and h.brmfiykdvli>0 and h.islmtip<>'MARIAD'
                      

                     end  
                    
                    
                    
                    
                    
          
               end

      
                         
                 if (@DS_HSPTIP=1)
                  begin
  

                  SELECT TOP 1 @SONTUTAR=case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                     from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih<=@TARIH2 and h.sil=0 and h.cikan>0
                    and h.brmfiykdvli>0
                    order by h.tarih desc,h.saat desc 

                    SELECT TOP 1 @DBASIFIYAT=case when @KDVTIP='Dahil' then 
                    h.brmfiykdvli else (h.brmfiykdvli/(1+(h.kdvyuz))) end
                     from stkhrk as h with (NOLOCK)
                    where stktip=@HRK_STOK_TIP and stkod=@HRK_STOK_KOD
                    and h.islmtip not in 
                    (select * from @CSVHRK_KRITER) 
                    and h.depkod in (select * from @CSVDEPO_IN)
                    and h.tarih<@TARIH1 and h.sil=0 and h.cikan>0
                    and h.brmfiykdvli>0
                    order by h.tarih desc,h.saat desc 
                    
               end
               
                                  
             
             UPDATE @FIFO_STK SET DBASIFIYAT=isnull(@DBASIFIYAT,0),
             BRMSONALSFIYAT=isnull(@SONTUTAR,0)
             WHERE  STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                                 
           
             FETCH NEXT FROM STK_KART INTO
            @HRK_STOK_TIP,@HRK_STOK_KOD         
          END
   
       CLOSE STK_KART
       DEALLOCATE STK_KART

   
      END
     

     if @DS_HSPTIP=7   /*'ORTALS' */
      begin
         UPDATE @FIFO_STK SET BRMORTFIYAT=BRMORTFIY
         FROM @FIFO_STK AS T JOIN
         (select STOK_KOD,STOK_TIP,
         case when
         sum(GIRMIKTAR)>0 and @KDVTIP='Dahil' then
         /*round( */
         SUM(GIRBRMTUT*GIRMIKTAR)/sum(GIRMIKTAR)
         /*,6) */
         when sum(GIRMIKTAR)>0 and @KDVTIP='Hariç' then
         /*round( */
         SUM( (GIRBRMTUT*GIRMIKTAR)/1+(STOK_KDV))/sum(GIRMIKTAR)
         /*,6) */
         else 0 end BRMORTFIY FROM @STOKFIFO_TEMP
         WHERE TARIH <= @TARIH2 AND HRKTIP='G' GROUP BY STOK_KOD,STOK_TIP) DT ON
         DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP
         
         
         
         
         UPDATE @FIFO_STK SET DBASIFIYAT=DBASIFIY
         FROM @FIFO_STK AS T JOIN
         (select STOK_KOD,STOK_TIP,
         case when
         sum(GIRMIKTAR)>0 and @KDVTIP='Dahil' then
         /*round( */
         SUM(GIRBRMTUT*GIRMIKTAR)/sum(GIRMIKTAR)
         /*,6) */
         when sum(GIRMIKTAR)>0 and @KDVTIP='Hariç' then
         /*round( */
         SUM( (GIRBRMTUT*GIRMIKTAR)/1+(STOK_KDV))/sum(GIRMIKTAR)
         /*,6) */
         else 0 end DBASIFIY FROM @STOKFIFO_TEMP
         WHERE TARIH < @TARIH1 AND HRKTIP='G' GROUP BY STOK_KOD,STOK_TIP) DT ON
         DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP
         
  
 
       end
      

     if @DS_HSPTIP=8   /*'SON_GRS KAYDINA GORE ORTALS' */
      begin
         UPDATE @FIFO_STK SET BRMORTFIYAT=BRMORTFIY
         FROM @FIFO_STK AS T JOIN (select STOK_KOD,STOK_TIP,
         case when 
         sum(GIRMIKTAR-CIKMIKTAR)>0 and @KDVTIP='Dahil' then
         (SUM(GIRBRMTUT*GIRMIKTAR)-SUM(GIRBRMTUT*CIKMIKTAR))
         /SUM(GIRMIKTAR-CIKMIKTAR)
         
         when sum(GIRMIKTAR-CIKMIKTAR)>0 and @KDVTIP='Hariç' then
         (SUM( (GIRBRMTUT*GIRMIKTAR)/1+(STOK_KDV)) 
          - SUM((GIRBRMTUT*CIKMIKTAR)/1+(STOK_KDV)))
          /SUM(GIRMIKTAR-CIKMIKTAR)
          
          else 0 end BRMORTFIY FROM @STOKFIFO_TEMP
         WHERE TARIH <= @TARIH2 AND HRKTIP='G' 
         GROUP BY STOK_KOD,STOK_TIP) DT ON
         DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP
         
         
         
         UPDATE @FIFO_STK SET DBASIFIYAT=DBASIFIY
         FROM @FIFO_STK AS T JOIN (select STOK_KOD,STOK_TIP,
         case when 
         sum(GIRMIKTAR-CIKMIKTAR)>0 and @KDVTIP='Dahil' then
         (SUM(GIRBRMTUT*GIRMIKTAR)-SUM(GIRBRMTUT*CIKMIKTAR))
         /SUM(GIRMIKTAR-CIKMIKTAR)
         
         when sum(GIRMIKTAR-CIKMIKTAR)>0 and @KDVTIP='Hariç' then
         (SUM( (GIRBRMTUT*GIRMIKTAR)/1+(STOK_KDV)) 
          - SUM((GIRBRMTUT*CIKMIKTAR)/1+(STOK_KDV)))
          /SUM(GIRMIKTAR-CIKMIKTAR)
          
          else 0 end DBASIFIY FROM @STOKFIFO_TEMP
         WHERE TARIH < @TARIH1 AND HRKTIP='G' 
         GROUP BY STOK_KOD,STOK_TIP) DT ON
         DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP  
         
           
      end
 
     UPDATE @FIFO_STK SET DBASIMIKTAR=DT.DBASMIKTAR,
     DBASITUTAR=DT.DBASTUTAR
     FROM @FIFO_STK AS T JOIN
     (select STOK_KOD,STOK_TIP,
     ISNULL(SUM(GIRMIKTAR),0) AS DBASMIKTAR,
     ISNULL(SUM((DBSGIRBRMTUT*GIRMIKTAR)),0) AS DBASTUTAR
     FROM @STOKFIFO_TEMP
     WHERE TARIH < @TARIH1
     GROUP BY STOK_KOD,STOK_TIP) DT ON
     DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP
     
     
     UPDATE @FIFO_STK
     SET
     ALISIADEMIKTAR=DT.ALISIADEMIKTAR,
     ALISIADETUTAR=DT.ALISIADETUTAR,
     SATISIADEMIKTAR=DT.SATISIADEMIKTAR,
     SATISIADETUTAR=DT.SATISIADETUTAR
     FROM @FIFO_STK AS T JOIN
     (select stkod,stktip,
     ISNULL(SUM(aiademik),0) AS ALISIADEMIKTAR,
     ISNULL(SUM((aiademik*CASE WHEN  @KDVTIP='Dahil' then  S.brmfiykdvli ELSE
     S.brmfiykdvli/(1+s.kdvyuz) END)),0) AS ALISIADETUTAR,
     ISNULL(SUM(siademik),0) AS SATISIADEMIKTAR,
     ISNULL(SUM((siademik*CASE WHEN  @KDVTIP='Dahil' then  S.brmfiykdvli ELSE
      S.brmfiykdvli/(1+s.kdvyuz) END)),0) AS SATISIADETUTAR
     FROM stkhrk as s with (NOLOCK)
     WHERE s.stkod in (select * from @CSVSTOK_IN)
     and s.islmtip not in 
     (select * from @CSVHRK_KRITER) 
     and s.stktip=@STOK_TIP
     and s.depkod in (select * from @CSVDEPO_IN)
     and s.tarih >= @TARIH1 and s.tarih <= @TARIH2
     GROUP BY stkod,stktip) DT ON
     DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP
    

   /*----ALIS TUTAR ALINIYOR */
   UPDATE @FIFO_STK SET ALISMIKTAR=DT.ALISMIK,
    /*ALISIADEMIKTAR=DT.ALISIADEMIK, */
    /*ALISIADETUTAR=DT.ALISIADETUT, */
    /*ALISMIKTARIADESIZ=DT.ALISMIK-DT.ALISIADEMIK, */
   /* ALISTUTARIADESIZ=DT.ALISTUT-DT.ALISIADETUT, */
    ALISTUTAR=DT.ALISTUT FROM @FIFO_STK AS T JOIN
    (select STOK_KOD,STOK_TIP,
    ISNULL(SUM(GIRMIKTAR),0) AS ALISMIK,
    ISNULL(SUM(GIRIADEMIKTAR),0) AS ALISIADEMIK,
    ISNULL(SUM(GIRIADEMIKTAR*GIRMIKTAR),0) AS ALISIADETUT,
    ISNULL(SUM(GIRBRMTUT*GIRMIKTAR),0) AS ALISTUT
    FROM @STOKFIFO_TEMP
    WHERE HRKTIP='G' AND TARIH >= @TARIH1
    GROUP BY STOK_KOD,STOK_TIP) DT 
    ON DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP

   /*----SATIS TUTAR ALINIYOR */
    UPDATE @FIFO_STK SET
    SATISMALIYET=DT.SATISMAL,
    SATISMIKTAR=DT.SATISMIK,
    /*ALISMIKTARIADESIZ=ALISMIKTARIADESIZ-DT.SATISIADEMIK, */
    /*ALISTUTARIADESIZ=ALISTUTARIADESIZ-DT.SATISIADETUT, */
    /*SATISIADETUTAR=DT.SATISIADETUT, */
    /*SATISIADEMIKTAR=DT.SATISIADEMIK, */
    /*SATISMIKTARIADESIZ=DT.SATISMIK-(DT.SATISIADEMIK+ALISIADEMIKTAR), */
    /*SATISTUTARIADESIZ=DT.SATISTUT-(DT.SATISIADETUT+ALISIADETUTAR), */
    SATISTUTAR=DT.SATISTUT FROM @FIFO_STK AS T JOIN
    (select STOK_KOD,STOK_TIP,
    ISNULL(SUM(CIKMIKTAR),0) AS SATISMIK,
    /*ISNULL(SUM(CIKIADEMIKTAR),0) AS SATISIADEMIK, */
    /*ISNULL(SUM(CIKIADEMIKTAR*CIKBRMTUT),0) AS SATISIADETUT, */
    ISNULL(SUM(CIKMIKTAR*CIKBRMTUT),0) AS SATISTUT,
    ISNULL(SUM(CIKMIKTAR*GIRBRMTUT),0) AS SATISMAL
    FROM @STOKFIFO_TEMP
    WHERE HRKTIP='C' AND TARIH >= @TARIH1
    GROUP BY STOK_KOD,STOK_TIP) DT 
    ON DT.STOK_KOD=T.STOK_KOD AND DT.STOK_TIP=T.STOK_TIP


   /*--SATIS KAR */
    UPDATE @FIFO_STK SET SATISKARTUTAR=SATISTUTAR-SATISMALIYET,
    ALISKARTUTAR=SATISTUTAR-SATISMALIYET,                                    /*ALISTUTAR */
    SATISKARYUZDE=CASE WHEN ABS(SATISTUTAR)>0 THEN 
    (SATISTUTAR-SATISMALIYET)/SATISTUTAR ELSE 0 END*100,
    ALISKARYUZDE=CASE WHEN ABS(SATISMALIYET)>0 THEN 
    ((SATISTUTAR-SATISMALIYET))/(SATISMALIYET) ELSE 0 END*100,
    DONEMSONUMIKTAR=CASE WHEN ABS((ALISMIKTAR+DBASIMIKTAR)-SATISMIKTAR)>0 THEN
     ((ALISMIKTAR+DBASIMIKTAR))-(SATISMIKTAR) ELSE 0 END


    /*,DONEMSONUTUTAR=CASE WHEN ABS(((ALISMIKTAR+DBASIMIKTAR))-(SATISMIKTAR))>0 THEN ((ALISTUTAR+DBASITUTAR))-(SATISMALIYET) */
   /* ELSE 0 END */

    if @DS_HSPTIP=0   /*'son tarihteki alis' */
      update @FIFO_STK SET 
       DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSONALSFIYAT,
       DBASITUTAR=DBASIMIKTAR*DBASIFIYAT
    
    
    if @DS_HSPTIP=1   /*'son tarihteki satis' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSONSATFIYAT,
       DBASITUTAR=DBASIMIKTAR*DBASIFIYAT
   
    if @DS_HSPTIP=2   /*'ALSFIY' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMALSFIYAT,
       DBASITUTAR=DBASIMIKTAR*BRMALSFIYAT

    if @DS_HSPTIP=3   /*'SATFIY1' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT1FIYAT,
       DBASITUTAR=DBASIMIKTAR*BRMSAT1FIYAT

    if @DS_HSPTIP=4   /*'SATFIY2' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT2FIYAT,
       DBASITUTAR=DBASIMIKTAR*BRMSAT2FIYAT

    if @DS_HSPTIP=5   /*'SATFIY3' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT3FIYAT,
       DBASITUTAR=DBASIMIKTAR*BRMSAT3FIYAT

    if @DS_HSPTIP=6   /*'SATFIY4' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMSAT4FIYAT,
       DBASITUTAR=DBASIMIKTAR*BRMSAT4FIYAT

    if @DS_HSPTIP=7   /*'ORTALS' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMORTFIYAT,
       DBASITUTAR=DBASIMIKTAR*DBASIFIYAT
   

    if @DS_HSPTIP=8   /*'GONGIRORTALS' */
    update @FIFO_STK SET DONEMSONUTUTAR=DONEMSONUMIKTAR*BRMORTFIYAT,
       DBASITUTAR=DBASIMIKTAR*DBASIFIYAT

   
   if @DS_HSPTIP=9   /*'(DB+ALS)-MALIYET' */
    update @FIFO_STK SET 
     /*DBASITUTAR=DBASIMIKTAR*DBASIFIYAT, */
     /*DONEMSONUTUTAR=((DBASIMIKTAR*DBASIFIYAT)+ALISTUTAR)-SATISMALIYET */
     DONEMSONUTUTAR=(DBASITUTAR+ALISTUTAR)-SATISMALIYET
       
 /* FATURA ALIS SATIS MIKTAR TUTAR */
  update @FIFO_STK set 
  FATURA_ALIS_MIK=dt.FAT_ALS_MIK,
  FATURA_SATIS_MIK=dt.FAT_SAT_MIK,
  FATURA_ALIS_TUT=dt.FAT_ALS_TUT,
  FATURA_SATIS_TUT=dt.FAT_SAT_TUT
  from @FIFO_STK as t join
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
    from stkhrk as h  with (NOLOCK) where 
    h.sil=0  and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
    and h.islmtip in (SELECT kod from fattip with (NOLOCK) where tip='FAT' )
    and h.depkod in (select * from @CSVDEPO_IN)
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP 
    
    
   /*
    update @FIFO_STK set 
    SAYAC_MIK=dt.SYC_MIK,
    SAYAC_TUT=dt.SYC_TUT
    from @FIFO_STK as t join
    (select h.stktip,h.stkod,
    sum(cikan) SYC_MIK,
    sum(case when @KDVTIP='Dahil' then
    (cikan*H.brmfiykdvli) ELSE
    cikan* (H.brmfiykdvli/(1+H.kdvyuz))  end)
    SYC_TUT
    from stkhrk as h with (NOLOCK) where 
    h.sil=0 and h.tarih >= @TARIH1 and h.tarih <= @TARIH2
    and  h.islmtip in ('POMSAYSAT')
    and h.depkod in (select * from @CSVDEPO_IN)
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP 
    
    
   update @FIFO_STK set 
   FIRE_CIKIS_MIK=dt.FR_CIKIS_MIK,
   FIRE_CIKIS_TUT=dt.FR_CIKIS_TUT,
   FIRE_GIRIS_MIK=dt.FR_GIRIS_MIK,
   FIRE_GIRIS_TUT=dt.FR_GIRIS_TUT
   from @FIFO_STK as t join
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
    and h.islmtip in ('STKFIRE')
    and h.depkod in (select * from @CSVDEPO_IN)
    group by h.stktip,h.stkod )
    dt ON DT.stkod=T.STOK_KOD AND DT.stktip=T.STOK_TIP      
  
*/
   update @FIFO_STK set STOK_AD=DT.STOKAD,STOK_GRUP=dt.grupad from
    @FIFO_STK as t join
   (select s.tip,s.kod,S.AD AS STOKAD,gp.ad as grupad from stokkart as s with (NOLOCK)
   left join grup as gp with (NOLOCK) on gp.id=s.grp1 )
   dt ON DT.KOD=T.STOK_KOD AND DT.tip=T.STOK_TIP


  
RETURN


END

================================================================================
