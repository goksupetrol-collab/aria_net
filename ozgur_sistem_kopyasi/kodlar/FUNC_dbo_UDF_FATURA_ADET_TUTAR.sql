-- Function: dbo.UDF_FATURA_ADET_TUTAR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.713643
================================================================================

CREATE FUNCTION [dbo].[UDF_FATURA_ADET_TUTAR]
(@Firmano		int,
@FATIN          VARCHAR(4000),
@CARTIPIN        VARCHAR(300),
@CARIN           VARCHAR(8000),
@TARTIP          INT,
@BASTAR          DATETIME,
@BITTAR          DATETIME,
@FAT_ADET		 INT,
@FAT_TUTAR		 FLOAT)
RETURNS
  @TB_FATURA_RAP TABLE (
  FirmaNo				   int,
  CARI_TIP                 VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_KOD                 VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_UNVAN               VARCHAR(150) COLLATE Turkish_CI_AS,
  CARI_VERGINO			   VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_VERGIDAIRE		   VARCHAR(100) COLLATE Turkish_CI_AS,
  CARI_TCNO				   VARCHAR(30) COLLATE Turkish_CI_AS,
  FAT_ADET                 INT,
  KDVSIZ_TOPLAM            FLOAT,
  KDV_TOPLAM               FLOAT,
  ISKONTO_TOPLAM           FLOAT,
  ISKONTOLU_TOPLAM         FLOAT,
  YUV_TOPLAM               FLOAT,
  GENEL_TOPLAM             FLOAT
  )
