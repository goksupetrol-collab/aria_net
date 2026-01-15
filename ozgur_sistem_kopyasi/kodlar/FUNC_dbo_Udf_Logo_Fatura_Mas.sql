-- Function: dbo.Udf_Logo_Fatura_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.739097
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Fatura_Mas]
(@Firmano		int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  Firmano				 int,
  fat_id                 int,
  FatRap_id				 int,
  Petro_Evrak_Tip        varchar(30),
  hrk_tipno				 int,
  hrk_tip				 varchar(10),
  hrk_tipad				 varchar(50),
  hrk_ack				 varchar(200),
  tarih                  datetime,
  saat                   varchar(10),
  car_kod				 varchar(30),
  car_muhonkod			 varchar(30),
  car_muhkod			 varchar(30),
  car_unvan				 varchar(150),
  belgeno			     Varchar(30),
  fat_gider              float,
  fat_iskonto			 float,
  fat_isk_yuz            float,					
  fat_kdvtop			 float,
  fat_aratop			 float,
  fat_geneltop			 float,
  giren					 float,
  cikan					 float,
  fat_olustarsaat        datetime,
  plaka                  varchar(50)
  )
AS
BEGIN

/*
  16777216	        318767104
  49	65536	      3211264
  28	256	             7168
  */

  if @Firmano=0
  insert into @TB_LOGO_FATURA
  (Firmano,
  fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,car_kod,car_muhonkod,car_muhkod,
  car_unvan,
  belgeno,fat_gider,
  fat_aratop,
  fat_iskonto,fat_isk_yuz,fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat,plaka)

  select m.firmano,m.fatid,m.fatrap_id,
  m.fattip,
  hrk_tip='fat',
  hrk_tipno=case
     when (m.gctip=2) and (m.fattip='FATVERSAT')  then 7
     when (m.gctip=2) and (m.fattip<>'FATVERSAT') then 8
     when m.gctip=1 then 1
     when m.fattip='FATIADALS' then  8
     when m.fattip='FATIADSAT' then  1 end, /*0 borc ,1 alacak */
     case
     when m.gctip=2 then  'SATIŞ FATURASI'
     when m.gctip=1 then   'ALIŞ FATURASI'
     when m.fattip='FATIADALS' then  'ALIŞDAN İADE FATURASI'
     when m.fattip='FATIADSAT' then  'SATIŞDAN İADE FATURASI' end,
     m.ack,   
    m.tarih,m.saat,
    m.carkod,car.muhonkod,car.muhkod,
    car.ad,
  fat_serino=m.fatseri+cast(m.fatno as varchar), /* Varchar(15) */
  fat_gider=m.gidertop,
  fat_aratop=m.genel_ara_top,
  fat_iskonto=(m.genel_isk_top),
  fat_isk_yuz=(m.genel_isk_top*100)/m.fattop,
  fat_kdvtop=m.genel_kdv_top,/*kdv genel tutar */
  fat_geneltop=m.genel_top,
  fat_olustarsaat=m.olustarsaat,
  '' plaka
  from faturamas as m 
  left join Genel_Kart as car on car.cartp=m.cartip 
  and car.kod=m.carkod   
  Where sil=0
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.FatRap_id in (select * from CsvToSTR(@fatRapin) )
  order by m.fatid
  
  if @Firmano>0
   insert into @TB_LOGO_FATURA
  (Firmano,
  fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,car_kod,car_muhonkod,car_muhkod,
  car_unvan,
  belgeno,fat_gider,
  fat_aratop,
  fat_iskonto,fat_isk_yuz,fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat,
  plaka)
  select m.firmano,m.fatid,m.fatrap_id,
  m.fattip,
  hrk_tip='fat',
  hrk_tipno=case
     when (m.gctip=2) and (m.fattip='FATVERSAT')  then 7
     when (m.gctip=2) and (m.fattip<>'FATVERSAT') then 8
     when m.gctip=1 then 1
     when m.fattip='FATIADALS' then  8
     when m.fattip='FATIADSAT' then  1 end, /*0 borc ,1 alacak */
     case
     when m.gctip=2 then  'SATIŞ FATURASI'
     when m.gctip=1 then   'ALIŞ FATURASI'
     when m.fattip='FATIADALS' then  'ALIŞDAN İADE FATURASI'
     when m.fattip='FATIADSAT' then  'SATIŞDAN İADE FATURASI' end,
     m.ack,   
    m.tarih,m.saat,
    m.carkod,car.muhonkod,car.muhkod,
    car.ad,
  fat_serino=m.fatseri+cast(m.fatno as varchar), /* Varchar(15) */
  fat_gider=m.gidertop,
  fat_aratop=m.genel_ara_top,
  fat_iskonto=(m.genel_isk_top),
  fat_isk_yuz=(m.genel_isk_top*100)/m.fattop,
  fat_kdvtop=m.genel_kdv_top,/*kdv genel tutar */
  fat_geneltop=m.genel_top,
  fat_olustarsaat=m.olustarsaat,
  '' plaka
  from faturamas as m 
  left join Genel_Kart as car on car.cartp=m.cartip 
  and car.kod=m.carkod   
  Where sil=0 and m.firmano in (0,@Firmano)
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.FatRap_id in (select * from CsvToSTR(@fatRapin) )
  order by m.fatid
  

  
  update @TB_LOGO_FATURA set
  /*fat_aratop=fat_aratop,--fat_geneltop-fat_kdvtop,  */
  giren=case when hrk_tipno=1 then 
  fat_geneltop else 0 end,
  cikan=case 
  when (hrk_tipno=7) or (hrk_tipno=8) then 
  fat_geneltop else 0 end

  
  
  
 /*-irsaliye  */
 if @Firmano=0 
  insert into @TB_LOGO_FATURA
  (Firmano,fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,fat_gider,
  fat_aratop,
  fat_iskonto,fat_isk_yuz,fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat,plaka)
  select m.firmano,m.verid,m.fisrap_id,
  m.fistip,
  hrk_tip='fis',
  hrk_tipno=case
     when (m.fistip='FISVERSAT')  then 7
     when (m.fistip='FISALCSAT') then 1 end,
     /*0 borc ,1 alacak */
    case
     when m.fistip='FISVERSAT' then  'VERESİYE FİŞİ'
     when m.fistip='FISALCSAT' then  'ALACAK FİŞİ' end,
     m.ack,   
    m.tarih,m.saat,
    m.carkod,car.muhonkod,car.muhkod,
    car.ad,
  fat_serino=m.seri+cast(m.no as varchar), /* Varchar(15) */
  fat_gider=0,
  fat_aratop=( select sum(((h.brmfiy*h.mik)/(1+h.kdvyuz))) from veresihrk as h
   where verid=m.verid and h.sil=0),
  fat_iskonto=
  ( select sum( ( (h.brmfiy*h.mik)/(1+h.kdvyuz))*h.iskyuz) from veresihrk as h
   where verid=m.verid and h.sil=0),
  fat_isk_yuz=0,/*(m.genel_isk_top*100)/m.fattop, */
  fat_kdvtop=( select 
   sum( ( ((h.brmfiy/(1+h.kdvyuz))*(1-h.iskyuz))*(h.kdvyuz) ) *h.mik )
  from veresihrk as h
   where verid=m.verid and h.sil=0),/*kdv genel tutar */
  fat_geneltop=m.toptut-m.isktop,
  fat_olustarsaat=m.olustarsaat,
  plaka=m.plaka
  from veresimas as m 
  left join Genel_Kart as car on car.cartp=m.cartip 
  and car.kod=m.carkod   
  Where sil=0
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.fisRap_id in (select * from CsvToSTR(@fatRapin) )
  order by m.fatid
   
  
  if @Firmano>0 
  insert into @TB_LOGO_FATURA
  (Firmano,fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,fat_gider,
  fat_aratop,
  fat_iskonto,fat_isk_yuz,fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat,plaka)
  select m.firmano,m.verid,m.fisrap_id,
  m.fistip,
  hrk_tip='fis',
  hrk_tipno=case
     when (m.fistip='FISVERSAT')  then 7
     when (m.fistip='FISALCSAT') then 1 end,
     /*0 borc ,1 alacak */
    case
     when m.fistip='FISVERSAT' then  'VERESİYE FİŞİ'
     when m.fistip='FISALCSAT' then  'ALACAK FİŞİ' end,
     m.ack,   
    m.tarih,m.saat,
    m.carkod,car.muhonkod,car.muhkod,
    car.ad,
  fat_serino=m.seri+cast(m.no as varchar), /* Varchar(15) */
  fat_gider=0,
  fat_aratop=( select sum(((h.brmfiy*h.mik)/(1+h.kdvyuz))) from veresihrk as h
   where verid=m.verid and h.sil=0),
  fat_iskonto=
  ( select sum( ( (h.brmfiy*h.mik)/(1+h.kdvyuz))*h.iskyuz) from veresihrk as h
   where verid=m.verid and h.sil=0),
  fat_isk_yuz=0,/*(m.genel_isk_top*100)/m.fattop, */
  fat_kdvtop=( select 
   sum( ( ((h.brmfiy/(1+h.kdvyuz))*(1-h.iskyuz))*(h.kdvyuz) ) *h.mik ) 
  from veresihrk as h
   where verid=m.verid and h.sil=0),/*kdv genel tutar */
  fat_geneltop=m.toptut-m.isktop,
  fat_olustarsaat=m.olustarsaat,
  m.plaka
  from veresimas as m 
  left join Genel_Kart as car on car.cartp=m.cartip 
  and car.kod=m.carkod   
  Where sil=0 and m.firmano in (0,@Firmano)
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.fisRap_id in (select * from CsvToSTR(@fatRapin) )
  order by m.fatid
  
  
  
  
  update @TB_LOGO_FATURA set 
  fat_geneltop=(fat_aratop-fat_iskonto+fat_kdvtop)
  where Petro_Evrak_Tip='FISVERSAT' 
  
  update @TB_LOGO_FATURA set 
  fat_isk_yuz=(fat_iskonto*100)/fat_aratop
  where Petro_Evrak_Tip='FISVERSAT' 
  
  
 
  
  
  
  
  /*- pomvardiya fatura */
  
  if (select COUNT(*) from CsvToSTR(@fatRapin) where STRValue=0)>0
    begin
   
      if @Firmano=0 
      insert into @TB_LOGO_FATURA
      (Firmano,
      fat_id,FatRap_id,Petro_Evrak_Tip,
      hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
      tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
      belgeno,fat_gider,
      fat_aratop,
      fat_iskonto,fat_isk_yuz,fat_kdvtop,
      fat_geneltop,
      fat_olustarsaat,
      plaka)
      
      select m.FIRMANO,m.varno,0,
      fistip='pomvardimas',
      hrk_tip='var',
      hrk_tipno=8,
        'POMPACI VARDIYA',
         m.ack,   
         m.TARIH,m.SAAT,
         car.kod,car.muhonkod,car.muhkod,
         car.ad,
       fat_serino='PA'+cast(m.SERINO as varchar)+'.'+cast(dbo.sifirat(m.varno,5) as varchar) ,  /* Varchar(15) */
       fat_gider=0,
       fat_aratop=SUM(STOK_TUTARKDVSIZ),
       fat_iskonto=0,
       fat_isk_yuz=0,
       fat_kdvtop=SUM(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ),/*kdv genel tutar */
      fat_geneltop=SUM(STOK_TUTARKDVLI),
      fat_olustarsaat=MAX(m.olustarsaat),
      '' plaka
      
      from UDF_PomVarNakitStokhrk (0,'pomvardimas',@Bastar,@Bittar)  as m 
      left join Genel_Kart as car on car.cartp='carikart' 
      and car.kod=m.CARKOD 
      group by m.FIRMANO,m.varno,m.SERINO,m.TARIH,m.SAAT,m.CARKOD,m.ACK,
      car.kod,car.muhonkod,car.muhkod,car.ad
      
      
      if @Firmano>0 
      insert into @TB_LOGO_FATURA
      (Firmano,
      fat_id,FatRap_id,Petro_Evrak_Tip,
      hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
      tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
      belgeno,fat_gider,
      fat_aratop,
      fat_iskonto,fat_isk_yuz,fat_kdvtop,
      fat_geneltop,
      fat_olustarsaat,plaka)
      
      select m.FIRMANO,m.varno,0,
      fistip='pomvardimas',
      hrk_tip='var',
      hrk_tipno=8,
      'POMPACI VARDIYA',
      m.ack,   
      m.TARIH,m.SAAT,
      car.kod,car.muhonkod,car.muhkod,
      car.ad,
       fat_serino='PA'+cast(m.SERINO as varchar)+'.'+cast(dbo.sifirat(m.varno,5) as varchar) ,  /* Varchar(15) */
       fat_gider=0,
       fat_aratop=SUM(STOK_TUTARKDVSIZ),
       fat_iskonto=0,
       fat_isk_yuz=0,
       fat_kdvtop=SUM(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ),/*kdv genel tutar */
      fat_geneltop=SUM(STOK_TUTARKDVLI),
      fat_olustarsaat=MAX(m.olustarsaat),
       '' plaka
      from UDF_PomVarNakitStokhrk (@Firmano,'pomvardimas',@Bastar,@Bittar)  as m 
      left join Genel_Kart as car on car.cartp='carikart' 
      and car.kod=m.CARKOD 
      group by m.FIRMANO,m.varno,m.SERINO,m.TARIH,m.SAAT,m.CARKOD,m.ACK,
      car.kod,car.muhonkod,car.muhkod,car.ad
      
      
       
   end 
   
     
  
  update @TB_LOGO_FATURA set
  /*fat_aratop=fat_aratop,--fat_geneltop-fat_kdvtop,  */
  giren=case when hrk_tipno=1 then 
  fat_geneltop else 0 end,
  cikan=case 
  when (hrk_tipno=7) or (hrk_tipno=8) then 
  fat_geneltop else 0 end  
  
  

  



  

 return


END

================================================================================
