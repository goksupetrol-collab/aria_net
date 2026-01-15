-- Function: dbo.UDF_GELGID_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.717006
================================================================================

CREATE FUNCTION [dbo].UDF_GELGID_BAKIYE 
(@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME, @TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_UNVAN      VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRPAD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    BORC            FLOAT,
    ALACAK          FLOAT,
    GENELTOPLAM     FLOAT )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_UNVAN      VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRPAD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    BORC            FLOAT,
    ALACAK          FLOAT,
    GENELTOPLAM     FLOAT )

  DECLARE @HRK_CARI_TIP         VARCHAR(20)
  DECLARE @HRK_CARI_KOD    		VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  		VARCHAR(150)
  DECLARE @HRK_CARI_GRUPAD		VARCHAR(150)
  DECLARE @HRK_BORC         	FLOAT
  DECLARE @HRK_ALACAK         	FLOAT
  DECLARE @HRK_GENELTOP        	FLOAT


      DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
      SELECT
      @CARI_TIP,vc.kod,(vc.ad),
      vc.grup,
      isnull(sum(h.borc),0),
      isnull(sum(h.alacak),0)
      FROM carihrk as h inner join Gel_Gid_Kart_Listesi as vc
      on vc.kod=h.carkod and h.cartip=@CARI_TIP
      where  h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
      group by vc.grup,vc.kod,vc.ad


  
  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
   @HRK_CARI_GRUPAD,@HRK_BORC,@HRK_ALACAK

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @HRK_GENELTOP=@HRK_BORC-@HRK_ALACAK

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_CARI_GRUPAD,@HRK_BORC,@HRK_ALACAK,@HRK_GENELTOP
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
    @HRK_CARI_GRUPAD,@HRK_BORC,@HRK_ALACAK
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
