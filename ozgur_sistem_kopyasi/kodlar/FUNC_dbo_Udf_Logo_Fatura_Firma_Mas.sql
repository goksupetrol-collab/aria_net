-- Function: dbo.Udf_Logo_Fatura_Firma_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.738174
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Fatura_Firma_Mas]
(@Firmano int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  fat_id                 int,
  FatRap_id				 int,
  Petro_Evrak_Tip        varchar(30),
  hrk_tipno				 int,
  hrk_tip				 varchar(5),
  hrk_tipad				 varchar(50),
  hrk_ack				 varchar(200),
  tarih                  datetime,
  saat                   varchar(10),
  car_kod				 varchar(30),
  car_muhonkod			 varchar(30),
  car_muhkod			 varchar(30),
  car_unvan				 varchar(150),
  belgeno			     Varchar(20),
  fat_gider              float,
  fat_iskonto			 float,
  fat_isk_yuz            float,					
  fat_kdvtop			 float,
  fat_aratop			 float,
  fat_geneltop			 float,
  giren					 float,
  cikan					 float,
  fat_olustarsaat        datetime
  )
AS
BEGIN

/*
  16777216	        318767104
  49	65536	      3211264
  28	256	             7168
  */


   



  insert into @TB_LOGO_FATURA
  (fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,fat_gider,
  fat_aratop,
  fat_iskonto,fat_isk_yuz,fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat)

  select m.fatid,m.fatrap_id,
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
     when m.gctip=1 then  'ALIŞ FATURASI'
     when m.fattip='FATIADALS' then  'ALIŞDAN YADE FATURASI'
     when m.fattip='FATIADSAT' then  'SATIŞDAN YADE FATURASI' end,
     
   
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
  fat_olustarsaat=m.olustarsaat
  from faturamas as m 
  left join Genel_Kart as car on car.cartp=m.cartip 
  and car.kod=m.carkod   
  Where sil=0 and m.firmano=@firmano and isnull(m.Entegre,0)=0 
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.FatTip_id in (select * from CsvToSTR(@fatRapin) )
  order by m.fatid
  
  update @TB_LOGO_FATURA set
  /*fat_aratop=fat_aratop,--fat_geneltop-fat_kdvtop,  */
  giren=case when hrk_tipno=1 then 
  fat_geneltop else 0 end,
  cikan=case 
  when (hrk_tipno=7) or (hrk_tipno=8) then 
  fat_geneltop else 0 end

  
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
