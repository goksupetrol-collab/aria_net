-- Function: dbo.Cek_Senet_Cari
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.647641
================================================================================

CREATE FUNCTION [dbo].Cek_Senet_Cari (
@firmano	int,
@ISLEMHRK  	VARCHAR(200),
@DRMIN   	VARCHAR(200),
@TARTIP  	VARCHAR(20),
@BASTAR  	DATETIME,
@BITTAR  	DATETIME,
@BANKA		VARCHAR(100),
@SILIN   	VARCHAR(20),
@SONUC		int)
RETURNS
  @TB_CEK_CARILER TABLE (
  CAR_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
  CAR_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
  CAR_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS)
AS
BEGIN

   DECLARE @GC_TB_CEK_CARILER TABLE (
   FirmaNo	   INT, 
   CAR_TIP     VARCHAR(30)  COLLATE Turkish_CI_AS,
   CAR_KOD     VARCHAR(50)  COLLATE Turkish_CI_AS,
   CAR_UNVAN   VARCHAR(150)  COLLATE Turkish_CI_AS,
   BNK_UNVAN   VARCHAR(100)  COLLATE Turkish_CI_AS,
   DRM         VARCHAR(30)  COLLATE Turkish_CI_AS,
   ISLEMHRK   	VARCHAR(30)  COLLATE Turkish_CI_AS,
   SONUC		INT)


    if @TARTIP='tarih'
    begin
     insert into @GC_TB_CEK_CARILER
     (FirmaNo,CAR_TIP,CAR_KOD,CAR_UNVAN,BNK_UNVAN,
     DRM,ISLEMHRK,SONUC)
     SELECT cek.firmano,
     case when gctip='G' THEN cartip else vercartip end,
     case when gctip='G' THEN carkod else vercarkod end,
     case when gctip='G' THEN ac.ad else vc.ad end,
     cek.banka,drm,cek.islmhrk,cek.sonuc
     from cekkart as cek
     left join genel_kart as ac on cek.carkod=ac.kod
     and cek.cartip=ac.cartp
     left join genel_kart as vc on cek.vercarkod=vc.kod
     and cek.vercartip=vc.cartp
     where tarih>=@BASTAR and tarih<=@BITTAR
     and cek.sil in (select * from CsvToSTR(@SILIN) )
    end
    
    
     if @TARTIP='vadetar'
    begin
     insert into @GC_TB_CEK_CARILER
     (Firmano,CAR_TIP,CAR_KOD,CAR_UNVAN,BNK_UNVAN,
     DRM,ISLEMHRK,SONUC)
     SELECT cek.firmano,
     case when gctip='G' THEN cartip else vercartip end,
     case when gctip='G' THEN carkod else vercarkod end,
     case when gctip='G' THEN ac.ad else vc.ad end,
     cek.banka,drm,cek.islmhrk,cek.sonuc
     from cekkart as cek
     left join genel_kart as ac on cek.carkod=ac.kod
     and cek.cartip=ac.cartp
     left join genel_kart as vc on cek.vercarkod=vc.kod
     and cek.vercartip=vc.cartp
     where vadetar>=@BASTAR and vadetar<=@BITTAR
     and cek.sil in (select * from CsvToSTR(@SILIN) )
    end
    
    
    if @firmano>0
      delete from @GC_TB_CEK_CARILER where FirmaNo not in (@firmano,0)
    

    if @SONUC=1
      delete from @GC_TB_CEK_CARILER where SONUC not in (0,NULL)


    
    
    if @ISLEMHRK<>'' and @BANKA=''
     begin
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     where ISLEMHRK=@ISLEMHRK
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN
     RETURN
     end 
    
     if @ISLEMHRK<>'' and @BANKA<>''
     begin
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     where ISLEMHRK=@ISLEMHRK AND BNK_UNVAN=@BANKA
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN
     RETURN
     end 
    
   
     if @DRMIN <> '' and @BANKA=''
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     where drm in (select * from CsvToSTR(@DRMIN) )
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN
     
     if @DRMIN <> '' and @BANKA<>''
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     where drm in (select * from CsvToSTR(@DRMIN) ) AND BNK_UNVAN=@BANKA
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN
     
     
     if @DRMIN = '' and @BANKA=''
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN
     
     if @DRMIN = '' and @BANKA<>''
     insert into @TB_CEK_CARILER
     (CAR_TIP,CAR_KOD,CAR_UNVAN)
     SELECT CAR_TIP,CAR_KOD,CAR_UNVAN FROM @GC_TB_CEK_CARILER
     where  BNK_UNVAN=@BANKA
     GROUP BY CAR_TIP,CAR_KOD,CAR_UNVAN order by CAR_UNVAN   
     
      
    

RETURN
  
  
  
END

================================================================================
