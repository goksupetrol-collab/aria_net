-- Function: dbo.Udf_EIrsaliye_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.713235
================================================================================

CREATE FUNCTION [dbo].[Udf_EIrsaliye_Mas]
(@Firmano   int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  ir_id                 int,
  irRap_id				 int,
  hrk_tipno				 int,
  hrk_tipad				 varchar(50),
  tarih                  datetime,
  saat                   varchar(10),
  SevkTarih              datetime,
  SevkSaat               varchar(10),
  EFaturaTip			 int,
  EBelgeTipId  			 int,
  EBelgeEntegrasyonId    int,
  Car_Kod				 varchar(30),
  Car_VergiKNo			 varchar(30),
  Car_VergiDairesi	     varchar(150),
  Car_TicSicilNo         varchar(50),
  Car_Ad				 varchar(150),
  Car_Soyad				 varchar(150),
  Car_unvan				 varchar(150),  
  Car_Il                 varchar(50),
  Car_Ilce               varchar(100),
  Car_Adres				 varchar(150),
  Car_Vergiposta         varchar(100),
  Car_Tel                varchar(50),
  Car_Fax                varchar(50),
  Car_Mail               varchar(100),
  Car_WebAdres           varchar(100),
  Car_AdresPostaKod      Varchar(30),
  Belgeno			     Varchar(30),
  Aciklama				 varchar(200),
  TasiyiciId             int,
  TasiyiciUnvan          varchar(200),
  TasiyiciAd			 varchar(100),
  TasiyiciSoyAd			 varchar(100),
  TasiyiciVergiKNo       varchar(20),
  TasiyiciIl             varchar(50),
  TasiyiciIlce           varchar(100),
  TasiyiciAdres 		 varchar(150),
  TasiyiciAdresPostaKod	 varchar(50),
  
  TeslimYerId             int,
  TeslimYerIl             varchar(50),
  TeslimYerIlce           varchar(100),
  TeslimYerAdres 		 varchar(150),
  TeslimYerAdresPostaKod	 varchar(50),
  
  
  Plaka                  Varchar(50),
  SoforId                int,
  SoforAd                 Varchar(50),
  SoforSoyAd             Varchar(50),
  SoforTCKN              Varchar(20),
  fat_aratop			 float,
  fat_iskonto			 float,
  fat_isk_yuz            float,
  fat_iskontotop		 float,					
  fat_kdvtop			 float,
  fat_geneltop			 float,
  fat_olustarsaat        datetime,
  EBelgeEntegrasyon      bit,
  EFatura_Tip			 int,
  Efatura_Id			 varchar(100),
  EFaturaTipAd				 varchar(30),
  EBelgeTipAd				 varchar(30),
  EBelgeGibSeriNo           varchar(30),
  EBelgeMailTarihSaat       Datetime
  
  )
