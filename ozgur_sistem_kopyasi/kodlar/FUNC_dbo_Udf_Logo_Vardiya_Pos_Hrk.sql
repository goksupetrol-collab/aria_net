-- Function: dbo.Udf_Logo_Vardiya_Pos_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.743954
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Pos_Hrk]
(@Firmano   int,
@Tip  int,
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_KASA TABLE (
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
  bnk_kod				varchar(30) COLLATE Turkish_CI_AS,
  bnk_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  bnk_muhkod			varchar(30) COLLATE Turkish_CI_AS,
  bnk_unvan			    varchar(150) COLLATE Turkish_CI_AS,
  car_tip				 varchar(20),
  car_kod				 varchar(30),
  car_muhonkod			 varchar(30),
  car_muhkod			 varchar(30),
  car_unvan				 varchar(150),
  belgeno			     Varchar(20),
  gider_tut              float,
  geneltop			     float,
  giren					 float,
  cikan					 float,
  olustarsaat            datetime
  )
AS
BEGIN

  declare @CAR_KOD varchar(30)
  if @firmano=0  
   SELECT @CAR_KOD=zrap_carkod FROM sistemtanim


 if @firmano>0  
  SELECT @CAR_KOD=Entegre_ZraporOnMuhKod FROM Firma where id=@firmano


 if @Firmano=0 and @Tip=1
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.varno,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'A' else 'B' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=3,
     case
     when (m.islmtip+'_'+m.islmhrk='TAH_POS') then 'TPOS'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.poskod,car.muhonkod,car.muhkod,car.ad,
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    belgeno='P'+cast(m.Firmano as varchar)+''+cast(m.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs(m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from poshrk as m with (nolock)
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk) and
   (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   left join Genel_Kart as car on car.cartp='poskart'
   and car.kod=m.poskod  
   Where sil=0 and m.varno>0 and m.varok=1
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0  and m.yertip='pomvardimas'
   order by m.id
   
   
  if @Firmano=0 and @Tip=2
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.varno,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'A' else 'B' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=3,
     case
     when (m.islmtip+'_'+m.islmhrk='TAH_POS') then 'TPOS'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.poskod,car.muhonkod,car.muhkod,car.ad,
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    belgeno='M'+cast(m.Firmano as varchar)+''+cast(m.varno as varchar), /* Varchar(15) */
    gider_tut=0,
    geneltop=abs(m.giren-m.cikan),
    olustarsaat=m.olustarsaat
    from poshrk as m with (nolock)
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk) and
   (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   left join Genel_Kart as car on car.cartp='poskart'   and car.kod=m.poskod
   Where sil=0 and m.varno>0 and m.varok=1
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='marvardimas'
   order by m.id
    
   
  

  if @Firmano>0 and @Tip=1
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.varno,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=3,
     case
     when (m.islmtip+'_'+m.islmhrk='TAH_POS') then 'TPOS'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.poskod,car.muhonkod,car.muhkod,car.ad,
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
   belgeno='P'+cast(m.Firmano as varchar)+''+cast(m.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs( m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from poshrk as m with (nolock)
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk) and
   (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   left join Genel_Kart as car on car.cartp='poskart'
   and car.kod=m.poskod 
   Where sil=0 and m.varno>0 and m.varok=1 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='pomvardimas'
   order by m.id

  if @Firmano>0 and @Tip=2
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.varno,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=3,
     case
     when (m.islmtip+'_'+m.islmhrk='TAH_POS') then 'TPOS'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.poskod,car.muhonkod,car.muhkod,car.ad,
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
   belgeno='M'+cast(m.Firmano as varchar)+''+cast(m.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs( m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from poshrk as m with (nolock)
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk) and
   (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   left join Genel_Kart as car on car.cartp='poskart'
   and car.kod=m.poskod 
   Where sil=0 and m.varno>0 and m.varok=1 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='marvardimas'
   order by m.id
  
  /* if @Islidin<>'' */
  /*  delete from @TB_LOGO_KASA Where islmhrk_id not in (select * from CsvToInt(@Islidin) ) */
  
  
  
   update @TB_LOGO_KASA set
   giren=case when hrk_BA='A' then 
   geneltop else 0 end,
   cikan=case when hrk_BA='B' then 
   geneltop else 0 end
   
   /*
   update @TB_LOGO_KASA set
   zcar_muhonkod=car.muhonkod,
   zcar_muhkod=car.muhkod,
   zcar_unvan=car.ad
   from @TB_LOGO_KASA as t
   inner join Genel_Kart as car on 
   car.cartp=t.zcar_tip and 
   car.kod=t.zcar_kod 
   */
  
  


 return


END

================================================================================
