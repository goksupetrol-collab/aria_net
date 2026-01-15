-- Function: dbo.UDF_DEPO_MARKET_GENEL
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.710611
================================================================================

CREATE FUNCTION [dbo].UDF_DEPO_MARKET_GENEL (
@DEPO_KOD VARCHAR(20),
@GRP1_ID INT,@GRP2_ID INT,
@GRP3_ID INT,
@DEVIR INT)
RETURNS
 @TB_DEPO_TARIH_HRK TABLE (
    DEPO_TIP      VARCHAR(20)   COLLATE Turkish_CI_AS,
    DEPO_KOD      VARCHAR(20)   COLLATE Turkish_CI_AS,
    DEPO_AD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    STOK_TIP      VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_KOD      VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_AD       VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_BRM      VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_GRP      VARCHAR(50)   COLLATE Turkish_CI_AS,
    ALIS_KDV      FLOAT,
    ALIS_FKDVSIZ  FLOAT,
    ALIS_FKDVLI   FLOAT,
    SATIS_KDV     FLOAT,
    SATIS_FKDVSIZ FLOAT,
    SATIS_FKDVLI  FLOAT,
    GIREN_MIK     FLOAT,
    CIKAN_MIK     FLOAT,
    MEVCUT_MIK    FLOAT,
    MEV_ALSKDVLI  FLOAT,
    MEV_ALSKDVSIZ FLOAT,
    MEV_SATKDVLI  FLOAT,
    MEV_SATKDVSIZ FLOAT)
