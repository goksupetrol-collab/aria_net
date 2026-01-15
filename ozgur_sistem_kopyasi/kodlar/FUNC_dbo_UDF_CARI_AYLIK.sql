-- Function: dbo.UDF_CARI_AYLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.690485
================================================================================

CREATE FUNCTION UDF_CARI_AYLIK (@CARI_TIP VARCHAR(20),
@CARI_KODIN VARCHAR(8000),@YIL INT)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP          VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN        VARCHAR(50) COLLATE Turkish_CI_AS,
    AY                INT,
    AYISIM            VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIDEVIR         FLOAT,
    CARIFIS           FLOAT,
    CARIBORC          FLOAT,
    CARIALACAK        FLOAT,
    CARIBAKIYE        FLOAT,
    BAKIYE            FLOAT )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
     CARI_TIP         VARCHAR(20) COLLATE Turkish_CI_AS,
     CARI_KOD         VARCHAR(20) COLLATE Turkish_CI_AS,
     CARI_UNVAN       VARCHAR(50) COLLATE Turkish_CI_AS,
     AY               INT,
     AYISIM           VARCHAR(20) COLLATE Turkish_CI_AS,
     CARIDEVIR        FLOAT,
     CARIFIS          FLOAT,
     CARIBORC         FLOAT,
     CARIALACAK       FLOAT,
     CARIBAKIYE       FLOAT,
     BAKIYE           FLOAT )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_AY           INT
  DECLARE @HRK_AYISIM       VARCHAR(20)
  DECLARE @HRK_FISDEVIR      FLOAT
  DECLARE @HRK_CARDEVIR      FLOAT
  DECLARE @HRK_CARIFIS       FLOAT
  DECLARE @HRK_BORC          FLOAT
  DECLARE @HRK_ALACAK        FLOAT
  DECLARE @HRK_CARIBAKIYE    FLOAT
  DECLARE @HRK_GENELTOP      FLOAT
  DECLARE @HRK_DEVIR         FLOAT
  DECLARE @HRK_ROW_COUNT     INT

  DECLARE @HRK_TBASTAR       DATETIME
  DECLARE @TARIH1            DATETIME
  DECLARE @TARIH2            DATETIME



 declare @FatIskGoster   bit
  select top 1 @FatIskGoster=case when FaturaFisIskonto=0 then 1 else 0 end
  from sistemtanim  



  DECLARE CRS_HRK_IN CURSOR FAST_FORWARD FOR
     SELECT v.cartp,v.kod,v.ad FROM Genel_Kart as v where
      v.cartp=@CARI_TIP and v.kod in (select * from CsvToSTR(@CARI_KODIN))
      OPEN CRS_HRK_IN

   FETCH NEXT FROM CRS_HRK_IN INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN

   WHILE @@FETCH_STATUS = 0
     BEGIN


        set @HRK_AY=1
         
        SET @HRK_TBASTAR=
        CAST(@YIL AS VARCHAR(4))+'-'+CAST(@HRK_AY AS VARCHAR(4))+'-01'

         set @HRK_DEVIR=0
         if @FatIskGoster=0
         (select @HRK_DEVIR=isnull(sum((d.borc+d.fisbakiye)-d.alacak),0) from
         view_cari_hrk_fis_listesi as d where d.cartip=@CARI_TIP
         and d.carkod=@HRK_CARI_KOD 
         and d.Aktip='BK'
         /*and d.islmhrk not in ('CAK','FATVERSAT') */
         and d.tarih<@HRK_TBASTAR)


        if @FatIskGoster=1
         (select @HRK_DEVIR=isnull(sum((d.borc+d.fisbakiye)-d.alacak),0) from
         view_cari_hrk_fis_Isk_listesi as d where d.cartip=@CARI_TIP
         and d.carkod=@HRK_CARI_KOD 
         and d.Aktip='BK'
         /*and d.islmhrk not in ('CAK','FATVERSAT') */
         and d.tarih<@HRK_TBASTAR)



         
          WHILE @HRK_AY<=12
          begin

            set @HRK_AYISIM=
            (select
              CASE @HRK_AY
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

             set @HRK_BORC=0
             set @HRK_ALACAK=0
             set @HRK_CARIFIS=0

            
            
             if @FatIskGoster=0
             SELECT
              @HRK_BORC=isnull(sum(h.borc),0),
              @HRK_ALACAK=isnull(sum(h.alacak),0),
              @HRK_CARIFIS=isnull(sum(h.fisbakiye),0)
              FROM view_cari_hrk_fis_listesi as h
              where h.cartip=@CARI_TIP and
              h.carkod=@HRK_CARI_KOD
              /*and h.islmhrk not in ('CAK','FATVERSAT') */
              and h.Aktip='BK'
              and h.ay =@HRK_AY and h.yil = @YIL
              group by h.cartip,h.carkod,h.unvan,h.ay
              order by h.ay
              
              
            if @FatIskGoster=1
             SELECT
              @HRK_BORC=isnull(sum(h.borc),0),
              @HRK_ALACAK=isnull(sum(h.alacak),0),
              @HRK_CARIFIS=isnull(sum(h.fisbakiye),0)
              FROM view_cari_hrk_fis_Isk_listesi as h
              where h.cartip=@CARI_TIP and
              h.carkod=@HRK_CARI_KOD
              /*and h.islmhrk not in ('CAK','FATVERSAT') */
              and h.Aktip='BK'
              and h.ay =@HRK_AY and h.yil = @YIL
              group by h.cartip,h.carkod,h.unvan,h.ay
              order by h.ay



                SET @HRK_CARIBAKIYE=@HRK_BORC-@HRK_ALACAK
                SET @HRK_GENELTOP=@HRK_DEVIR+@HRK_CARIFIS+@HRK_CARIBAKIYE

                INSERT @EKSTRE_TEMP
                 SELECT
                 @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_AY,@HRK_AYISIM,
                 @HRK_DEVIR,@HRK_CARIFIS,@HRK_BORC,@HRK_ALACAK,
                 @HRK_CARIBAKIYE,@HRK_GENELTOP

                 SET @HRK_DEVIR=@HRK_GENELTOP
                 
           set @HRK_AY=@HRK_AY+1

           end/*ay dongu */


          FETCH NEXT FROM CRS_HRK_IN INTO
          @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN
          END

          CLOSE CRS_HRK_IN
          DEALLOCATE CRS_HRK_IN


/*---------------------------------------------------------------------------- */

   INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP ORDER BY AY

  RETURN

END

================================================================================
