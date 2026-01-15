-- Function: dbo.Udf_EFatura_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.712376
================================================================================

CREATE FUNCTION [dbo].[Udf_EFatura_Mas]
(@Firmano   int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  fat_id                 int,
  FatRap_id				 int,
  Petro_Evrak_Tip        varchar(30),
  hrk_tipno				 int,
  hrk_tipad				 varchar(50),
  hrk_ack				 varchar(200),
  tarih                  datetime,
  saat                   varchar(10),
  vadetarih              datetime,
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
  Irsaliye_No			 varchar(100),
  Aciklama				 varchar(200),
  fat_gider              float,
  fat_aratop			 float,
  fat_iskonto			 float,
  fat_isk_yuz            float,
  fat_iskontotop		 float,
  fat_yuvtop			 float,		
  fat_kdvtop			 float,
  fat_kdvtevkifattop	 float,
  fat_geneltop			 float,
  fat_olustarsaat        datetime,
  Efatura                bit,
  EFatura_Tip			 int,
  Efatura_Id			 varchar(100),
  EFaturaTipAd				 varchar(30),
  EBelgeTipAd				 varchar(30),
  EBelgeOId			        varchar(30),
  EBelgeGibSeriNo           varchar(30),
  EBelgeMailTarihSaat       Datetime,
  IadeFatNo1                 varchar(30),
  IadeFatTarih1              datetime,
  IadeFatNo2                 varchar(30),
  IadeFatTarih2              datetime,
  IadeFatNo3                 varchar(30),
  IadeFatTarih3              datetime,
  IadeFatNo4                 varchar(30),
  IadeFatTarih4              datetime,
  IadeFatNo5                 varchar(30),
  IadeFatTarih5              datetime
  )