AS
BEGIN

    if @TARTIP=0 and @Firmano=0   /*işlem tarihine göre */
    insert into @TB_FATURA_RAP
    (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
    CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
    KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
    ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
    select max(m.firmano),car.tip,car.kod,car.ad,
    car.vergino,car.vergidaire,car.tcno,
    count(m.id),
    sum(m.fattop),sum(m.genel_kdv_top),sum(m.genel_isk_top),
    sum(m.genel_net_top),sum(m.yuvtop),sum(genel_top) from faturamas as m with (nolock)
    inner join Genel_Kart as car with (nolock) on m.carkod=car.kod and m.cartip=car.cartp
    where m.sil=0 and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.tarih>=@BASTAR and m.tarih<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
    having count(m.id)>@FAT_ADET and sum(m.genel_net_top)>@FAT_TUTAR
  
    
    if @TARTIP=0 and @Firmano>0   /*işlem tarihine göre */
    insert into @TB_FATURA_RAP
    (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
    CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
    KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
    ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
    select max(m.firmano),car.tip,car.kod,car.ad,
    car.vergino,car.vergidaire,car.tcno,
    count(m.id),
    sum(m.fattop),sum(m.genel_kdv_top),sum(m.genel_isk_top),
    sum(m.genel_net_top),sum(m.yuvtop),sum(genel_top) from faturamas as m with (nolock)
    inner join Genel_Kart as car with (nolock) on m.carkod=car.kod and m.cartip=car.cartp
    where m.firmano in (@Firmano,0)
    and m.sil=0 
    and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.tarih>=@BASTAR and m.tarih<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
    having count(m.id)>@FAT_ADET and sum(m.genel_net_top)>@FAT_TUTAR
    
   
    
    
    
    
    if @TARTIP=1 and @firmano=0 /*vade tarihine göre */
    insert into @TB_FATURA_RAP
    (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
    CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
    KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
    ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
    select max(m.firmano),car.tip,car.kod,car.ad,
    car.vergino,car.vergidaire,car.tcno,count(m.id),
    sum(m.fattop),sum(m.genel_kdv_top),sum(m.genel_isk_top),
    sum(m.genel_net_top),sum(m.yuvtop),sum(genel_top) from faturamas as m with (nolock)
    inner join Genel_Kart as car with (nolock) on m.carkod=car.kod and m.cartip=car.cartp
    where m.sil=0 and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.vadtar>=@BASTAR and m.vadtar<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
    having count(m.id)>@FAT_ADET and sum(m.genel_net_top)>@FAT_TUTAR
  
    
    if @TARTIP=1 and @firmano>0 /*vade tarihine göre */
    insert into @TB_FATURA_RAP
    (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
    CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
    KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
    ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
    select max(m.firmano),car.tip,car.kod,car.ad,
    car.vergino,car.vergidaire,car.tcno,count(m.id),
    sum(m.fattop),sum(m.genel_kdv_top),sum(m.genel_isk_top),
    sum(m.genel_net_top),sum(m.yuvtop),sum(genel_top) from faturamas as m with (nolock)
    inner join Genel_Kart as car with (nolock) on m.carkod=car.kod and m.cartip=car.cartp
    where m.firmano in (@Firmano,0)
    and m.sil=0 
    and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.vadtar>=@BASTAR and m.vadtar<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
    having count(m.id)>@FAT_ADET and sum(m.genel_net_top)>@FAT_TUTAR
    
    
    
       
    if (select count(*) from CsvToSTR(@FATIN) 
     where STRValue='0' )>0
      begin
      
      if @firmano=0 
      insert into @TB_FATURA_RAP
      (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
      CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
      KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
      ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
       select max(m.firmano),CAR.tip,car.kod,car.ad,
       car.vergino,car.vergidaire,car.tcno,
       count(m.id),sum(m.genel_top-m.genel_kdv_top),
       sum(m.genel_kdv_top),0,
       sum(m.genel_top-m.genel_kdv_top),0,
       sum(m.genel_top)
        from zrapormas as m with (nolock)
        inner join Genel_Kart as car with (nolock) on m.carkod=car.kod and
        m.cartip=car.cartp
        inner join yazarkasakart as yk with (nolock) on yk.kod=m.ykkod
        where m.sil=0  and m.tarih>=@BASTAR and m.tarih<=@BITTAR
        and m.cartip in (select * from CsvToSTR(@CARTIPIN))
        group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
        having count(m.id)>@FAT_ADET and 
        sum(m.genel_top-m.genel_kdv_top)>@FAT_TUTAR 
        
        
        
        
       if @firmano>0 
       insert into @TB_FATURA_RAP
       (FirmaNo,CARI_TIP,CARI_KOD,CARI_UNVAN,
       CARI_VERGINO,CARI_VERGIDAIRE,CARI_TCNO,FAT_ADET,
       KDVSIZ_TOPLAM,KDV_TOPLAM,ISKONTO_TOPLAM,
       ISKONTOLU_TOPLAM,YUV_TOPLAM,GENEL_TOPLAM)
       select max(m.firmano),CAR.tip,car.kod,car.ad,
       car.vergino,car.vergidaire,car.tcno,
       count(m.id),sum(m.genel_top-m.genel_kdv_top),
       sum(m.genel_kdv_top),0,
       sum(m.genel_top-m.genel_kdv_top),0,
       sum(m.genel_top)
        from zrapormas as m with (nolock)
        inner join Genel_Kart as car  with (nolock) on m.carkod=car.kod and
        m.cartip=car.cartp
        inner join yazarkasakart as yk with (nolock) on yk.kod=m.ykkod
        where m.firmano in (@Firmano,0)
        and m.sil=0  and m.tarih>=@BASTAR and m.tarih<=@BITTAR
        and m.cartip in (select * from CsvToSTR(@CARTIPIN))
        group by car.tip,car.kod,car.ad,car.vergino,car.vergidaire,car.tcno
        having count(m.id)>@FAT_ADET and 
        sum(m.genel_top-m.genel_kdv_top)>@FAT_TUTAR 
        
        
   
     end
    
    
    
    
  
    
    
     if @CARIN<>'' 
      delete from  @TB_FATURA_RAP
      where CARI_KOD not in (select * from CsvToSTR(@CARIN)) 

    
   RETURN


END

================================================================================
