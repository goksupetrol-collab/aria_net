-- Function: dbo.Udf_EIrsaliye_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.712854
================================================================================

CREATE FUNCTION [dbo].[Udf_EIrsaliye_Hrk]
(@Firmano   int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  ir_id                 int,
  irRap_id				 int,
  fat_tarih              datetime,
  fat_saat               varchar(10),            
  stk_kod				 varchar(30),
  Stk_Ad				 varchar(150),
  stk_muhonkod			 varchar(30),
  stk_muhkod			 varchar(30),
  stk_muhkdvkod			 varchar(30),
  stk_brim				 varchar(5),
  stk_brmfiy			 float,
  stk_brmfiykdvli    	 float,
  stk_isktolubrmfiykdvsiz float,
  stk_miktar			 float,
  stk_iskyuz			 float,
  stk_isktop			 float,					
  stk_kdvyuz   			 float,
  stk_kdvtop     	     float,
  stk_aratop             float,
  stk_isktolutop         float,
  stk_olustarsaat        datetime
  )
AS
BEGIN

  insert into @TB_LOGO_FATURA
  (ir_id,irRap_id,fat_tarih,
  fat_saat,stk_kod,Stk_Ad,
  stk_muhonkod,stk_muhkdvkod,stk_brim,
  stk_brmfiy,stk_brmfiykdvli,
  stk_miktar,stk_isktolubrmfiykdvsiz,
  stk_iskyuz,stk_isktop,stk_kdvyuz,stk_kdvtop,
  stk_aratop,stk_isktolutop,stk_olustarsaat)

  select m.irid,m.irsrap_id,
    m.tarih,m.saat,
    h.stkod,sk.ad,sk.muhonkod,
    h.kdvyuz,sk.brim,
    h.brmfiy,(h.brmfiy*(1+h.kdvyuz)),
    (h.mik*carpan),
    (h.brmfiy-h.genisktut),
    0 Top_isk_Yuz,
    0 Top_isk_Tut,
    (h.kdvyuz*100),
    h.kdvtut*(h.mik*h.carpan),
    (h.mik*carpan)*h.brmfiy,
    ((h.mik*carpan)*h.brmfiy)-(h.genisktut*h.mik*carpan),
    
   stk_olustarsaat=m.olustarsaat
  from irsaliyehrk as h 
  inner join irsaliyemas as m 
  on h.irid=m.irid and h.sil=0 and m.sil=0
  left join Genel_Cari_Kart as car on car.cartip=m.cartip 
  and car.kod=m.carkod    
  left join gelgidlistok as sk on sk.tip=h.stktip and sk.kod=h.stkod
  Where  m.Firmano=@Firmano 
  and isnull(m.EBelgeTipId,0)>0 and m.gctip=2 /* Sadece Satis */
  /*and car.Efatura=1 */
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.irsrap_id in (select * from CsvToSTR(@fatRapin) )
   order by m.fatid
   

 return


END

================================================================================
