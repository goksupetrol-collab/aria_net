-- Function: dbo.UDF_FATURA_PERIYOT_STOK_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.714067
================================================================================

CREATE FUNCTION [dbo].[UDF_FATURA_PERIYOT_STOK_RAP]
(@FirmaNo		int,
@PERIYOTTIP     INT,
@STKTIPIN        VARCHAR(100),
@FATTIPIN        VARCHAR(500),
@CARTIPIN        VARCHAR(300),
@CARIN           VARCHAR(8000),
@TARTIP          INT,
@BASTAR          DATETIME,
@BITTAR          DATETIME,
@ORT_BRM		 INT)
RETURNS
  @TB_FATURA_RAP TABLE (
  FirmaNo				  int,
  FAT_ID                  INT,
  YIL					  INT,
  AY					  INT,
  GUN					  INT,
  HAFTA					  INT,
  PERIYOT_AD			  VARCHAR(30) COLLATE Turkish_CI_AS,
  PERIYOT_TIP			  VARCHAR(30) COLLATE Turkish_CI_AS,
  ISLEMTARIHI             DATETIME,
  VADETARIHI              DATETIME,
  STOK_TIP                INT,
  STOK_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_AD                 VARCHAR(150) COLLATE Turkish_CI_AS,
  STOK_BIRIM              VARCHAR(30) COLLATE Turkish_CI_AS,
  KDV                     FLOAT,
  MIKTAR                  FLOAT,
  BRIMFIYAT               FLOAT,
  TUTAR                   FLOAT,
  KDVLIBRIMFIYAT          FLOAT,
  KDVTUTAR				  FLOAT,	
  KDVLITUTAR              FLOAT)
