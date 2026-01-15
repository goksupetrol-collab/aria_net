-- Stored Procedure: dbo.GENEL_GECVAROZETOLUSTUR
-- Tarih: 2026-01-14 20:06:08.331573
================================================================================

CREATE PROCEDURE [dbo].GENEL_GECVAROZETOLUSTUR 
(@TIP varchar(20),@VARNOIN VARCHAR(max))
AS
BEGIN
declare @sil 	int
declare @varok 	int
declare @varno 	int


 /*--vardiya özet tablosuna kapanış bilgilerini at */
 if @TIP='pomvardimas'
 begin
  
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT varno FROM pomvardimas with (nolock) where varno in (select * from CsvToInt_Max(@VARNOIN))
    and sil=0 and varok=1 ORDER BY varno
    OPEN CRS_HRK
   FETCH NEXT FROM CRS_HRK INTO  @varno
    WHILE @@FETCH_STATUS = 0
     BEGIN 

    delete from pomvardiozet where varno=@varno
    
    select @varok=varok,@sil=sil from pomvardimas with (nolock)  where varno=@varno

    exec pomvarozet_Yeni @varno,'per','genel'
    insert into pomvardiozet (varno,varok,sil,tip,tipack,giris,cikis,bakiye,sr)
    select @varno,@varok,@sil,ickkod,ickad,sum(grs),sum(cks),sum(grs-cks),sr
    from ##pomvardiozet where varno=@varno
    group by ickkod,ickad,sr order by sr

     FETCH NEXT FROM CRS_HRK INTO @varno
    END
   CLOSE CRS_HRK
   DEALLOCATE CRS_HRK
 end

 /*--vardiya özet tablosuna kapanış bilgilerini at */
 if @TIP='marvardimas'
 begin
 
 DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT varno FROM marvardimas with (nolock)  where varno in (select * from CsvToInt_Max(@VARNOIN))
    and sil=0 and varok=1 ORDER BY varno
    OPEN CRS_HRK
   FETCH NEXT FROM CRS_HRK INTO  @varno
    WHILE @@FETCH_STATUS = 0
     BEGIN 

     delete from marvardiozet where varno=@varno
     select @varok=varok,@sil=sil from marvardimas with (nolock)  where varno=@varno
     exec marvarozet @varno,'per','genel'
     insert into marvardiozet (varno,varok,sil,tip,tipack,giris,cikis,bakiye,sr)
     select @varno,@varok,@sil,ickkod,ickad,sum(grs),sum(cks),sum(grs-cks),sr
     from ##marvardiozet where varno=@varno
     group by ickkod,ickad,sr order by sr
    /*------------------------ */

     FETCH NEXT FROM CRS_HRK INTO @varno
    END
   CLOSE CRS_HRK
   DEALLOCATE CRS_HRK

 end
 
 
 /*--vardiya özet tablosuna kapanış bilgilerini at */
 if @TIP='resvardimas'
 begin
 
 DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT varno FROM resvardimas with (nolock)  where varno in (select * from CsvToInt_Max(@VARNOIN))
    and sil=0 and varok=1 ORDER BY varno
    OPEN CRS_HRK
   FETCH NEXT FROM CRS_HRK INTO  @varno
    WHILE @@FETCH_STATUS = 0
     BEGIN 

     delete from resvardiozet where varno=@varno
     select @varok=varok,@sil=sil from resvardimas with (nolock)  where varno=@varno
     exec resvarozet @varno,'per','genel'
     insert into resvardiozet (varno,varok,sil,tip,tipack,giris,cikis,bakiye,sr)
     select @varno,@varok,@sil,ickkod,ickad,sum(grs),sum(cks),sum(grs-cks),sr
     from ##resvardiozet where varno=@varno
     group by ickkod,ickad,sr order by sr
    /*------------------------ */

     FETCH NEXT FROM CRS_HRK INTO @varno
    END
   CLOSE CRS_HRK
   DEALLOCATE CRS_HRK

 end
 
  
END

================================================================================
