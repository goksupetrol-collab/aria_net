-- Function: dbo.UDF_STOK_PERIYOT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.770671
================================================================================

CREATE FUNCTION UDF_STOK_PERIYOT (
@FIRMA_NO       	INT,
@HRK_KRITER       VARCHAR(4000),
@STOK_DEPKOD      VARCHAR(20),
@STOK_TIP         VARCHAR(20),
@STOK_GRPTIP      INT,
@STOK_KODIN       VARCHAR (8000),
@PERIYOTTIP       INT,
@TARIH1           DATETIME,
@TARIH2           DATETIME)
RETURNS

  @TB_STOKPER_HRK TABLE (
    PERIYOTTAR          DATETIME,
    PERIYOTAD           VARCHAR(50)  COLLATE Turkish_CI_AS,
    STOK_TIP            VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_GRPID          FLOAT,
    STOK_GRPAD          VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_KOD            VARCHAR(50)   COLLATE Turkish_CI_AS,
    STOK_AD             VARCHAR(150)   COLLATE Turkish_CI_AS,
    DEPO_KOD            VARCHAR(30)   COLLATE Turkish_CI_AS,
    DEPO_AD             VARCHAR(100)   COLLATE Turkish_CI_AS,
    ALISMIKTAR          FLOAT,
    ALISTUTAR           FLOAT,
    SATISMIKTAR         FLOAT,
    SATISTUTAR          FLOAT)
AS
BEGIN


  DECLARE @STKHRKPER_TEMP TABLE (
    PERIYOTTAR            DATETIME,
    PERIYOTAD             VARCHAR(50)   COLLATE Turkish_CI_AS,
    STOK_TIP              VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_GRPID            FLOAT,
    STOK_GRPAD          VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_KOD              VARCHAR(50)   COLLATE Turkish_CI_AS,
    STOK_AD               VARCHAR(150)   COLLATE Turkish_CI_AS,
    DEPO_KOD              VARCHAR(30)   COLLATE Turkish_CI_AS,
    DEPO_AD               VARCHAR(100)   COLLATE Turkish_CI_AS,
    ALISMIKTAR            FLOAT DEFAULT 0,
    ALISTUTAR             FLOAT DEFAULT 0,
    SATISMIKTAR           FLOAT DEFAULT 0,
    SATISTUTAR            FLOAT DEFAULT 0)

  DECLARE @HRK_PERIYOTTAR   DATETIME
  DECLARE @HRK_PERIYOTAD    VARCHAR(50)
  DECLARE @HRK_STOK_TIP     VARCHAR(20)
  DECLARE @HRK_GRPID        FLOAT
  DECLARE @HRK_STOK_KOD     VARCHAR(50)
  DECLARE @HRK_STOK_AD      VARCHAR(150)
  DECLARE @HRK_DEPO_KOD     VARCHAR(30)
  DECLARE @HRK_DEPO_AD      VARCHAR(100)
  DECLARE @HRK_ALISMIK      FLOAT
  DECLARE @HRK_ALISTUT      FLOAT
  DECLARE @HRK_SATISMIK     FLOAT
  DECLARE @HRK_SATISTUT     FLOAT

  DECLARE @HRK_BRIM         VARCHAR(50)
  DECLARE @HRK_BRMFIYKDVLI  FLOAT
  DECLARE @HRK_KDVYUZ       FLOAT