AS
BEGIN

  DECLARE @HRK_DEP0_KOD        VARCHAR(20)
  DECLARE @HRK_DEPO_AD         VARCHAR(150)
  DECLARE @HRK_STOK_KOD        VARCHAR(20)
  DECLARE @HRK_STOK_TIP        VARCHAR(20)
  DECLARE @HRK_STOK_AD         VARCHAR(150)
  DECLARE @HRK_STOK_BRM        VARCHAR(20)
  DECLARE @HRK_STOK_GRP        VARCHAR(50)
  DECLARE @HRK_GIREN_MIK       FLOAT
  DECLARE @HRK_CIKAN_MIK       FLOAT
  DECLARE @HRK_MEVCUT_MIK       FLOAT
  DECLARE @HRK_ALIS_KDV        FLOAT
  DECLARE @HRK_ALIS_FKDVSIZ    FLOAT
  DECLARE @HRK_ALIS_FKDVLI     FLOAT
  DECLARE @HRK_SATIS_KDV       FLOAT
  DECLARE @HRK_SATIS_FKDVSIZ   FLOAT
  DECLARE @HRK_SATIS_FKDVLI    FLOAT
  
  DECLARE @TB_STOK_KART TABLE (
  STOK_TIP      VARCHAR(20)   COLLATE Turkish_CI_AS,
  STOK_KOD      VARCHAR(20)   COLLATE Turkish_CI_AS,
  STOK_AD       VARCHAR(100)  COLLATE Turkish_CI_AS,
  STOK_BRM      VARCHAR(20)   COLLATE Turkish_CI_AS,
  STOK_GRP      VARCHAR(50)   COLLATE Turkish_CI_AS,
  ALIS_KDV      FLOAT,
  ALIS_FKDVSIZ  FLOAT,
  ALIS_FKDVLI   FLOAT,
  SATIS_KDV     FLOAT,
  SATIS_FKDVSIZ FLOAT,
  SATIS_FKDVLI  FLOAT)
  
  /*TUM GRUPLAR */
  if (@GRP1_ID=0) AND (@GRP2_ID=0) AND (@GRP3_ID=0)
  insert into @TB_STOK_KART
  (STOK_GRP,STOK_TIP,STOK_KOD,STOK_AD,STOK_BRM,
  ALIS_KDV,ALIS_FKDVSIZ,ALIS_FKDVLI,SATIS_KDV,
  SATIS_FKDVSIZ,SATIS_FKDVLI)
  select k.grup,k.tip,k.kod,k.ad,k.brim,
  k.alskdv,k.alsfiykdvsiz,k.alsfiykdvli,k.sat1kdv,k.satfiykdvsiz,k.satfiykdvli
  from Stok_Kart_Market as k where k.sil=0

   /*1. GRUP GRUPLAR */
  if (@GRP1_ID>0)
  insert into @TB_STOK_KART
  (STOK_GRP,STOK_TIP,STOK_KOD,STOK_AD,STOK_BRM,
  ALIS_KDV,ALIS_FKDVSIZ,ALIS_FKDVLI,SATIS_KDV,
  SATIS_FKDVSIZ,SATIS_FKDVLI)
  select k.grup,k.tip,k.kod,k.ad,k.brim,
  k.alskdv,k.alsfiykdvsiz,k.alsfiykdvli,k.sat1kdv,k.satfiykdvsiz,k.satfiykdvli
  from Stok_Kart_Market as k where k.sil=0 and k.grp1=@GRP1_ID

  /*2. GRUP GRUPLAR */
  if (@GRP2_ID>0)
  insert into @TB_STOK_KART
  (STOK_GRP,STOK_TIP,STOK_KOD,STOK_AD,STOK_BRM,
  ALIS_KDV,ALIS_FKDVSIZ,ALIS_FKDVLI,SATIS_KDV,
  SATIS_FKDVSIZ,SATIS_FKDVLI)
  select k.grup,k.tip,k.kod,k.ad,k.brim,
  k.alskdv,k.alsfiykdvsiz,k.alsfiykdvli,k.sat1kdv,k.satfiykdvsiz,k.satfiykdvli
  from Stok_Kart_Market as k where k.sil=0 and k.grp2=@GRP2_ID
  
  
  /*3. GRUP GRUPLAR */
  if (@GRP3_ID>0)
  insert into @TB_STOK_KART
  (STOK_GRP,STOK_TIP,STOK_KOD,STOK_AD,STOK_BRM,
  ALIS_KDV,ALIS_FKDVSIZ,ALIS_FKDVLI,SATIS_KDV,
  SATIS_FKDVSIZ,SATIS_FKDVLI)
  select k.grup,k.tip,k.kod,k.ad,k.brim,
  k.alskdv,k.alsfiykdvsiz,k.alsfiykdvli,k.sat1kdv,k.satfiykdvsiz,k.satfiykdvli
  from Stok_Kart_Market as k where k.sil=0 and k.grp3=@GRP3_ID
  
  
  


  IF @DEPO_KOD=''
   begin
   DECLARE DEP_HRK CURSOR FAST_FORWARD FOR
    SELECT h.depkod,d.ad,
    k.STOK_GRP,k.STOK_TIP,
    k.STOK_KOD,k.STOK_AD,k.STOK_BRM,
    k.ALIS_KDV,k.ALIS_FKDVSIZ,k.ALIS_FKDVLI,k.SATIS_KDV,
    k.SATIS_FKDVSIZ,k.SATIS_FKDVLI,
    sum(giren),sum(cikan),sum(giren-cikan) from stkhrk as h
    inner join @TB_STOK_KART as k on
    k.STOK_TIP=h.stktip and k.STOK_KOD=h.stkod
    inner join depokart as d on d.kod=h.depkod and d.sil=0
    where h.sil=0
    group by h.depkod,d.ad,
    k.STOK_GRP,k.STOK_TIP,
    k.STOK_KOD,k.STOK_AD,k.STOK_BRM,
    k.ALIS_KDV,k.ALIS_FKDVSIZ,k.ALIS_FKDVLI,k.SATIS_KDV,
    k.SATIS_FKDVSIZ,k.SATIS_FKDVLI
    order by h.depkod,k.STOK_KOD
   end

   IF @DEPO_KOD<>''
   begin
   DECLARE DEP_HRK CURSOR FAST_FORWARD FOR
    SELECT h.depkod,d.ad,
    k.STOK_GRP,k.STOK_TIP,
    k.STOK_KOD,k.STOK_AD,k.STOK_BRM,
    k.ALIS_KDV,k.ALIS_FKDVSIZ,k.ALIS_FKDVLI,k.SATIS_KDV,
    k.SATIS_FKDVSIZ,k.SATIS_FKDVLI,
    sum(giren),sum(cikan),sum(giren-cikan) from stkhrk as h
    inner join @TB_STOK_KART as k on
    k.STOK_TIP=h.stktip and k.STOK_KOD=h.stkod
    inner join depokart as d on d.kod=h.depkod and d.sil=0
    where h.sil=0 and h.depkod=@DEPO_KOD
    group by h.depkod,d.ad,
    k.STOK_GRP,k.STOK_TIP,
    k.STOK_KOD,k.STOK_AD,k.STOK_BRM,
    k.ALIS_KDV,k.ALIS_FKDVSIZ,k.ALIS_FKDVLI,k.SATIS_KDV,
    k.SATIS_FKDVSIZ,k.SATIS_FKDVLI
    order by h.depkod,k.STOK_KOD
   end

   OPEN DEP_HRK
       FETCH NEXT FROM DEP_HRK INTO
        @HRK_DEP0_KOD,@HRK_DEPO_AD,@HRK_STOK_GRP,@HRK_STOK_TIP,
        @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_STOK_BRM,
        @HRK_ALIS_KDV,@HRK_ALIS_FKDVSIZ,@HRK_ALIS_FKDVLI,@HRK_SATIS_KDV,
        @HRK_SATIS_FKDVSIZ,@HRK_SATIS_FKDVLI,
        @HRK_GIREN_MIK,@HRK_CIKAN_MIK,@HRK_MEVCUT_MIK
         WHILE @@FETCH_STATUS = 0
          BEGIN

          insert into @TB_DEPO_TARIH_HRK
          (DEPO_KOD,DEPO_AD,STOK_GRP,
          STOK_TIP,STOK_KOD,STOK_AD,STOK_BRM,
          ALIS_KDV,ALIS_FKDVSIZ,ALIS_FKDVLI,SATIS_KDV,
          SATIS_FKDVSIZ,SATIS_FKDVLI,
          GIREN_MIK,CIKAN_MIK,MEVCUT_MIK)
          values (@HRK_DEP0_KOD,@HRK_DEPO_AD,@HRK_STOK_GRP,
          @HRK_STOK_TIP,@HRK_STOK_KOD,@HRK_STOK_AD,@HRK_STOK_BRM,
          @HRK_ALIS_KDV,@HRK_ALIS_FKDVSIZ,@HRK_ALIS_FKDVLI,@HRK_SATIS_KDV,
          @HRK_SATIS_FKDVSIZ,@HRK_SATIS_FKDVLI,
          @HRK_GIREN_MIK,@HRK_CIKAN_MIK,@HRK_MEVCUT_MIK)

         FETCH NEXT FROM DEP_HRK INTO
         @HRK_DEP0_KOD,@HRK_DEPO_AD,@HRK_STOK_GRP,@HRK_STOK_TIP,
         @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_STOK_BRM,
         @HRK_ALIS_KDV,@HRK_ALIS_FKDVSIZ,@HRK_ALIS_FKDVLI,@HRK_SATIS_KDV,
         @HRK_SATIS_FKDVSIZ,@HRK_SATIS_FKDVLI,
         @HRK_GIREN_MIK,@HRK_CIKAN_MIK,@HRK_MEVCUT_MIK
          END
         CLOSE DEP_HRK
         DEALLOCATE DEP_HRK


       UPDATE @TB_DEPO_TARIH_HRK SET MEV_ALSKDVLI=MEVCUT_MIK*ALIS_FKDVLI,
       MEV_ALSKDVSIZ=MEVCUT_MIK*ALIS_FKDVSIZ,
       MEV_SATKDVLI=MEVCUT_MIK*SATIS_FKDVSIZ,
       MEV_SATKDVSIZ=MEVCUT_MIK*SATIS_FKDVSIZ




 RETURN




END

================================================================================
