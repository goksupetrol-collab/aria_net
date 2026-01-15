-- Function: dbo.Udf_Logo_Vardiya_Pos
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.743352
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Pos]
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
  pos_kod				varchar(30) COLLATE Turkish_CI_AS,
  pos_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  pos_muhkod			varchar(30) COLLATE Turkish_CI_AS,
  pos_unvan			    varchar(150) COLLATE Turkish_CI_AS,
  zcar_kod				 varchar(30) COLLATE Turkish_CI_AS,
  zcar_muhonkod			 varchar(30) COLLATE Turkish_CI_AS,
  zcar_muhkod			 varchar(30) COLLATE Turkish_CI_AS,
  zcar_unvan				 varchar(150) COLLATE Turkish_CI_AS,
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
  pos_kod,pos_muhonkod,pos_muhkod,pos_unvan,
  zcar_kod,zcar_muhonkod,zcar_muhkod,zcar_unvan,
  belgeno,geneltop,olustarsaat)

  select m.id,m.poshrkid,
    hrk_ba='B',
    hrk_tipno=70,'POS',m.ack,   
    m.tarih,m.saat,
    m.poskod,car.muhonkod,car.muhkod,car.ad,
    @CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
    belgeno=m.belno, 
    geneltop=abs(m.giren-m.cikan),
    olustarsaat=m.olustarsaat
  from poshrk as m WITH(NOLOCK)
  inner join Genel_Kart as car on car.cartp='poskart'
  and car.kod=m.poskod and m.sil=0 and m.firmano=@Firmano
  Where sil=0 and m.varno in
  (select varno from pomvardimas WITH(NOLOCK) where sil=0 and varok=1 and  
  tarih>=@bastar and tarih <=@bittar )
  and m.yertip='pomvardimas' and isnull(m.Entegre,0)=0  
  order by m.id
  
  
  
  

 return


END

================================================================================
