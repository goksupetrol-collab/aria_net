-- Function: dbo.Udf_Logo_Banka_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.736855
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Banka_Hrk]
(@Firmano		int,
@Islidin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_BANKA TABLE (
  id					 int,
  hrk_id                 int,
  Aktar					 int,	
  Petro_Evrak_Tip        varchar(30),
  hrk_ba				 varchar(5) COLLATE Turkish_CI_AS,	
  hrk_tipno				 int,
  hrk_tip				 varchar(30) COLLATE Turkish_CI_AS,
  hrk_tipad				 varchar(50) COLLATE Turkish_CI_AS,
  hrk_ack				 varchar(200) COLLATE Turkish_CI_AS,
  tarih                  datetime,
  saat                   varchar(10) COLLATE Turkish_CI_AS,
  bnk_kod				varchar(30) COLLATE Turkish_CI_AS,
  bnk_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  bnk_muhkod			varchar(30) COLLATE Turkish_CI_AS,
  bnk_unvan			    varchar(150) COLLATE Turkish_CI_AS,
  car_tip				 varchar(20) COLLATE Turkish_CI_AS,
  car_kod				 varchar(30) COLLATE Turkish_CI_AS,
  car_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  car_muhkod			 varchar(30) COLLATE Turkish_CI_AS,
  car_unvan				 varchar(150) COLLATE Turkish_CI_AS,
  belgeno			     Varchar(20) COLLATE Turkish_CI_AS,
  gid_muhonkod			 Varchar(30) COLLATE Turkish_CI_AS,
  gid_muhkod             Varchar(30) COLLATE Turkish_CI_AS,
  gider_tut              float,
  geneltop			     float,
  giren					 float,
  cikan					 float,
  olustarsaat            datetime
  )
AS
BEGIN

/*
  16777216	        318767104
  49	65536	      3211264
  28	256	             7168
  */



/* BNK_B-C  GİDEN HAVALE / EFT */
/* BNK_C-B GELEN HAVALE / EFT */
/* VIR_VRG     VİRMAN GİRİŞ */
/* VIR_VRC     VİRMAN ÇIKIŞ */

  declare @Muh_PosCarMuhKod  varchar(50)
  declare @Muh_PosGidMuhKod  varchar(50)
  declare @Muh_PosCarOnKod  varchar(50)
  declare @Muh_PosGidOnKod  varchar(50)
  
  
  declare @Muh_BankGidOnKod  varchar(50)
  declare @Muh_BankGidMuhKod  varchar(50)
  
  
  /*select @Muh_PosCarKod=Muh_PosCarKod, */
   /* @Muh_PosGidKod=Muh_PosGidKod from sistemtanim */
  
  
   select @Muh_PosCarMuhKod=Entegre_PosCarMuhKod,
    @Muh_PosCarOnKod=Entegre_PosCarOnMuhKod,
    @Muh_PosGidMuhKod=Entegre_PosGidMuhKod,
    @Muh_PosGidOnKod=Entegre_PosGidOnMuhKod, 
    @Muh_BankGidOnKod=Entegre_BankGidOnMuhKod, 
    @Muh_BankGidMuhKod=Entegre_BankGidMuhKod 
    
    from Firma Where id=@Firmano
   

  if (select count(*) from CsvToInt(@Islidin) 
    where IntValue='28')>0
     set @Islidin=@Islidin+',29,30'

 if @Firmano=0
  insert into @TB_LOGO_BANKA
  (id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  gid_muhonkod,gid_muhkod,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.bankhrkid,
  case when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 0
  else 1 end,
  'bnk',
  hrk_ba=case when borc>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
     when (m.islmtip+'_'+m.islmhrk='BNK_C-B') then 3
     when (m.islmtip+'_'+m.islmhrk='BNK_B-C') then 4
     when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 2
     when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 2
     
     when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then 3
     when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then 4
     when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then 4
     else 1 end,
     case
     when (m.islmtip+'_'+m.islmhrk='BNK_C-B') then 'GELEN HAVALE / EFT'
     when (m.islmtip+'_'+m.islmhrk='BNK_B-C') then 'GİDEN HAVALE / EFT'
     when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 'VİRMAN ÇIKIŞ'
     when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 'VİRMAN GİRİŞ' 
     when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then 'POS AKTARIM'
     when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then 'POS KOMİSYON'
     when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then 'POS EK KOMİSYON'
     end,
    m.ack,   
    m.tarih,m.saat,
    m.bankod,car.muhonkod,car.muhkod,car.ad,
    case 
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then '-'  /*carikart */
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then '-' /*gelgidkart */
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then '-'
    else m.cartip end,
    case 
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidMuhKod
    else m.carkod end,
    case
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarOnKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidOnKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidOnKod
    else '' end,
    case
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidMuhKod
    else '' end,    
    '',
  belgeno=m.belno,
  @Muh_BankGidOnKod,@Muh_BankGidMuhKod, 
  gider_tut=isnull(gidtutar,0),
  geneltop=abs(m.borc-m.alacak),
  olustarsaat=m.olustarsaat
  from bankahrk as m 
  inner join islemhrktip as isl on
  (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
  left join Genel_Kart as car on 
  car.cartp='bankakart'
  and car.kod=m.bankod 
  Where sil=0
  and m.tarih>=@bastar and m.tarih <=@bittar
  and isl.id in (select * from CsvToInt(@Islidin) )
  order by m.id
  
  
  if @Firmano>0
  insert into @TB_LOGO_BANKA
  (id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,
  gid_muhonkod,gid_muhkod,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.bankhrkid,
  case when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 0
  else 1 end,
  'bnk',
  hrk_ba=case when borc>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
     when (m.islmtip+'_'+m.islmhrk='BNK_C-B') then 3
     when (m.islmtip+'_'+m.islmhrk='BNK_B-C') then 4
     when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 2
     when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 2
     
     when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then 3
     when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then 4
     when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then 4
     
     else 1 end,
     case
     when (m.islmtip+'_'+m.islmhrk='BNK_C-B') then 'GELEN HAVALE / EFT'
     when (m.islmtip+'_'+m.islmhrk='BNK_B-C') then 'GİDEN HAVALE / EFT'
     when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 'VİRMAN ÇIKIŞ'
     when (m.islmtip+'_'+m.islmhrk='VIR_VRG') then 'VİRMAN GİRİŞ' 
     when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then 'POS AKTARIM'
     when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then 'POS KOMİSYON'
     when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then 'POS EK KOMİSYON'
     end,
    m.ack,   
    m.tarih,m.saat,
    m.bankod,car.muhonkod,car.muhkod,car.ad,
    case 
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then '-'  /*carikart */
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then '-' /*gelgidkart */
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then '-'
    else m.cartip end,
    case 
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidMuhKod
    else m.carkod end,
    case
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarOnKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidOnKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidOnKod
    else '' end,
    case
    when (m.islmtip+'_'+m.islmhrk='BNK_SLO') then @Muh_PosCarMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_BKK') then @Muh_PosGidMuhKod
    when (m.islmtip+'_'+m.islmhrk='BNK_EKK') then @Muh_PosGidMuhKod
    else '' end,
    '',
    belgeno=m.belno, 
     @Muh_BankGidOnKod,@Muh_BankGidMuhKod,   
     gider_tut=isnull(gidtutar,0),
    geneltop=abs(m.borc-m.alacak),
    olustarsaat=m.olustarsaat
    from bankahrk as m 
    inner join islemhrktip as isl on
    (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
    left join Genel_Kart as car on 
    car.cartp='bankakart'
    and car.kod=m.bankod 
    Where sil=0 and m.firmano in (0,@Firmano)
    and m.tarih>=@bastar and m.tarih <=@bittar
    and isl.id in (select * from CsvToInt(@Islidin) )
    order by m.id
  
  
  
  
  
   update @TB_LOGO_BANKA set
   giren=case when hrk_BA='B' then 
   geneltop else 0 end,
   cikan=case when hrk_BA='A' then 
   geneltop else 0 end
   
   
   update @TB_LOGO_BANKA set
   car_muhonkod=car.muhonkod,
   car_muhkod=car.muhkod,
   car_unvan=car.ad
   from @TB_LOGO_BANKA as t
   inner join Genel_Kart as car on 
   car.cartp=t.car_tip and 
   car.kod=t.car_kod 
   

   

 return


END

================================================================================
