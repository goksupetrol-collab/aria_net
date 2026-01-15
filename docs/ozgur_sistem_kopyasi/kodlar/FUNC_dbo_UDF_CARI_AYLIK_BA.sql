-- Function: dbo.UDF_CARI_AYLIK_BA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.690934
================================================================================

CREATE FUNCTION UDF_CARI_AYLIK_BA (@CARI_TIP VARCHAR(20),
@CARI_KODIN VARCHAR(8000),
@YIL INT)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP          VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN        VARCHAR(50) COLLATE Turkish_CI_AS,
    AY                INT,
    AYISIM            VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIDEVIR         FLOAT,
    CARIBORC          FLOAT,
    CARIALACAK        FLOAT,
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
     CARIBORC         FLOAT,
     CARIALACAK       FLOAT,
     BAKIYE           FLOAT )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_CARTIP VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_AY           INT
  DECLARE @HRK_AYISIM       VARCHAR(20)
  DECLARE @HRK_FISDEVIR      FLOAT
  DECLARE @HRK_CARDEVIR      FLOAT
  DECLARE @HRK_CARIFIS       FLOAT
  DECLARE @HRK_BORC          FLOAT
  DECLARE @HRK_ALACAK        FLOAT
  DECLARE @HRK_GENELTOP      FLOAT
  DECLARE @HRK_DEVIR         FLOAT
  
  
  DECLARE @HRK_TBASTAR       DATETIME
  DECLARE @TARIH1            DATETIME
  DECLARE @TARIH2            DATETIME
  
  
  
   
  declare @FatIskGoster   bit
  select top 1 @FatIskGoster=case when FaturaFisIskonto=0 then 1 else 0 end
  from sistemtanim  
  
  

  SET  @TARIH1=CAST(@YIL AS VARCHAR(4))+'-01-01'
  SET  @TARIH2=CAST(@YIL AS VARCHAR(4))+'-12-31'

DECLARE @EKSTRE_IN TABLE (
 carkod     varchar(30) COLLATE Turkish_CI_AS)

declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@CARI_KODIN)) > 0)
 BEGIN
  set @CARI_KODIN = @CARI_KODIN + ','
 END

 while patindex('%,%' , @CARI_KODIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @CARI_KODIN)
   select @array_value = left(@CARI_KODIN, @separator_position - 1)

  Insert @EKSTRE_IN
  Values (@array_value)

   select @CARI_KODIN = stuff(@CARI_KODIN, 1, @separator_position, '')
 end


 DECLARE CRS_HRK_IN CURSOR FAST_FORWARD FOR
     SELECT v.cartp,v.kod,v.ad FROM Genel_Kart as v where
      v.cartp=@CARI_TIP and v.kod in (select * from @EKSTRE_IN)
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
         and d.carkod=@HRK_CARI_KOD and d.aktip='BK'
         /*and d.islmhrk not in ('CAK','FATVERSAT') */
          and d.tarih<@HRK_TBASTAR)
          
          
         if @FatIskGoster=1
         (select @HRK_DEVIR=isnull(sum((d.borc+d.fisbakiye)-d.alacak),0) from
         view_cari_hrk_fis_Isk_listesi as d where d.cartip=@CARI_TIP
         and d.carkod=@HRK_CARI_KOD and d.aktip='BK'
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


             if @FatIskGoster=0
             SELECT
              @HRK_BORC=isnull(sum(h.borc+h.fisbakiye),0),
              @HRK_ALACAK=isnull(sum(h.alacak),0)
              FROM view_cari_hrk_fis_listesi as h
              where h.cartip=@CARI_TIP and
              h.carkod=@HRK_CARI_KOD
             and h.aktip='BK'
             /* and h.islmhrk not in ('CAK','FATVERSAT') */
              and h.ay =@HRK_AY and h.yil = @YIL
              group by h.cartip,h.carkod,h.unvan,h.ay
              order by h.ay
              
              
             if @FatIskGoster=1
             SELECT
              @HRK_BORC=isnull(sum(h.borc+h.fisbakiye),0),
              @HRK_ALACAK=isnull(sum(h.alacak),0)
              FROM view_cari_hrk_fis_Isk_listesi as h
              where h.cartip=@CARI_TIP and
              h.carkod=@HRK_CARI_KOD
             and h.aktip='BK'
             /* and h.islmhrk not in ('CAK','FATVERSAT') */
              and h.ay =@HRK_AY and h.yil = @YIL
              group by h.cartip,h.carkod,h.unvan,h.ay
              order by h.ay 
              
              
              

             SET @HRK_GENELTOP=(@HRK_DEVIR+@HRK_BORC)-@HRK_ALACAK

              INSERT @EKSTRE_TEMP
              SELECT
               @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_AY,@HRK_AYISIM,
                @HRK_DEVIR,@HRK_BORC,@HRK_ALACAK,@HRK_GENELTOP

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
