-- Function: dbo.UDF_CARI_LIMIT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.696305
================================================================================

CREATE FUNCTION UDF_CARI_LIMIT (
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    		 VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    		 VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  		 VARCHAR(150) COLLATE Turkish_CI_AS,
    GENELBAKIYE      	 FLOAT,
    LIMIT             	 FLOAT,
    CEKSENETBEKLEYEN  	 FLOAT,
    FARK              	 FLOAT,
    FARK_CEKBEKLEYENSIZ  FLOAT
    )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    GENELBAKIYE       FLOAT,
    LIMIT             FLOAT,
    CEKSENETBEKLEYEN  	FLOAT,
    FARK                FLOAT,
    FARK_CEKBEKLEYENSIZ  FLOAT  )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(150)
  DECLARE @HRK_GENELBAKIYE     FLOAT
  DECLARE @HRK_LIMIT           FLOAT
  DECLARE @HRK_FARK            FLOAT
  DECLARE @HRK_CEKSENETBEKLEYEN  FLOAT

  DECLARE @HRK_CARIBAKIYE      FLOAT
  DECLARE @HRK_FISBAKIYE       FLOAT
  
  INSERT @EKSTRE_TEMP (CARI_TIP,CARI_KOD,CARI_UNVAN,
  LIMIT,GENELBAKIYE,FARK,CEKSENETBEKLEYEN,FARK_CEKBEKLEYENSIZ)
    SELECT
      'Cari Kartlar',k.kod,k.unvan,k.toplamlimit,0,0,0,0
       FROM carikart as k with (nolock) where k.sil=0
  
  
  
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      h.carkod,isnull(sum(h.borc-h.alacak),0)
      FROM carihrk as h with (nolock)  where h.sil=0 
      AND(h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2
      group by h.carkod

  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_KOD,@HRK_CARIBAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN
                         
      set @HRK_FISBAKIYE=(
      select isnull(sum(case WHEN fistip='FISVERSAT' THEN 
      toptut ELSE -1*toptut END ),0) from veresimas as vrs with (nolock)
      where vrs.sil=0 and vrs.cartip='carikart'
      and vrs.carkod=@HRK_CARI_KOD and vrs.aktip in ('BK','BL') 
      AND (vrs.tarih+cast(vrs.saat as datetime)) >= @TARIH1 
      and (vrs.tarih+cast(vrs.saat as datetime)) <= @TARIH2 )
      
      
     set @HRK_CEKSENETBEKLEYEN= 
     (select isnull(sum(-1*(giren-cikan)),0) from cekkart as c  with (nolock) 
      where c.sil=0 and c.drm in ('POR','TAK','KSN')
      and (c.tarih+cast(c.saat as datetime)) >= @TARIH1 
      and (c.tarih+cast(c.saat as datetime)) <= @TARIH2 and 
      ( (c.cartip=@CARI_TIP and c.carkod=@HRK_CARI_KOD) or 
      (c.vercartip=@CARI_TIP and c.vercarkod=@HRK_CARI_KOD) ) )
      

      SET @HRK_GENELBAKIYE=@HRK_CARIBAKIYE+@HRK_FISBAKIYE
      
     
      

    UPDATE @EKSTRE_TEMP 
    SET GENELBAKIYE=@HRK_GENELBAKIYE,
    CEKSENETBEKLEYEN=@HRK_CEKSENETBEKLEYEN,
    FARK=LIMIT-@HRK_GENELBAKIYE,
    FARK_CEKBEKLEYENSIZ=LIMIT-(@HRK_GENELBAKIYE-
    @HRK_CEKSENETBEKLEYEN)
    WHERE CARI_KOD=@HRK_CARI_KOD
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_KOD,@HRK_CARIBAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
