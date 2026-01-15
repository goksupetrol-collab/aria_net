-- Function: dbo.UDF_FATURA_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.714506
================================================================================

CREATE FUNCTION UDF_FATURA_RAP
(@Firmano		int,
@FATIN          VARCHAR(4000),
@CARTIPIN        VARCHAR(300),
@CARIN           VARCHAR(8000),
@TARTIP          INT,
@BASTAR          DATETIME,
@BITTAR          DATETIME)
RETURNS
  @TB_FATURA_RAP TABLE (
  FirmaNo				  int,
  FirmaUNVAN              VARCHAR(150) COLLATE Turkish_CI_AS,
  FAT_ID                  VARCHAR(30) COLLATE Turkish_CI_AS,
  FATRAP_ID				  INT,
  CARI_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_UNVAN              VARCHAR(150) COLLATE Turkish_CI_AS,
  FAT_SERINO              VARCHAR(30) COLLATE Turkish_CI_AS,
  FAT_AD                  VARCHAR(50) COLLATE Turkish_CI_AS,
  ISLEMTARIHI             DATETIME,
  VADETARIHI              DATETIME,
  GIDERTOPLAM             FLOAT,
  ARATOPLAM               FLOAT,
  KDVTOPLAM               FLOAT,
  ISKTOPLAM               FLOAT,
  ISKYUZDE				  FLOAT,	
  TOPLAMTUTAR             FLOAT,
  ODEMETOPLAM             FLOAT,
  SIL                     BIT,
  TY                      TINYINT,
  BG                      BIGINT,
  DC                      DECIMAL(12,5))
AS
BEGIN

   if @TARTIP=-1
    begin
    insert into @TB_FATURA_RAP
    (FirmaNo,FAT_ID,FATRAP_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
     GIDERTOPLAM,ARATOPLAM,KDVTOPLAM,ISKYUZDE,ISKTOPLAM,TOPLAMTUTAR,ODEMETOPLAM)
     select 0,0,0,'','','','',null,NULL,0,0,0,0,0,0,0
      Return
    end 
    

    if @TARTIP=0 /*işlem tarihine göre */
    insert into @TB_FATURA_RAP
    (firmano,FAT_ID,FATRAP_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
    GIDERTOPLAM,ARATOPLAM,KDVTOPLAM,ISKYUZDE,ISKTOPLAM,TOPLAMTUTAR,ODEMETOPLAM)
    select m.firmano,'F'+CAST(M.fatid AS varchar),m.fatrap_id,
    car.kod,car.ad,(fatseri+fatno),m.fatad,m.tarih,m.vadtar,
    m.gidertop,((m.fattop)-(m.satisktop+m.genisktop)),m.kdvtop,
    case when (m.fattop)>0 then 
    ((m.genel_isk_top)*100)/(m.fattop) else 0 end,
    (m.genel_isk_top),
    (((m.fattop)-(m.genel_isk_top))+(m.kdvtop+m.giderkdvtop+m.gidertop+m.yuvtop)),
    m.odemetop from faturamas as m WITH (NOLOCK)
    inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
    where m.sil=0 and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.tarih>=@BASTAR and m.tarih<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    order by m.tarih
    
    
    if @TARTIP=1 /*vade tarihine göre */
    insert into @TB_FATURA_RAP
    (FirmaNo,FAT_ID,FATRAP_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
    GIDERTOPLAM,ARATOPLAM,KDVTOPLAM,ISKYUZDE,ISKTOPLAM,TOPLAMTUTAR,ODEMETOPLAM)
    select m.firmano,'F'+CAST(M.fatid AS varchar),m.fatrap_id,
    car.kod,car.ad,(fatseri+fatno),m.fatad,m.tarih,m.vadtar,
    m.gidertop,((m.fattop)-(m.satisktop+m.genisktop)),m.kdvtop,
    case when (m.fattop)>0 then 
    ((m.genel_isk_top)*100)/(m.fattop) else 0 end,
    (m.genel_isk_top),
    (((m.fattop)-(m.genel_isk_top))+(m.kdvtop+m.giderkdvtop+m.gidertop+m.yuvtop)),
    m.odemetop from faturamas as m WITH (NOLOCK)
    inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
    where m.sil=0 and m.fatrap_id in (select * from CsvToSTR(@FATIN) )
    and m.vadtar>=@BASTAR and m.vadtar<=@BITTAR
    and m.cartip in (select * from CsvToSTR(@CARTIPIN))
    order by m.vadtar
    

    if (select count(*) from CsvToSTR(@FATIN) 
    where STRValue='0' )>0
     insert into @TB_FATURA_RAP
     (FirmaNo,FAT_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
     GIDERTOPLAM,ARATOPLAM,KDVTOPLAM,ISKYUZDE,ISKTOPLAM,TOPLAMTUTAR,ODEMETOPLAM)
     select m.firmano,'Z'+CAST(m.zrapid AS varchar),car.kod,car.ad,
     yk.ad+' / '+
     (zseri+zserino),
     'Z RAPOR',m.tarih,m.tarih,
     0,m.genel_ara_top,m.genel_kdv_top,/*m.kdvtop, */
     0,0,(m.genel_top),
     0 from zrapormas as m WITH (NOLOCK)
     inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
     inner join yazarkasakart as yk on yk.kod=m.ykkod
     where m.sil=0  and m.tarih>=@BASTAR and m.tarih<=@BITTAR
     and m.cartip in (select * from CsvToSTR(@CARTIPIN))
     order by m.tarih 
    
     if @Firmano>0
      delete from @TB_FATURA_RAP where firmano not in (@Firmano,0) 
    
    
     if @CARIN<>'' 
      delete from  @TB_FATURA_RAP
      where CARI_KOD not in (select * from CsvToSTR(@CARIN)) 
      
  
      
     update @TB_FATURA_RAP set FirmaUNVAN=dt.ad from @TB_FATURA_RAP as t 
     join (select id,ad from firma ) dt on dt.id=t.Firmano  
      
      
      

    
   RETURN


END

================================================================================
