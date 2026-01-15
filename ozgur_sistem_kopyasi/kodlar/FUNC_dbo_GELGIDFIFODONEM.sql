-- Function: dbo.GELGIDFIFODONEM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.660911
================================================================================

CREATE FUNCTION [dbo].GELGIDFIFODONEM (
/*@firmano          	int, */
@KDVTIP 			VARCHAR(10),
@STOK_TIP 			VARCHAR(20),
@STOK_KOD 			VARCHAR(30),
@TARIH1 			DATETIME,
@TARIH2 			DATETIME)
RETURNS
   @FIFO_STK TABLE (
    TARIH        		DATETIME,
    HRKTIP       		VARCHAR(1)  COLLATE Turkish_CI_AS,
    STOK_KOD    		VARCHAR(30)  COLLATE Turkish_CI_AS,
    STOK_AD    			VARCHAR(150)   COLLATE Turkish_CI_AS,
    STOK_TIP    		VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_GRUP    		VARCHAR(50) COLLATE Turkish_CI_AS,
    DBASIMIKTAR  		FLOAT DEFAULT 0,
    DBASITUTAR   		FLOAT DEFAULT 0,
    ALISMIKTAR   		FLOAT DEFAULT 0,
    ALISTUTAR    		FLOAT DEFAULT 0,
    SATISMIKTAR  		FLOAT DEFAULT 0,
    SATISTUTAR   		FLOAT DEFAULT 0,
    SATISMALIYET 		FLOAT DEFAULT 0,
    ALISKARTUTAR      	FLOAT DEFAULT 0,
    SATISKARTUTAR     	FLOAT DEFAULT 0,
    SATISKARYUZDE     	FLOAT DEFAULT 0,
    ALISKARYUZDE      	FLOAT DEFAULT 0,
    DONEMSONUMIKTAR   	FLOAT DEFAULT 0,
    DONEMSONUTUTAR    	FLOAT DEFAULT 0,
    BRMORTFIYAT       	FLOAT DEFAULT 0,
    SATISMIKTAR2        FLOAT DEFAULT 0,
    SATISTUTAR2         FLOAT DEFAULT 0)
AS
BEGIN
/*
1= ALIS FIFO ORT
2= SATIS FIFO ORT
*/


DECLARE @STOKFIFO_TEMP TABLE (
    ID          		FLOAT,
    STOK_KOD    		VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP    		VARCHAR(20) COLLATE Turkish_CI_AS,
    HRKTIP      		VARCHAR(1)  COLLATE Turkish_CI_AS,
    TARIH       		DATETIME,
    GIRMIKTAR    		FLOAT,
    GIRBRMTUT    		FLOAT,
    CIKMIKTAR    		FLOAT,
    CIKBRMTUT    		FLOAT)

  DECLARE @ID              FLOAT
  DECLARE @HRK_ID          FLOAT
  DECLARE @HRK_STOK_KOD    VARCHAR(30)
  DECLARE @HRK_STOK_TIP    VARCHAR(10)
  DECLARE @HRK_HRKTIP      VARCHAR(30)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_GIRMIKTAR    FLOAT
  DECLARE @HRK_GIRBRMTUT    FLOAT
  DECLARE @HRK_CIKMIKTAR    FLOAT
  DECLARE @HRK_CIKBRMTUT    FLOAT

  DECLARE @KALANMIK         FLOAT

  DECLARE @DUSMIK           FLOAT

  /*----GIRISLER */

