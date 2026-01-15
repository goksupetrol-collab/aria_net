-- Function: dbo.Udf_Logo_Vardiya_Pos_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.744811
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Pos_Mas]
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

  select p.varno,p.firmano,p.varno,p.varno,
  1,'kas',
  hrk_ba='B' ,
  hrk_tip='TAH_POS',
    hrk_tipno=3,'TPOS',
    p.varad,   
    p.tarih,p.saat,
   /* m.bankod,car.muhonkod,car.muhkod,car.ad, */
   '','','','',
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    belgeno='P'+cast(p.Firmano as varchar)+''+cast(p.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs(sum(m.giren-m.cikan)),
   olustarsaat=p.olustarsaat
   from poshrk as m with (nolock)
   inner join pomvardimas as p with (nolock) on p.varno=m.varno
   and (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   Where m.sil=0 and m.varno>0 and m.varok=1
   and p.tarih>=@bastar and p.tarih <=@bittar
   and isnull(m.Entegre,0)=0  and m.yertip='pomvardimas'
   group by p.varno,p.firmano,p.varad,p.tarih,p.saat,p.olustarsaat
   order by p.varno
   
   
  if @Firmano=0 and @Tip=2
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select p.varno,p.firmano,p.varno,p.varno,
  1,'kas',
  hrk_ba='B',
  hrk_tip='TAH_POS',
    hrk_tipno=3,'TPOS',
    p.varad,   
    p.tarih,p.saat,
   '','','','',
   /* m.bankod,car.muhonkod,car.muhkod,car.ad, */
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    belgeno='M'+cast(p.Firmano as varchar)+''+cast(p.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs(sum(m.giren-m.cikan)),
   olustarsaat=p.olustarsaat
   from poshrk as m with (nolock)
   inner join marvardimas as p with (nolock) on p.varno=m.varno
   and  (m.islmtip+'_'+m.islmhrk)='TAH_POS'
  /*  left join Genel_Kart as car on car.cartp='bankakart'   and car.kod=m.bankod */
   Where m.sil=0 and m.varno>0 and m.varok=1
   and p.tarih>=@bastar and p.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='marvardimas'
     group by p.varno,p.firmano,p.varad,p.tarih,p.saat,p.olustarsaat
   order by p.varno
    

  if @Firmano>0 and @Tip=1
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select p.varno,p.firmano,p.varno,p.varno,
  1,'kas',
  hrk_ba='B',
  hrk_tip='TAH_POS',
   hrk_tipno=3,'TPOS',
    p.varad,   
    p.tarih,p.saat,
    '','','','',
   /* m.bankod,car.muhonkod,car.muhkod,car.ad, */
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
   belgeno='P'+cast(p.Firmano as varchar)+''+cast(p.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs(sum( m.giren-m.cikan)),
   olustarsaat=p.olustarsaat
   from poshrk as m with (nolock)
   inner join pomvardimas as p with (nolock) on p.varno=m.varno 
   inner join islemhrktip as isl on 
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk) and  (m.islmtip+'_'+m.islmhrk)='TAH_POS'
   Where m.sil=0 and m.varno>0 and m.varok=1 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='pomvardimas'
   group by p.varno,p.firmano,p.varad,p.tarih,p.saat,p.olustarsaat
   order by p.varno





  if @Firmano>0 and @Tip=2
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  bnk_kod,bnk_muhonkod,bnk_muhkod,bnk_unvan,
  car_tip,car_kod,car_muhonkod,car_muhkod,car_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select p.varno,p.firmano,p.varno,p.varno,
  1,'kas',
  hrk_ba= 'B',
  hrk_tip='TAH_POS',
   hrk_tipno=3, 'TPOS',
    p.varad,   
    p.tarih,p.saat,
    '','','','',
   /*  m.bankod,car.muhonkod,car.muhkod,car.ad, */
    'carikart',@CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
   belgeno='M'+cast(p.Firmano as varchar)+''+cast(p.varno as varchar), /* Varchar(15) */
   gider_tut=0,
   geneltop=abs (sum( m.giren-m.cikan)),
   olustarsaat=p.olustarsaat
   from poshrk as m with (nolock)
   inner join marvardimas as p  with (nolock) on p.varno=m.varno 
    and  (m.islmtip+'_'+m.islmhrk)='TAH_POS'
 /*  left join Genel_Kart as car on car.cartp='bankakart'   and car.kod=m.bankod  */
   Where m.sil=0 and m.varno>0 and m.varok=1 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 and m.yertip='marvardimas'
   group by p.varno,p.firmano,p.varad,p.tarih,p.saat,p.olustarsaat
   order by p.varno
  
  /* if @Islidin<>'' */
  /*  delete from @TB_LOGO_KASA Where islmhrk_id not in (select * from CsvToInt(@Islidin) ) */
  
  
  
   update @TB_LOGO_KASA set
   giren=case when hrk_BA='A' then 
   geneltop else 0 end,
   cikan=case when hrk_BA='B' then 
   geneltop else 0 end
  
  
  


 return


END

================================================================================
