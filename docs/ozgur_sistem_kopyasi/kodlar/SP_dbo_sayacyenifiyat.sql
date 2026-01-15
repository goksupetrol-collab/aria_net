-- Stored Procedure: dbo.sayacyenifiyat
-- Tarih: 2026-01-14 20:06:08.363674
================================================================================

CREATE PROCEDURE [dbo].sayacyenifiyat
@firmano   int,
@varno     float
AS
BEGIN

  declare @STOK_KOD             VARCHAR(30)
  declare @KDVTIP 		        VARCHAR(10)
  declare @GECSTOK_KOD 	        VARCHAR(30)
  declare @BRIM_FIYAT 	        FLOAT
  declare @KDVORAN 		        FLOAT
  declare @kart_ak_isle         int
  SET @GECSTOK_KOD=''
  

 set @kart_ak_isle=1
 
 select @kart_ak_isle=ISNULL(Kart_ak_isle,0) from Firma 
  where id=@firmano
  
   
  /*Ortalama  */
  DECLARE sayacyenifiyat_cur CURSOR LOCAL FOR
  SELECT stkod from pomvardisayac
  where varno=@varno and sil=0 and satmik>0 
  group by stkod
  /*,Round(brimfiy,4) */
  OPEN sayacyenifiyat_cur
  FETCH NEXT FROM sayacyenifiyat_cur INTO 
  @STOK_KOD/*,@BRIM_FIYAT */
  WHILE @@FETCH_STATUS = 0
  BEGIN
  
  /*IF @GECSTOK_KOD<>@STOK_KOD */
   /*BEGIN */
   SET @GECSTOK_KOD=@STOK_KOD
   
   SELECT @KDVTIP=sat1kdvtip,@KDVORAN=sat1kdv FROM stokkart where tip='akykt'
   and kod=@STOK_KOD
   if (@KDVTIP='Hariç') and (@KDVORAN>0)
   set @KDVORAN=1+(@KDVORAN/100)
   else
   set @KDVORAN=1

  if @kart_ak_isle=1
   begin 
     SELECT @BRIM_FIYAT=Max(Round(brimfiy,4)) from pomvardisayac
     where varno=@varno and sil=0 and satmik>0  and stkod=@STOK_KOD
     
     update stokkart set sat1fiy=(@BRIM_FIYAT/@KDVORAN) where tip='akykt'
     and kod=@STOK_KOD
   
   end
   
    /*ortalama */
    SELECT @BRIM_FIYAT=Round(Sum(brimfiy*satmik)/Sum(satmik),6) from pomvardisayac
    where varno=@varno and sil=0 and satmik>0   and stkod=@STOK_KOD

   update pomvardistok set brimfiy=@BRIM_FIYAT where stktip='akykt'
   and kod=@STOK_KOD and varno=@varno

   update pomvarditank set brimfiy=@BRIM_FIYAT where stktip='akykt'
   and kod=@STOK_KOD and varno=@varno


  /* END */

  FETCH NEXT FROM sayacyenifiyat_cur  INTO @STOK_KOD/*,@BRIM_FIYAT */
  END

  CLOSE sayacyenifiyat_cur
  DEALLOCATE sayacyenifiyat_cur
  
  
  /*
  SELECT stkod,Max(Round(brimfiy,4)) from pomvardisayac
  where varno=@varno and sil=0 and satmik>0 group by 
  */


END

================================================================================
