-- Function: dbo.Udf_Logo_Vardiya_Veresiye
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.745330
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Veresiye]
(@Firmano  int,
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_BANKA TABLE (
  id					 int,
  hrk_id                 int,
  hrk_ba				 varchar(5) COLLATE Turkish_CI_AS,	
  hrk_tipno				 int,
  hrk_tipad				 varchar(50) COLLATE Turkish_CI_AS,
  hrk_ack				 varchar(200) COLLATE Turkish_CI_AS,
  tarih                  datetime,
  saat                   varchar(10) COLLATE Turkish_CI_AS,
  Acar_kod			 varchar(30) COLLATE Turkish_CI_AS,
  Acar_muhonkod	     varchar(30) COLLATE Turkish_CI_AS,
  Acar_muhkod			 varchar(30) COLLATE Turkish_CI_AS,
  Acar_unvan			 varchar(150) COLLATE Turkish_CI_AS,
  Bcar_kod				 varchar(30) COLLATE Turkish_CI_AS,
  Bcar_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  Bcar_muhkod			 varchar(30) COLLATE Turkish_CI_AS,
  Bcar_unvan				 varchar(150) COLLATE Turkish_CI_AS,
  belgeno			     Varchar(20) COLLATE Turkish_CI_AS,
  geneltop			     float,
  olustarsaat            datetime
  )
AS
BEGIN


 declare @CAR_KOD  varchar(50)

 if @firmano=0  
  SELECT @CAR_KOD=zrap_carkod FROM sistemtanim


 if @firmano>0  
  SELECT @CAR_KOD=Entegre_ZraporOnMuhKod FROM Firma where id=@firmano

  insert into @TB_LOGO_BANKA
  (id,hrk_id,hrk_ba,hrk_tipno,hrk_tipad,hrk_ack,
  tarih,saat,
  Acar_kod,Acar_muhonkod,Acar_muhkod,Acar_unvan,
  Bcar_kod,Bcar_muhonkod,Bcar_muhkod,Bcar_unvan,
  belgeno,geneltop,olustarsaat)

  select m.id,m.verid,
    hrk_ba='B',
    hrk_tipno=5,'VER',m.ack,   /*VİRMAN */
    m.tarih,m.saat,
    @CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    m.carkod,car.muhonkod,car.muhkod,car.ad,
    belgeno=m.seri+cast(m.no as varchar), 
    geneltop=(toptut-isktop),
    olustarsaat=m.olustarsaat
    from veresimas as m WITH(NOLOCK)
    inner join Genel_Kart as car on car.cartp='carikart'
    and car.kod=m.carkod and m.sil=0 
    and m.fistip='FISVERSAT'
    and m.firmano=@Firmano
    Where sil=0 and m.varno in
    (select varno from pomvardimas WITH(NOLOCK) where sil=0 and varok=1 and  
    tarih>=@bastar and tarih <=@bittar )
    and m.yertip='pomvardimas' and isnull(m.Entegre,0)=0  
    order by m.id
  
   
  

 return


END

================================================================================