AS
BEGIN





  insert into @TB_LOGO_FATURA
  (fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,vadetarih,
  EfaturaTip,EFaturaTipAd,
  EBelgeTipId,EBelgeTipAd,
  EBelgeEntegrasyonId,
  car_kod,car_VergiKNo,
  Car_VergiDairesi,Car_AdresPostaKod,Car_TicSicilNo,
  Car_Ad,Car_Soyad,car_unvan,
  Car_Il,Car_Ilce,Car_Adres,Car_VergiPosta,
  Car_Tel,Car_Fax,Car_Mail,Car_WebAdres,
  belgeno,Irsaliye_No,Aciklama,
  fat_gider,
  fat_aratop,
  fat_iskonto,
  fat_isk_yuz,
  fat_iskontotop,
  fat_yuvtop,
  fat_kdvtop,
  fat_kdvtevkifattop,
  fat_geneltop,
  fat_olustarsaat,
  Efatura,EFatura_Tip,EFatura_Id,EBelgeOId,
  EBelgeGibSeriNo,EBelgeMailTarihSaat)

   select m.fatid,m.fatrap_id,
  m.fattip,
  hrk_tipno=case
     when m.gctip=2 and m.fattip not in ('FATIADALS','FATIADSAT','FATTEVSAT') then 2  /* SATIS */
     when m.gctip=1 and m.fattip not in ('FATIADALS','FATIADSAT','FATTEVSAT') then 1  /* ALIS */
     when m.fattip='FATTEVSAT' then  4  /*TEVKIFAT */
     when m.fattip='FATIADALS' then  3  /*IADE */
     when m.fattip='FATIADSAT' then  1 end, 
     case
     when m.gctip=2 and m.fattip not in ('FATIADALS','FATIADSAT','FATTEVSAT') then  'SATIS FATURASI'
     when m.gctip=1 and m.fattip not in ('FATIADALS','FATIADSAT','FATTEVSAT') then   'ALIS FATURASI'
     when m.fattip='FATIADALS' then  'ALISDAN IADE FATURASI'
     when m.fattip='FATIADSAT' then  'SATISDAN IADE FATURASI' 
     when m.fattip='FATTEVSAT' then  'TEVKIFAT FATURASI'     
     end,
     m.ack,  
    m.tarih,m.saat,m.vadtar,
    car.EFaturaTip,
    case 
    When isnull(car.EFaturaTip,0)=0 then 'YOK' 
    When isnull(car.EFaturaTip,0)=1 then 'TICARI'
    When isnull(car.EFaturaTip,0)=2 then 'TEMEL' end,
    isnull(m.EBelgeTipId,0),
    case 
    When isnull(m.EBelgeTipId,0)=0 then 'YOK' 
    When isnull(m.EBelgeTipId,0)=1 then 'E-FATURA'
    When isnull(m.EBelgeTipId,0)=2 then 'E-ARSIV' end, 
    case when isnull(m.EFatura_Tip,0)>0 then isnull(m.EFatura_Tip,0)
    else isnull(EBelgeEntegrasyonId,0) end,
  
    m.carkod,case when isnull(car.VergiKNo,0)='' then car.tcno else car.VergiKNo end,
    car.vergidaire,car.AdresPostaKod,car.TicSicilNo,
    Car.Ad,Car.Soyad,
    case when Rtrim(Car.fatunvan)<>'' then Car.fatunvan else 
    car.Unvan end ,car.evil,car.evilce,
    car.adres+' '+car.adres2,car.vergiEposta,
    car.tel,car.fax,car.mail,car.webadres,
    fat_serino=m.fatseri+cast(m.fatno as varchar), /* Varchar(30) */
    m.irs_no,m.ack,
    fat_gider=m.gidertop,
    fat_aratop=m.genel_ara_top+m.gidertop,
    fat_iskonto=(m.genel_isk_top),
    fat_yuvtop=isnull(m.yuvtop,0),
    fat_isk_yuz= case when m.fattop=0 then 0 else (m.genel_isk_top*100)/ m.fattop end,
    fat_iskontotop=m.genel_ara_top+m.gidertop-m.genel_isk_top,    
    fat_kdvtop=m.genel_kdv_top,/*kdv genel tutar */
    fat_kdvtevkifattop=m.genel_kdv_tevkifat_top,
    fat_geneltop=m.genel_top,
    fat_olustarsaat=m.olustarsaat,
    isnull(m.Efatura,0),ISNULL(m.EFatura_Tip,0),
    m.EFatura_Id,EFaturaEFinansBelgeOId,
    m.EBelgeGibSeriNo,m.EBelgeMailTarihSaat
    from faturamas as m with (nolock)
    left join Genel_Cari_Kart as car with (nolock) on car.cartip=m.cartip 
    and car.kod=m.carkod   
    Where m.sil=0 and m.Firmano=@Firmano 
    and isnull(m.EBelgeTipId,0)>0 and m.gctip=2 /* Sadece Satis  */
    /*and car.Efatura=1 */
    and m.tarih>=@bastar and m.tarih <=@bittar
    and m.FatRap_id in (select * from CsvToSTR(@fatRapin) )
    order by m.fatid
  
   
  /*Iade icin BelgeNo ve Tarih */
   update @TB_LOGO_FATURA set 
   IadeFatNo1=dt.BelgeNo1,
   IadeFatTarih1=dt.Tarih1,
   IadeFatNo2=dt.BelgeNo2,
   IadeFatTarih2=dt.Tarih2,
   IadeFatNo3=dt.BelgeNo3,
   IadeFatTarih3=dt.Tarih3,
   IadeFatNo4=dt.BelgeNo4,
   IadeFatTarih4=dt.Tarih4,
   IadeFatNo5=dt.BelgeNo5,
   IadeFatTarih5=dt.Tarih5
   
   from @TB_LOGO_FATURA as t join (
   select FatId,
       max(case when seqnum = 1 then BelgeNo end) as BelgeNo1,
       max(case when seqnum = 1 then Tarih end) as Tarih1,
       max(case when seqnum = 2 then BelgeNo end) as BelgeNo2,
       max(case when seqnum = 2 then Tarih end) as Tarih2,
       max(case when seqnum = 3 then BelgeNo end) as BelgeNo3,
       max(case when seqnum = 3 then Tarih end) as Tarih3,
       max(case when seqnum = 4 then BelgeNo end) as BelgeNo4,
       max(case when seqnum = 4 then Tarih end) as Tarih4,
       max(case when seqnum = 5 then BelgeNo end) as BelgeNo5,
       max(case when seqnum = 5 then Tarih end) as Tarih5
    from (select t.*,
             row_number() over (partition by FatId order by FatId) as seqnum
      from FaturaIadeDetay as t where Sil=0
      and FatId in (Select fat_id from @TB_LOGO_FATURA)
     ) t group by FatId ) dt on dt.FatId=t.fat_id
  
     

 return


END

================================================================================
