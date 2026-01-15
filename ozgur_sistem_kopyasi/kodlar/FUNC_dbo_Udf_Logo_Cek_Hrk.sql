-- Function: dbo.Udf_Logo_Cek_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.737276
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Cek_Hrk]
(@Firmano   int,
@Islidin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_CEK TABLE (
  id					 int,
  firmano                int,
  islmhrk_id             int,
  hrk_id                 int,
  Aktar					 int,	
  Petro_Evrak_Tip        varchar(30),
  hrk_ba				 varchar(5),	
  hrk_tipno				 int,
  hrk_tip				 varchar(30),
  hrk_tipad				 varchar(50),
  hrk_ack				 varchar(200),
  tarih                  datetime,
  saat                   varchar(10),
  vadetarih              datetime,
  car_tip				 varchar(20),  
  car_kod				varchar(30),
  car_muhonkod			 varchar(30),
  car_muhkod			varchar(30),
  car_unvan			    varchar(150),
  vcar_tip				 varchar(20),
  vcar_kod				 varchar(30),
  vcar_muhonkod			 varchar(30),
  vcar_muhkod			 varchar(30),
  vcar_unvan			 varchar(150),
  Banka_kod				 varchar(30),
  Banka_muhonkod		 varchar(30),
  Banka_Unvan		     varchar(150),
  belgeno			     Varchar(20),
  gider_tut              float,
  geneltop			     float,
  giren					 float,
  cikan					 float,
  olustarsaat            datetime
  )
AS
BEGIN




 if @Firmano=0 
  insert into @TB_LOGO_CEK
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,vadetarih,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  vcar_tip,vcar_kod,vcar_muhonkod,vcar_muhkod,vcar_unvan,
  banka_kod,Banka_muhonkod,Banka_Unvan,
  belgeno,gider_tut,geneltop,olustarsaat)

   select m.id,m.firmano,isl.id,m.cekid,
  case 
  /*when (m.islmtip+'_'+m.drm='CEK_POR') then 1 */
  /*when (m.islmtip+'_'+m.drm='CEK_KSN') then 1  else 0 end, */
  when (m.islmhrk='ALN') then 1
  when (m.islmhrk='KSN') then 1  else 0 end,
  'cek',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
    /* when (m.islmtip+'_'+m.drm='CEK_POR') then 1 */
    /* when (m.islmtip+'_'+m.drm='CEK_KSN') then 3 */
     /* else 1 end, */
     when (m.islmhrk='ALN') then 1
     when (m.islmhrk='KSN') then 3  else 1 end,  
    case
    /* when (m.islmtip+'_'+m.drm='CEK_POR') then 'CPOR' */
    /* when (m.islmtip+'_'+m.drm='CEK_KSN') then 'CKSN' */
    
     when (m.islmhrk='ALN') then 'CPOR'
     when (m.islmhrk='KSN') then 'CKSN'
    end,
    m.ack,   
    m.tarih,m.saat,m.vadetar,
    m.cartip,m.carkod,car.muhonkod,car.muhkod,car.ad,
    m.vercartip,m.vercarkod,vcar.muhonkod,vcar.muhkod,vcar.ad,
    m.bankod,b.muhonkod,b.ad,
   belgeno=m.ceksenno, /* Varchar(15) */
   gider_tut=0,
   geneltop=abs(m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from cekkart as m 
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
   left join Genel_Kart as car on car.cartp=m.cartip
   and car.kod=m.carkod 
   left join Genel_Kart as vcar on vcar.cartp=m.vercartip
   and vcar.kod=m.vercarkod 
   left join Genel_Kart as b on b.cartp='bankakart'
   and b.kod=m.bankod
   Where sil=0 and m.varno=0
   and m.tarih>=@bastar and m.tarih <=@bittar
  /* and m.drm in ('POR','KSN') */
  /*  and isnull(m.Entegre,0)=0  */
   order by m.id
  

  if @Firmano>0 
  insert into @TB_LOGO_CEK
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,vadetarih,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  vcar_tip,vcar_kod,vcar_muhonkod,vcar_muhkod,vcar_unvan,
  banka_kod,Banka_muhonkod,Banka_Unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.cekid,
  case 
  /*when (m.islmtip+'_'+m.drm='CEK_POR') then 1 */
  /*when (m.islmtip+'_'+m.drm='CEK_KSN') then 1  else 0 end, */
  when (m.islmhrk='ALN') then 1
  when (m.islmhrk='KSN') then 1  else 0 end,
  'cek',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
    /* when (m.islmtip+'_'+m.drm='CEK_POR') then 1 */
    /* when (m.islmtip+'_'+m.drm='CEK_KSN') then 3 */
     /* else 1 end, */
     when (m.islmhrk='ALN') then 1
     when (m.islmhrk='KSN') then 3  else 1 end,  
    case
    /* when (m.islmtip+'_'+m.drm='CEK_POR') then 'CPOR' */
    /* when (m.islmtip+'_'+m.drm='CEK_KSN') then 'CKSN' */
    
     when (m.islmhrk='ALN') then 'CPOR'
     when (m.islmhrk='KSN') then 'CKSN'
    end,
    m.ack,   
    m.tarih,m.saat,m.vadetar,
    m.cartip,m.carkod,car.muhonkod,car.muhkod,car.ad,
    m.vercartip,m.vercarkod,vcar.muhonkod,vcar.muhkod,vcar.ad,
    m.bankod,b.muhonkod,b.ad,
   belgeno=m.ceksenno, /* Varchar(15) */
   gider_tut=0,
   geneltop=abs( m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from cekkart as m 
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
   left join Genel_Kart as car on car.cartp=m.cartip
   and car.kod=m.carkod 
   left join Genel_Kart as vcar on vcar.cartp=m.vercartip
   and vcar.kod=m.vercarkod 
   left join Genel_Kart as b on b.cartp='bankakart'
   and b.kod=m.bankod 
   
   Where sil=0 and m.varno=0 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
  /* and m.drm in ('POR','KSN') */
   
   
   /* and isnull(m.Entegre,0)=0  */
   order by m.id


  
   if @Islidin<>''
    delete from @TB_LOGO_CEK Where islmhrk_id not in (select * from CsvToInt(@Islidin) )
  
  
   update @TB_LOGO_CEK set
    car_unvan=vcar_unvan 
    where hrk_tipno=3 
   
  
   update @TB_LOGO_CEK set
   giren=case when hrk_BA='A' then 
   geneltop else 0 end,
   cikan=case when hrk_BA='B' then 
   geneltop else 0 end
   
   
  


 return


END

================================================================================