AS
BEGIN


  DECLARE  @TB_FATURA_RAP_HRK TABLE (
  FirmaNo				  int,
  FAT_ID                  INT,
  ZRAPID				  INT,
  YIL					  INT,
  AY					  INT,
  GUN					  INT,
  HAFTA					  INT,
  PERIYOT_NO			  VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_UNVAN              VARCHAR(150) COLLATE Turkish_CI_AS,
  FAT_SERINO              VARCHAR(30) COLLATE Turkish_CI_AS,
  FAT_AD                  VARCHAR(50) COLLATE Turkish_CI_AS,
  ISLEMTARIHI             DATETIME,
  VADETARIHI              DATETIME,
  KDVTOPLAM               FLOAT,
  ISKTOPLAM               FLOAT,
  STOK_TIP                INT,
  STOK_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_AD                 VARCHAR(150) COLLATE Turkish_CI_AS,
  STOK_BIRIM              VARCHAR(30) COLLATE Turkish_CI_AS,
  KDV                     FLOAT,
  MIKTAR                  FLOAT,
  BRIMFIYAT               FLOAT,
  TUTAR                   FLOAT,
  KDVTUTAR				  FLOAT,
  KDVLITUTAR              FLOAT)





    
      
      
      
      
      
     if (@TARTIP=0)   /*işlem tarihine göre */
     insert into @TB_FATURA_RAP_HRK
     (FirmaNo,FAT_ID,ZRAPID,YIL,AY,GUN,HAFTA,
      CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,
      KDV,MIKTAR,
      BRIMFIYAT,TUTAR,KDVLITUTAR)
      select m.firmano,m.fatid,0,
      year(m.tarih),month(m.tarih),DAY(m.tarih),
      datepart(wk,m.tarih),
      car.kod,car.ad,(fatseri+fatno) FATSERINO,m.fatad,m.tarih,m.vadtar,
      case when st.tip='akykt' then 1 
      when st.tip='markt' then 2
      else 3 end,
      st.kod,st.ad,h.brim,h.kdvyuz*100,(mik),
      ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)),
      ( ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) *mik),
      ( ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) *mik) *(1+KDVYUZ)
      from faturamas as m  inner join faturahrk as h  on h.fatid=m.fatid and m.sil=0 and h.sil=0
      inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
      inner join gelgidlistok as st on h.stkod=st.kod and st.tip=h.stktip
      where m.fatrap_id in (select * from CsvToSTR(@FATTIPIN) )
      and m.tarih>=@BASTAR and m.tarih<=@BITTAR
      and m.cartip in (select * from CsvToSTR(@CARTIPIN))
      order by st.kod
      
      
       
      
      
     if (@TARTIP=1)   /*vade tarihine göre */
     insert into @TB_FATURA_RAP_HRK
     (FirmaNo,FAT_ID,ZRAPID,YIL,AY,GUN,HAFTA,
      CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,
      KDV,MIKTAR,BRIMFIYAT,TUTAR,KDVLITUTAR)
      select m.firmano,m.fatid,0,year(m.tarih),month(m.tarih),DAY(m.tarih),
      datepart(wk,m.tarih),car.kod,car.ad,(fatseri+fatno) FATSERINO,m.fatad,m.tarih,m.vadtar,
      case when st.tip='akykt' then 1 
      when st.tip='markt' then 2
      else 3 end,
      st.kod,st.ad,h.brim,h.kdvyuz*100,(mik),
      ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)),
      ( ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) *mik),
      ( ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)) *mik) *(1+KDVYUZ)
      from faturamas as m  inner join  faturahrk as h  on h.fatid=m.fatid and m.sil=0 and h.sil=0
      inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
      inner join gelgidlistok as st on h.stkod=st.kod and st.tip=h.stktip
      where m.fatrap_id in (select * from CsvToSTR(@FATTIPIN) )
      and m.vadtar>=@BASTAR and m.vadtar<=@BITTAR
      and m.cartip in (select * from CsvToSTR(@CARTIPIN))
      order by st.kod
      
      
      
    if (select count(*) from CsvToSTR(@FATTIPIN) 
     where STRValue='0' )>0
      begin
     insert into @TB_FATURA_RAP_HRK
     (FirmaNo,FAT_ID,ZRAPID,YIL,AY,GUN,HAFTA,
      CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,
      KDV,MIKTAR,
      BRIMFIYAT,TUTAR,KDVLITUTAR)
      select m.firmano,m.zrapid,m.zrapid,
       year(m.tarih),month(m.tarih),DAY(m.tarih),
       datepart(wk,m.tarih),car.kod,car.ad,
       yk.ad+' / '+(zseri+zserino),
       'Z RAPOR',m.tarih,m.tarih,
       case when h.tip='akykt' then 1 
       when h.tip='markt' then 2
       else 3 end,h.kod,'','',
       h.kdvyuz*100,h.miktar,
       h.brmfiy/(1+h.kdvyuz),
       (h.miktar*h.brmfiy)/(1+h.kdvyuz),
       (h.miktar*h.brmfiy)
        from zrapormas as m
       inner join zraporhrk as h 
       on m.zrapid=h.zrapid and h.sil=0
     inner join Genel_Kart as car on m.carkod=car.kod and
      m.cartip=car.cartp
     inner join yazarkasakart as yk on yk.kod=m.ykkod
     where m.sil=0  and m.tarih>=@BASTAR and m.tarih<=@BITTAR
     and m.cartip in (select * from CsvToSTR(@CARTIPIN))
     order by m.tarih 
     
     
     if @Firmano>0
      delete from @TB_FATURA_RAP_HRK where firmano not in (@Firmano,0)
     
     
     
     
     update  @TB_FATURA_RAP_HRK
     SET STOK_AD=DT.AD FROM @TB_FATURA_RAP_HRK as t
     join (select tip_id,kod,ad from stokkart )dt
     on dt.kod=t.STOK_KOD and t.STOK_TIP=dt.tip_id
     and t.ZRAPID>0
     
     
     update  @TB_FATURA_RAP_HRK
     SET STOK_AD=DT.AD FROM @TB_FATURA_RAP_HRK as t
     join (select id,ad from grup )dt
     on dt.id=t.STOK_KOD and t.STOK_TIP=2
     and t.ZRAPID>0
     
     
     
     
     
     
     
     end
      
      
      
      
      

     if @CARIN<>'' 
      delete from  @TB_FATURA_RAP_HRK
      where CARI_KOD not in (select * from CsvToSTR(@CARIN)) 
      
    
     IF (@PERIYOTTIP=0) and (@ORT_BRM=0)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT convert(varchar,ISLEMTARIHI,104),'GÜNLÜK',
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      BRIMFIYAT,
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,BRIMFIYAT,
      STOK_BIRIM,KDV 
    
      
      
     IF (@PERIYOTTIP=0) and (@ORT_BRM=1)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT convert(varchar,ISLEMTARIHI,104),'GÜNLÜK',
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      SUM(TUTAR)/SUM(MIKTAR),
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV   
      
      
     IF (@PERIYOTTIP=1) and (@ORT_BRM=0)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+
      CAST(case when hafta=53 then 1 else hafta-1 end as varchar)
      ,'HAFTALIK',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      BRIMFIYAT,
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,HAFTA,
      STOK_TIP,STOK_KOD,STOK_AD,BRIMFIYAT,STOK_BIRIM,KDV 
 
   
      
      
     IF (@PERIYOTTIP=1) and (@ORT_BRM=1)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+
      CAST(case when hafta=53 then 1 else hafta-1 end as varchar)
      ,'HAFTALIK',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      SUM(TUTAR)/SUM(MIKTAR),
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,HAFTA,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV 
      
      
      
      IF (@PERIYOTTIP=2) and (@ORT_BRM=0)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+
      CAST(ay as varchar),'AYLIK',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      BRIMFIYAT,
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,AY,
      STOK_TIP,STOK_KOD,STOK_AD,BRIMFIYAT,STOK_BIRIM,KDV  
      
      
      
      
      
       
     IF (@PERIYOTTIP=2) and (@ORT_BRM=1)
     insert into @TB_FATURA_RAP
     (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+
      CAST(ay as varchar),'AYLIK',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      SUM(TUTAR)/SUM(MIKTAR),
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,AY,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV  
      
      
     IF @PERIYOTTIP=3
      begin
      
      update @TB_FATURA_RAP_HRK
      set PERIYOT_NO=
      CASE 
      WHEN (GUN>=1 AND GUN<=7) THEN '1..7'
      WHEN (GUN>=8 AND GUN<=14) THEN '8..14'
      WHEN (GUN>=15 AND GUN<=21) THEN '15..21'
      WHEN (GUN>=22 AND GUN<=28) THEN '22..28'
      WHEN (GUN>=29 ) THEN '29..SON GÜN' END
      
      
      
      if (@ORT_BRM=0)
      insert into @TB_FATURA_RAP
      (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+CAST(ay as varchar)+
      '-'+PERIYOT_NO,'SEÇİMLİ',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      BRIMFIYAT,
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,AY,PERIYOT_NO,
      STOK_TIP,STOK_KOD,STOK_AD,BRIMFIYAT,STOK_BIRIM,KDV 
      
      
      
      
      if (@ORT_BRM=1)
      insert into @TB_FATURA_RAP
      (PERIYOT_AD,PERIYOT_TIP,
      ISLEMTARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      MIKTAR,BRIMFIYAT,TUTAR,
      KDVTUTAR,KDVLIBRIMFIYAT,KDVLITUTAR)
      SELECT 
      cast(YIL AS VARCHAR)+'-'+CAST(ay as varchar)+
      '-'+PERIYOT_NO,'SEÇİMLİ',NULL,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,
      SUM(MIKTAR),
      SUM(TUTAR)/SUM(MIKTAR),
      SUM(TUTAR),
      SUM(KDVLITUTAR)-SUM(TUTAR),
      SUM(KDVLITUTAR)/SUM(MIKTAR),
      SUM(KDVLITUTAR) FROM @TB_FATURA_RAP_HRK
      where STOK_TIP IN (SELECT * FROM CsvToInt(@STKTIPIN))
      GROUP BY YIL,AY,PERIYOT_NO,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV   
      
      
            
         
      
      
      end
      
      



   RETURN


END

================================================================================