AS
BEGIN







  insert into @TB_LOGO_FATURA
  (ir_id,irRap_id,
  hrk_tipno,hrk_tipad,
  tarih,saat,SevkTarih,SevkSaat,
  EfaturaTip,EFaturaTipAd,
  EBelgeTipId,EBelgeTipAd,
  EBelgeEntegrasyonId,
  car_kod,car_VergiKNo,
  Car_VergiDairesi,Car_AdresPostaKod,Car_TicSicilNo,
  Car_Ad,Car_Soyad,car_unvan,
  Car_Il,Car_Ilce,Car_Adres,Car_VergiPosta,
  Car_Tel,Car_Fax,Car_Mail,Car_WebAdres,
  belgeno,Aciklama,
  Plaka,TasiyiciId,SoforId,
  TeslimYerId,TeslimYerIl,
  TeslimYerIlce,TeslimYerAdres,
  TeslimYerAdresPostaKod,
  fat_aratop,
  fat_iskonto,
  fat_isk_yuz,
  fat_iskontotop,
  fat_kdvtop,
  fat_geneltop,
  fat_olustarsaat,
  EBelgeEntegrasyon,EFatura_Tip,EFatura_Id,
  EBelgeGibSeriNo,EBelgeMailTarihSaat)

   select m.irid,m.irsrap_id,
   m.gctip,
   case
    when m.gctip=2  then  'SATIS IRSALIYESI'
    when m.gctip=1  then   'ALIS IRSALIYESI' end,
    m.tarih,m.saat,m.sevktar,isnull(SevkSaat,'00:00:00'),
    car.EFaturaTip,
    case 
    When isnull(car.EFaturaTip,0)=0 then 'YOK' 
    When isnull(car.EFaturaTip,0)=1 then 'TICARI'
    When isnull(car.EFaturaTip,0)=2 then 'TEMEL' end,
    isnull(m.EBelgeTipId,0),
    case 
    When isnull(m.EBelgeTipId,0)=0 then 'YOK' 
    When isnull(m.EBelgeTipId,0)=3 then 'E-IRSALIYE' end,
    isnull(m.EBelgeEntegrasyonId,0),
  
    m.carkod,case when isnull(car.VergiKNo,0)='' then car.tcno else car.VergiKNo end,
    car.vergidaire,car.AdresPostaKod,car.TicSicilNo,
    Car.Ad,Car.Soyad,
    case when Rtrim(Car.fatunvan)<>'' then Car.fatunvan else 
    car.Unvan end ,car.evil,car.evilce,
    car.adres+' '+car.adres2,car.vergiEposta,
    car.tel,car.fax,car.mail,car.webadres,
    fat_serino=m.irseri+cast(m.irno as varchar), /* Varchar(30) */
    m.ack,
    m.Plaka,m.EBelgeTasiyiciFirmaId,m.EBelgeSoforId,
    isnull(m.EBelgeTeslimYerId,0),car.evil,car.evilce,
    car.adres+' '+car.adres2,car.AdresPostaKod,   
    fat_aratop=m.genel_top-m.genel_kdv_top,
    fat_iskonto=0,
    fat_isk_yuz= 0,
    fat_iskontotop=0,    
    fat_kdvtop=m.genel_kdv_top,/*kdv genel tutar */
    fat_geneltop=m.genel_top,
    fat_olustarsaat=m.olustarsaat,
    isnull(m.EBelgeEntegrasyon,0),
    ISNULL(m.EBelgeTipId,0),
    m.EBelgeId,
    m.EBelgeGibSeriNo,m.EBelgeMailTarihSaat
    from irsaliyemas as m with (nolock)
    left join Genel_Cari_Kart as car with (nolock) on car.cartip=m.cartip 
    and car.kod=m.carkod   
    Where m.sil=0 and m.Firmano=@Firmano 
    and isnull(m.EBelgeTipId,0)>0 and m.gctip=2 /* Sadece Satis  */
    /*and car.Efatura=1 */
    and m.tarih>=@bastar and m.tarih <=@bittar
    and m.irsrap_id in (select * from CsvToSTR(@fatRapin) )
    order by m.fatid
    
    
    
   update @TB_LOGO_FATURA set 
   TasiyiciUnvan=dt.Unvan,
   TasiyiciAd=dt.Ad,TasiyiciSoyAd=dt.SoyAd,
   TasiyiciVergiKNo=dt.VergiKimlikNo,
   TasiyiciIl=dt.AdresIl,TasiyiciIlce=dt.AdresIlce,
   TasiyiciAdres=dt.Adres,TasiyiciAdresPostaKod=dt.AdresPostaKod from @TB_LOGO_FATURA as t 
   join (Select id,Unvan,Ad,SoyAd,VergiKimlikNo,Adres,AdresIl,AdresIlce,AdresPostaKod
    From TasiyiciFirmaKart 
   as k with (nolock) Where Sil=0  ) dt on
   dt.id=t.TasiyiciId
   
   
   update @TB_LOGO_FATURA set 
   TeslimYerIl=dt.AdresIl,TeslimYerIlce=dt.AdresIlce,
   TeslimYerAdres=dt.Adres,TeslimYerAdresPostaKod=dt.AdresPostaKod from @TB_LOGO_FATURA as t 
   join (Select id,Adres,AdresIl,AdresIlce,AdresPostaKod
    From TeslimYerKart 
   as k with (nolock) Where Sil=0  ) dt on
   dt.id=t.TeslimYerId
  
  
   update @TB_LOGO_FATURA set 
   SoforAd=dt.Ad,SoforSoyAd=dt.SoyAd,
   SoforTCKN=dt.TcNo from @TB_LOGO_FATURA as t 
   join (Select id,Ad,SoyAd,TcNo From SoforKart 
   as k with (nolock) Where Sil=0  ) dt on
   dt.id=t.SoforId
  
   

 return


END

================================================================================
