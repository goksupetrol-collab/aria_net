-- Function: dbo.Udf_Logo_Kasa_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.739606
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Kasa_Hrk]
(@Firmano   int,
@Islidin  varchar(8000),
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
  kasa_kod				varchar(30),
  kasa_muhonkod			 varchar(30),
  kasa_muhkod			varchar(30),
  kasa_unvan			    varchar(150),
  zcar_tip				 varchar(20),
  zcar_kod				 varchar(30),
  zcar_muhonkod			 varchar(30),
  zcar_muhkod			 varchar(30),
  zcar_unvan				 varchar(150),
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
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  kasa_kod,kasa_muhonkod,kasa_muhkod,kasa_unvan,
  zcar_tip,zcar_kod,zcar_muhonkod,zcar_muhkod,zcar_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.kashrkid,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
     when (m.islmtip+'_'+m.islmhrk='BNK_YTN') then 21
     when (m.islmtip+'_'+m.islmhrk='BNK_CKN') then 22
     when (m.islmtip+'_'+m.islmhrk='TAH_NAK') then 11
     when (m.islmtip+'_'+m.islmhrk='ODE_NAK') then 12
     else
     1
     end,
     case
     when (m.islmtip+'_'+m.islmhrk='BNK_YTN') then 'BYTN'
     when (m.islmtip+'_'+m.islmhrk='BNK_CKN') then 'BCKN'
     when (m.islmtip+'_'+m.islmhrk='TAH_NAK') then 'TNAK'
     when (m.islmtip+'_'+m.islmhrk='ODE_NAK') then 'ONAK'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.kaskod,car.muhonkod,car.muhkod,car.ad,
    m.cartip,m.carkod,'','','',
   belgeno=m.belno, /* Varchar(15) */
   gider_tut=0,
   geneltop=abs( m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from kasahrk as m 
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
   left join Genel_Kart as car on car.cartp='kasakart'
   and car.kod=m.kaskod 
   Where sil=0 and m.varno=0
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 
   order by m.id
  

  if @Firmano>0 
  insert into @TB_LOGO_KASA
  (id,firmano,islmhrk_id,hrk_id,Aktar,Petro_Evrak_Tip,hrk_ba,
  hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  kasa_kod,kasa_muhonkod,kasa_muhkod,kasa_unvan,
  zcar_tip,zcar_kod,zcar_muhonkod,zcar_muhkod,zcar_unvan,
  belgeno,gider_tut,
  geneltop,olustarsaat)

  select m.id,m.firmano,isl.id,m.kashrkid,
  case 
  when (m.islmtip+'_'+m.islmhrk='VIR_VRC') then 0
  else 1 end,
  'kas',
  hrk_ba=case when giren>0 then 'B' else 'A' end,
  hrk_tip=(m.islmtip+'_'+m.islmhrk),
   hrk_tipno=case
     when (m.islmtip+'_'+m.islmhrk='BNK_YTN') then 21
     when (m.islmtip+'_'+m.islmhrk='BNK_CKN') then 22
     when (m.islmtip+'_'+m.islmhrk='TAH_NAK') then 11
     when (m.islmtip+'_'+m.islmhrk='ODE_NAK') then 12
     else
     1
     end,
     case
     when (m.islmtip+'_'+m.islmhrk='BNK_YTN') then 'BYTN'
     when (m.islmtip+'_'+m.islmhrk='BNK_CKN') then 'BCKN'
     when (m.islmtip+'_'+m.islmhrk='TAH_NAK') then 'TNAK'
     when (m.islmtip+'_'+m.islmhrk='ODE_NAK') then 'ONAK'
     else 'KASA' 
    end,
    m.ack,   
    m.tarih,m.saat,
    m.kaskod,car.muhonkod,car.muhkod,car.ad,
    m.cartip,m.carkod,'','','',
   belgeno=m.belno, /* Varchar(15) */
   gider_tut=0,
   geneltop=abs( m.giren-m.cikan),
   olustarsaat=m.olustarsaat
   from kasahrk as m 
   inner join islemhrktip as isl on
   (isl.tip+'_'+isl.hrk)=(m.islmtip+'_'+m.islmhrk)
   left join Genel_Kart as car on car.cartp='kasakart'
   and car.kod=m.kaskod 
   Where sil=0 and m.varno=0 and m.firmano in (0,@Firmano)
   and m.tarih>=@bastar and m.tarih <=@bittar
    and isnull(m.Entegre,0)=0 
   order by m.id


  
   if @Islidin<>''
    delete from @TB_LOGO_KASA Where islmhrk_id not in (select * from CsvToInt(@Islidin) )
  
  
  
   update @TB_LOGO_KASA set
   giren=case when hrk_BA='A' then 
   geneltop else 0 end,
   cikan=case when hrk_BA='B' then 
   geneltop else 0 end
   
   
   update @TB_LOGO_KASA set
   zcar_muhonkod=car.muhonkod,
   zcar_muhkod=car.muhkod,
   zcar_unvan=car.ad
   from @TB_LOGO_KASA as t
   inner join Genel_Kart as car on 
   car.cartp=t.zcar_tip and 
   car.kod=t.zcar_kod 
   
  
  


 return


END

================================================================================
