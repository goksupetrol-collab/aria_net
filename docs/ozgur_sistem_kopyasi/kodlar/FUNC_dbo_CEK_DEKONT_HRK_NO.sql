-- Function: dbo.CEK_DEKONT_HRK_NO
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.647289
================================================================================

CREATE FUNCTION [dbo].[CEK_DEKONT_HRK_NO] (@drm varchar(10),
@HRK_NO INT)
RETURNS
  @TB_CEK_DEKONT TABLE (
    CARI_TIP    	VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    	VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  	VARCHAR(150) COLLATE Turkish_CI_AS,
    BANKA_KOD    	VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_UNVAN  	VARCHAR(150) COLLATE Turkish_CI_AS,
    CEK_BANKA    	VARCHAR(100) COLLATE Turkish_CI_AS,
    CEK_BANKA_SUBE  VARCHAR(100) COLLATE Turkish_CI_AS,
    CEK_HESAPNO     VARCHAR(50) COLLATE Turkish_CI_AS,
    CEK_KESIDECI    VARCHAR(100) COLLATE Turkish_CI_AS,
    TARIH       	DATETIME,
    SAAT        	VARCHAR(10) COLLATE Turkish_CI_AS,
    CEKNO       	VARCHAR(50) COLLATE Turkish_CI_AS,
    PARABIRIM   	VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR     	VARCHAR(70) COLLATE Turkish_CI_AS,
    ISLEM       	VARCHAR(50) COLLATE Turkish_CI_AS,
    TUTAR       	FLOAT,
    VADTAR      	DATETIME,
    CARI_FISBAKIYE  FLOAT,
    CARI_BAKIYE		FLOAT,
    CARI_TOPBAKIYE  FLOAT)