/*
0=GUNLUK
1=HAFTALIK  select datepart(wk, GETDATE() )
2=AYLIK
3=HAFTANIN GUNLERI

SELECT Gun =
   CASE DATEPART(dw,GETDATE())
   WHEN 1 THEN 'PAZAR'
   WHEN 2 THEN 'PAZARTESİ'
   WHEN 3 THEN 'SALI'
   WHEN 4 THEN 'ÇARŞAMBA'
   WHEN 5 THEN 'PERŞEMBE'
   WHEN 6 THEN 'CUMA'
   WHEN 7 THEN 'CUMARTESİ'
   END
*/


 /*---------------------------------------------------------------------------- */

  IF @STOK_GRPTIP=0 and (@STOK_DEPKOD='')
  begin
    IF (@FIRMA_NO=0)
     DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
     SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,h.brmfiykdvli,
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock)  on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.kod in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
      IF (@FIRMA_NO>0) 
        DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
       SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,h.brmfiykdvli,
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock)  on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0
      and h.firmano in (0,@FIRMA_NO)
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.kod in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih 
      
   end  
   

   IF @STOK_GRPTIP=0 and (@STOK_DEPKOD!='')
   begin
    IF (@FIRMA_NO=0)
    DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
     SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,h.brmfiykdvli,
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock)  on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip 
      and h.sil=0 and h.depkod=@STOK_DEPKOD
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.kod in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
      
      IF (@FIRMA_NO>0) 
       DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
       SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,h.brmfiykdvli,
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock)  on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip 
      and h.sil=0 and h.depkod=@STOK_DEPKOD
      and h.firmano in (0,@FIRMA_NO)
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.kod in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih

    end

  IF @STOK_GRPTIP=1 and (@STOK_DEPKOD='')
  begin
  
   IF (@FIRMA_NO=0)
     DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
      SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,ISNULL(h.brmfiykdvli,0),
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock) on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.grp1 in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
      
     IF (@FIRMA_NO>0)   
      DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
      SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,ISNULL(h.brmfiykdvli,0),
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock) on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0
      and h.firmano in (0,@FIRMA_NO)
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.grp1 in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
   end   
      
      
      
   IF @STOK_GRPTIP=1 and (@STOK_DEPKOD!='')
   begin
    IF (@FIRMA_NO=0)
    DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
     SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,ISNULL(h.brmfiykdvli,0),
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock) on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0 and h.depkod=@STOK_DEPKOD
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.grp1 in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
      
     IF (@FIRMA_NO>0)
       DECLARE STKPER_HRK CURSOR FAST_FORWARD FOR
      SELECT
       h.tarih,
       h.tarih,   /*isnull(( */
       k.tip,k.grp1,k.kod,k.ad,ISNULL(h.brmfiykdvli,0),
      ISNULL(SUM(giren),0),ISNULL(SUM(cikan),0)
      FROM stokkart as k with (nolock) 
      left Join stkhrk as h with (nolock) on
      h.stkod=k.kod and k.sil=0 and h.stktip=k.tip
      and h.sil=0 and h.depkod=@STOK_DEPKOD
      and h.firmano in (0,@FIRMA_NO)
      AND (h.tarih >= @TARIH1 and h.tarih <= @TARIH2)
      and h.islmtip not in 
      (select * from CsvToSTR(@HRK_KRITER))
      where k.tip=@STOK_TIP
      and k.grp1 in (select * FROM CsvToSTR(@STOK_KODIN))
      GROUP BY k.tip,k.grp1,k.kod,k.ad,k.brim,h.tarih,h.brmfiykdvli
      order by h.tarih
      
   end      
      
  

  OPEN STKPER_HRK

  FETCH NEXT FROM STKPER_HRK INTO
   @HRK_PERIYOTTAR,@HRK_PERIYOTAD,@HRK_STOK_TIP,@HRK_GRPID,@HRK_STOK_KOD,@HRK_STOK_AD,
   @HRK_BRMFIYKDVLI,@HRK_ALISMIK,@HRK_SATISMIK

  WHILE @@FETCH_STATUS = 0
  BEGIN
  
       if @HRK_PERIYOTTAR>0
       begin
       IF @PERIYOTTIP=0
       set @HRK_PERIYOTAD=convert(varchar,@HRK_PERIYOTTAR,104)
       
       IF @PERIYOTTIP=1
       begin
       if datepart(wk,(@HRK_PERIYOTTAR-1))=53
        set @HRK_PERIYOTAD=1
        else
        set @HRK_PERIYOTAD=datepart(wk,(@HRK_PERIYOTTAR-1))
       end
       
       IF @PERIYOTTIP=2
       set @HRK_PERIYOTAD=
        (select
          CASE DATEPART(mm,@HRK_PERIYOTTAR)
           WHEN 1 THEN 'OCAK'
           WHEN 2 THEN 'ŞUBAT'
           WHEN 3 THEN 'MART'
           WHEN 4 THEN 'NİSAN'
           WHEN 5 THEN 'MAYIS'
           WHEN 6 THEN 'HAZİRAN'
           WHEN 7 THEN 'TEMMUZ'
           WHEN 8 THEN 'AĞUSTOS'
           WHEN 9 THEN 'EYLÜL'
           WHEN 10 THEN 'EKİM'
           WHEN 11 THEN 'KASIM'
           WHEN 12 THEN 'ARALIK'
          END)

       IF @PERIYOTTIP=3
       set @HRK_PERIYOTAD=
         (select CASE DATEPART(dw,@HRK_PERIYOTTAR)
          WHEN 1 THEN 'PAZAR'
          WHEN 2 THEN 'PAZARTESİ'
          WHEN 3 THEN 'SALI'
          WHEN 4 THEN 'ÇARŞAMBA'
          WHEN 5 THEN 'PERŞEMBE'
          WHEN 6 THEN 'CUMA'
          WHEN 7 THEN 'CUMARTESİ'
          END)
       end


     INSERT @STKHRKPER_TEMP (PERIYOTTAR,PERIYOTAD,STOK_TIP,STOK_GRPID,STOK_KOD,
     STOK_AD,DEPO_KOD,DEPO_AD,
     ALISMIKTAR,ALISTUTAR,SATISMIKTAR,SATISTUTAR)
      SELECT
        @HRK_PERIYOTTAR,@HRK_PERIYOTAD,@HRK_STOK_TIP,@HRK_GRPID,@HRK_STOK_KOD,
        @HRK_STOK_AD,@HRK_DEPO_KOD,@HRK_DEPO_AD,
        @HRK_ALISMIK,@HRK_BRMFIYKDVLI*@HRK_ALISMIK,@HRK_SATISMIK,@HRK_BRMFIYKDVLI*@HRK_SATISMIK

      FETCH NEXT FROM STKPER_HRK INTO
   @HRK_PERIYOTTAR,@HRK_PERIYOTAD,@HRK_STOK_TIP,@HRK_GRPID,@HRK_STOK_KOD,@HRK_STOK_AD,
   @HRK_BRMFIYKDVLI,@HRK_ALISMIK,@HRK_SATISMIK
  END

  CLOSE STKPER_HRK
  DEALLOCATE STKPER_HRK

  /*---------------------------------------------------------------------------- */
  update @STKHRKPER_TEMP set PERIYOTTAR=@HRK_PERIYOTTAR,PERIYOTAD=@HRK_PERIYOTAD
   where PERIYOTTAR is null
  
  
  
  
/*----------------------------------------------------------------------------- */

  update @STKHRKPER_TEMP set STOK_GRPAD=dt.ad  from @STKHRKPER_TEMP t join
  (select id,ad from grup ) 
  dt on dt.id=t.STOK_GRPID
  
  

  INSERT @TB_STOKPER_HRK (PERIYOTTAR,PERIYOTAD,STOK_TIP,STOK_GRPID,
  STOK_GRPAD,STOK_KOD,STOK_AD,
     ALISMIKTAR,ALISTUTAR,SATISMIKTAR,SATISTUTAR)
    SELECT PERIYOTTAR,PERIYOTAD,STOK_TIP,STOK_GRPID,STOK_GRPAD,
    STOK_KOD,STOK_AD,
     ALISMIKTAR,ALISTUTAR,SATISMIKTAR,SATISTUTAR FROM @STKHRKPER_TEMP

  RETURN

END

================================================================================