/*  if @firmano=0 */
  if @KDVTIP='Dahil'
  INSERT @FIFO_STK (STOK_KOD,STOK_TIP,STOK_AD,STOK_GRUP,
  DBASIMIKTAR,DBASITUTAR,ALISMIKTAR,ALISTUTAR,SATISMIKTAR,SATISTUTAR,
  SATISMALIYET,ALISKARTUTAR,ALISKARYUZDE,
  SATISKARTUTAR,SATISKARYUZDE,DONEMSONUMIKTAR,
  DONEMSONUTUTAR,BRMORTFIYAT)
  SELECT k.kod,S.cartip,k.ad,gp.ad,
  0,0,
  isnull(case when SUM(s.borc-S.alacak) >0 then count(*) end,0),
  isnull(case when SUM(s.borc-S.alacak) >0 then SUM(s.borc-S.alacak) end,0),
  isnull(case when SUM(s.borc-S.alacak) <0 then count(*) end,0),
  isnull(case when SUM(s.borc-S.alacak) <0 then SUM(s.borc-S.alacak) end,0),
  isnull(case when SUM(s.borc-S.alacak) <0 then 0 else SUM(s.borc-S.alacak) end,0),
  -1*isnull(SUM(s.borc-S.alacak),0),
  isnull(case when SUM(s.borc-S.alacak) >0 then -100 else 100 end,0),
  -1*isnull(SUM(s.borc-S.alacak),0),
  isnull(case when SUM(s.borc-S.alacak) >0 then -100 else 100 end,0),
  0,0,0
  FROM gelgidkart as k with (NOLOCK)
  left join carihrk as s with (NOLOCK)
  on s.carkod=k.kod and s.sil=0
  and (s.tarih >= @TARIH1)
  and (s.tarih <= @TARIH2)
  left join grup as gp with (NOLOCK) on gp.id=k.grp1
  where s.carkod=@STOK_KOD AND S.cartip=@STOK_TIP
  
  group by k.kod,S.cartip,k.ad,gp.ad
  
  
  if @KDVTIP='Hariç'
  INSERT @FIFO_STK (STOK_KOD,STOK_TIP,STOK_AD,STOK_GRUP,
  DBASIMIKTAR,DBASITUTAR,ALISMIKTAR,ALISTUTAR,SATISMIKTAR,SATISTUTAR,
  SATISMALIYET,ALISKARTUTAR,ALISKARYUZDE,
  SATISKARTUTAR,SATISKARYUZDE,DONEMSONUMIKTAR,
  DONEMSONUTUTAR,BRMORTFIYAT)
  SELECT k.kod,S.cartip,k.ad,gp.ad,
  0,0,
  isnull(case when SUM(s.borc-S.alacak) >0 then count(*) end,0),/*Alis Miktar */
  isnull(case when SUM(s.borc-S.alacak) >0 then SUM((s.borc-S.alacak)/(1+(s.kdvyuz))) end,0),/*Alis Tutar */
  isnull(case when SUM(s.borc-S.alacak) <0 then count(*) end,0),  /*Satis Miktar */
  isnull(case when SUM(s.borc-S.alacak) <0 then SUM((s.borc-S.alacak)/(1+(s.kdvyuz))) end,0), /*Satis Tutar */
  isnull(case when SUM(s.borc-S.alacak) <0 then 0 else SUM((s.borc-S.alacak)/(1+(s.kdvyuz))) end,0), /*Satis Maliyet */
  -1*isnull(SUM((s.borc-S.alacak)/(1+(s.kdvyuz))),0),   /*AlisKarTutar */
  isnull(case when SUM((s.borc-S.alacak)/(1+(s.kdvyuz))) >0 then -100 else 100 end,0), /*KarYuzde */
  -1*isnull(SUM((s.borc-S.alacak)/(1+(s.kdvyuz))),0), 
  isnull(case when SUM((s.borc-S.alacak)/(1+(s.kdvyuz))) >0 then -100 else 100 end,0),
  0,0,0
  FROM gelgidkart as k with (NOLOCK)
  left join carihrk as s with (NOLOCK)
  on s.carkod=k.kod and s.sil=0
  and (s.tarih >= @TARIH1)
  and (s.tarih <= @TARIH2)
  left join grup as gp with (NOLOCK) on gp.id=k.grp1
  where s.carkod=@STOK_KOD AND S.cartip=@STOK_TIP
  and s.islmtip+'_'+s.islmhrk <> 'GLG_FIK'
  
  group by k.kod,S.cartip,k.ad,gp.ad
  
  
  
   
  
   UPDATE @FIFO_STK SET SATISMIKTAR2=SATISMIKTAR,SATISTUTAR2=SATISTUTAR
  
 
  
RETURN


END

================================================================================