AS
BEGIN

   DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP         VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD     	 VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN   	 VARCHAR(150) COLLATE Turkish_CI_AS,
    BANKA_KOD    	 VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_UNVAN  	 VARCHAR(150) COLLATE Turkish_CI_AS,
    CEK_BANKA    	 VARCHAR(150) COLLATE Turkish_CI_AS,
    CEK_BANKA_SUBE   VARCHAR(150) COLLATE Turkish_CI_AS,
    CEK_KESIDECI     VARCHAR(150) COLLATE Turkish_CI_AS,
    CEK_HESAPNO      VARCHAR(100) COLLATE Turkish_CI_AS,        
    TARIH        	 DATETIME,
    SAAT         	 VARCHAR(10) COLLATE Turkish_CI_AS,
    CEKNO            VARCHAR(20) COLLATE Turkish_CI_AS,
    PARABIRIM    	 VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR      	 VARCHAR(70) COLLATE Turkish_CI_AS,
    ISLEM            VARCHAR(30) COLLATE Turkish_CI_AS,
    TUTAR            FLOAT,
    VADTAR           DATETIME,
    CARI_FISBAKIYE  FLOAT,
    CARI_BAKIYE		FLOAT,
    CARI_TOPBAKIYE  FLOAT )

    DECLARE @HRK_CARI_TIP     VARCHAR(30)
    DECLARE @HRK_CARI_KOD     VARCHAR(30)
    DECLARE @HRK_CARI_UNVAN   VARCHAR(150)
    DECLARE @HRK_BANKA_KOD    VARCHAR(30)
    DECLARE @HRK_BANKA_UNVAN  VARCHAR(150)
    DECLARE @HRK_CEKBANKA     VARCHAR(150)
    DECLARE @HRK_BANKASUBE    VARCHAR(150)
    DECLARE @HRK_HESAPNO      VARCHAR(50)
    DECLARE @HRK_CEKKESIDECI  VARCHAR(150)
        
    DECLARE @HRK_TARIH        DATETIME
    DECLARE @HRK_SAAT         VARCHAR(10)
    DECLARE @HRK_CEKNO        VARCHAR(50)
    DECLARE @HRK_PARABIRIM    VARCHAR(20)
    DECLARE @HRK_PARASTR      VARCHAR(70)
    DECLARE @HRK_ISLEM        VARCHAR(30)
    DECLARE @HRK_TUTAR        FLOAT
    DECLARE @HRK_VADTAR       DATETIME
    
    
   /*cek dekont */
     if @drm='TAK'
     begin
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp,car.kod,
     car.ad,ban.kod,ban.ad,hrk.banka,
     hrk.banksub,hrk.hesepno,hrk.kesideci,
      ch.tarih,ch.saat,
     ceksenno,abs(ch.tutar),ch.PARABRM,
     dbo.ParaOku(ABS(ch.tutar)),
     ch.drmad,vadetar from
     cekkart as hrk inner join cekhrk as ch
     on ch.cekid=hrk.cekid 
     inner join Genel_Kart as car
     on hrk.carkod=car.kod and hrk.cartip=car.cartp
     left join Genel_Kart as ban
     on hrk.vercartip=ban.cartp and hrk.vercarkod=ban.kod
     where ch.hrk_no=@HRK_NO
     end
     
     
     if @drm='POR'
     begin
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp,car.kod,
     car.ad,ban.kod,ban.ad,hrk.banka,
     hrk.banksub,hrk.hesepno,hrk.kesideci,
      ch.tarih,ch.saat,
     ceksenno,abs(ch.tutar),ch.PARABRM,
     dbo.ParaOku(ABS(ch.tutar)),
     ch.drmad,vadetar from
     cekkart as hrk inner join cekhrk as ch
     on ch.cekid=hrk.cekid 
     inner join Genel_Kart as car
     on hrk.carkod=car.kod and hrk.cartip=car.cartp
     left join Genel_Kart as ban
     on hrk.vercartip=ban.cartp and hrk.vercarkod=ban.kod
     where ch.hrk_no=@HRK_NO
     end
     
     
     
     if @drm='KSN'
     begin
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp,car.kod,
     car.ad,ban.kod,ban.ad,hrk.banka,
     hrk.banksub,hrk.hesepno,hrk.kesideci,
     ch.tarih,ch.saat,
     ceksenno,abs(ch.tutar),ch.PARABRM,
     dbo.ParaOku(ABS(ch.tutar)),
     ch.drmad,vadetar from
     cekkart as hrk inner join cekhrk as ch
     on ch.cekid=hrk.cekid 
     inner join Genel_Kart as car
     on hrk.vercarkod=car.kod and hrk.vercartip=car.cartp
     left join Genel_Kart as ban
     on ban.cartp='bankkart' and hrk.bankod=ban.kod
     where ch.hrk_no=@HRK_NO
     end
     
     
     
     if @drm='CIR'
     begin
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp,car.kod,
     car.ad,ban.kod,ban.ad,hrk.banka,
     hrk.banksub,hrk.hesepno,hrk.kesideci,
     ch.tarih,ch.saat,
     ceksenno,abs(ch.tutar),ch.PARABRM,
     dbo.ParaOku(ABS(ch.tutar)),
     ch.drmad,vadetar from
     cekkart as hrk inner join cekhrk as ch
     on ch.cekid=hrk.cekid 
     inner join Genel_Kart as car
     on hrk.vercarkod=car.kod and hrk.vercartip=car.cartp
     left join Genel_Kart as ban
     on ban.cartp='bankkart' and hrk.bankod=ban.kod
     where ch.hrk_no=@HRK_NO
     end
     
     
     
     

   OPEN CRS_HRK

   FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
   @HRK_BANKA_KOD,@HRK_BANKA_UNVAN,@HRK_CEKBANKA,
   @HRK_BANKASUBE,@HRK_HESAPNO,@HRK_CEKKESIDECI,
   @HRK_TARIH,@HRK_SAAT,@HRK_CEKNO,
   @HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_VADTAR

  WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_BANKA_KOD,@HRK_BANKA_UNVAN,@HRK_CEKBANKA,
       @HRK_BANKASUBE,@HRK_HESAPNO,@HRK_CEKKESIDECI,
       @HRK_TARIH,@HRK_SAAT,@HRK_CEKNO,
       @HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_TUTAR,@HRK_VADTAR,
       0,0,0

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
    @HRK_BANKA_KOD,@HRK_BANKA_UNVAN,@HRK_CEKBANKA,
    @HRK_BANKASUBE,@HRK_HESAPNO,@HRK_CEKKESIDECI,
    @HRK_TARIH,@HRK_SAAT,@HRK_CEKNO,
   @HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_VADTAR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
  /*---------------------------------------------------------------------------- */

  UPDATE @EKSTRE_TEMP SET 
   CARI_FISBAKIYE=DT.fisbak,
    CARI_BAKIYE=dt.carbak,
    CARI_TOPBAKIYE=dt.topbak
    from @EKSTRE_TEMP as t 
    join 
    (select kod,cartp,fisbak,carbak,topbak 
    from View_Cariler_Kart_Bakiye as cb )
    dt on t.CARI_TIP=dt.cartp and t.CARI_KOD=dt.kod



  INSERT @TB_CEK_DEKONT
    SELECT * FROM @EKSTRE_TEMP

  RETURN
END

================================================================================
