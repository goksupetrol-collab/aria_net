-- Function: dbo.STOKFIFO
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.679633
================================================================================

CREATE FUNCTION [dbo].STOKFIFO 
(@MALIYETTIPI INT,
@DEPO_KOD VARCHAR(20),
@STOK_TIP VARCHAR(10),
@STOK_KOD VARCHAR(20),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
   @FIFO_STK TABLE (
    MALIYET   FLOAT)
AS
BEGIN
/*
1= ALIS FIFO ORT
2= SATIS FIFO ORT
*/


DECLARE @STOKMALIYET_TEMP TABLE (
    ID          FLOAT,
    STOK_KOD    VARCHAR(20),
    STOK_TIP    VARCHAR(10),
    HRKTIP      VARCHAR(1),
    TARIH       DATETIME,
    MIKTAR      FLOAT,
    BRMTUT       FLOAT,
    CIKMIK       FLOAT)

  DECLARE @ID              FLOAT
  DECLARE @HRK_ID          FLOAT
  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_STOK_TIP    VARCHAR(10)
  DECLARE @HRK_HRKTIP      VARCHAR(30)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_MIKTAR       FLOAT
  DECLARE @HRK_BRMTUT       FLOAT
  DECLARE @HRK_CIKMIK       FLOAT

  DECLARE @KALANMIK         FLOAT

  DECLARE @DUSMIK           FLOAT

/*-GIRISLER */
    if @DEPO_KOD<>''
    INSERT @STOKMALIYET_TEMP
      SELECT S.id,s.stkod,S.stktip,'G',S.tarih+cast(saat as datetime),S.giren,S.brmfiykdvli,0
      FROM stkhrk as s with (NOLOCK)
      WHERE s.stkod=@STOK_KOD and s.stktip=@STOK_TIP
      AND S.depkod=@DEPO_KOD
      AND S.giren>0 and s.sil=0
      and (tarih <= @TARIH2)
      ORDER BY S.tarih+cast(saat as datetime)

    if @DEPO_KOD=''
    INSERT @STOKMALIYET_TEMP
      SELECT S.id,s.stkod,S.stktip,'G',S.tarih+cast(saat as datetime),S.giren,S.brmfiykdvli,0
      FROM stkhrk as s with (NOLOCK)
      WHERE s.stkod=@STOK_KOD and s.stktip=@STOK_TIP
      AND S.giren>0 and s.sil=0
      and (tarih <= @TARIH2)
      ORDER BY S.tarih+cast(saat as datetime)

/*----CIKISLAR */
    if @DEPO_KOD<>''
    begin
    DECLARE STKFIFO_HRK CURSOR FAST_FORWARD FOR
    SELECT  S.id,s.stkod,S.stktip,'C',S.tarih+cast(saat as datetime),S.cikan
    FROM stkhrk as s with (NOLOCK)
    WHERE s.stkod=@STOK_KOD and s.stktip=@STOK_TIP
    AND S.depkod=@DEPO_KOD
    AND S.cikan>0 and s.sil=0
    and (tarih <= @TARIH2)
    ORDER BY S.tarih+cast(saat as datetime)
    end
    
    
    
    
    if @DEPO_KOD=''
    begin
    DECLARE STKFIFO_HRK CURSOR FAST_FORWARD FOR
    SELECT  S.id,s.stkod,S.stktip,'C',S.tarih+cast(saat as datetime),S.cikan
    FROM stkhrk as s with (NOLOCK)
    WHERE s.stkod=@STOK_KOD and s.stktip=@STOK_TIP
    AND S.cikan>0 and s.sil=0
    and (tarih <= @TARIH2)
    ORDER BY S.tarih+cast(saat as datetime)
    end




   OPEN STKFIFO_HRK

   FETCH NEXT FROM STKFIFO_HRK INTO
   @HRK_ID,@HRK_STOK_KOD ,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIK
   WHILE @@FETCH_STATUS = 0
   BEGIN


     WHILE @HRK_CIKMIK>0 BEGIN
     SET @HRK_BRMTUT=0
     SET @KALANMIK=0

     SELECT top 1 @ID=ID,@KALANMIK=ISNULL(MIKTAR-CIKMIK,0),
     @HRK_BRMTUT=ISNULL(BRMTUT,0)
     FROM @STOKMALIYET_TEMP WHERE STOK_TIP=@HRK_STOK_TIP 
     AND STOK_KOD=@HRK_STOK_KOD
     AND (MIKTAR-CIKMIK)>0 AND HRKTIP='G' ORDER BY TARIH

     IF @KALANMIK=0
     BEGIN
     SET @DUSMIK=@HRK_CIKMIK
     END
     ELSE
     BEGIN
     IF @HRK_CIKMIK>@KALANMIK
     SET @DUSMIK=@KALANMIK
     ELSE
     SET @DUSMIK=@HRK_CIKMIK
     END

      INSERT @STOKMALIYET_TEMP (ID,STOK_KOD,STOK_TIP,HRKTIP,TARIH,MIKTAR,BRMTUT)
      VALUES (@HRK_ID,@HRK_STOK_KOD,@HRK_STOK_TIP,'C',@HRK_TARIH,-1*@DUSMIK,@HRK_BRMTUT)

      /*-------------------------------- */
      UPDATE @STOKMALIYET_TEMP SET CIKMIK=CIKMIK+@DUSMIK WHERE ID=@ID

      SET @HRK_CIKMIK=@HRK_CIKMIK-@DUSMIK

    END;

   FETCH NEXT FROM STKFIFO_HRK INTO
   @HRK_ID,@HRK_STOK_KOD ,@HRK_STOK_TIP,@HRK_HRKTIP,@HRK_TARIH,@HRK_CIKMIK
  END

  CLOSE STKFIFO_HRK
  DEALLOCATE STKFIFO_HRK



  INSERT @FIFO_STK
   select ISNULL( (CASE when 
   SUM(MIKTAR)>0 then
    SUM(MIKTAR*BRMTUT)/sum(MIKTAR)  
    ELSE 0 END  )  ,0) from @STOKMALIYET_TEMP
RETURN


END

================================================================================
