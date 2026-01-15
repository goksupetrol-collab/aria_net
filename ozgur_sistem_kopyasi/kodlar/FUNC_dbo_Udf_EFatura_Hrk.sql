-- Function: dbo.Udf_EFatura_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.711926
================================================================================

CREATE FUNCTION [dbo].[Udf_EFatura_Hrk]
(@Firmano   int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  fat_id                 int,
  FatRap_id				 int,
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
  stk_kdvtevkifatYuz     float,
  stk_kdvtevkifatTop     float,
  stk_kdvtevkifatKod     varchar(5),
  stk_kdvtevkifatAck     varchar(150),
  stk_aratop             float,
  stk_isktolutop         float,
  stk_olustarsaat        datetime
  )
AS
BEGIN

  insert into @TB_LOGO_FATURA
  (fat_id,FatRap_id,fat_tarih,
  fat_saat,stk_kod,Stk_Ad,
  stk_muhonkod,stk_muhkdvkod,stk_brim,
  stk_brmfiy,stk_brmfiykdvli,
  stk_miktar,stk_isktolubrmfiykdvsiz,
  stk_iskyuz,stk_isktop,stk_kdvyuz,stk_kdvtop,
  stk_kdvtevkifatYuz,stk_kdvtevkifatTop,
  stk_kdvtevkifatKod,stk_kdvtevkifatAck,
  stk_aratop,stk_isktolutop,stk_olustarsaat)

  select m.fatid,m.fatrap_id,
    m.tarih,m.saat,
    h.stkod,sk.ad,sk.muhonkod,
    h.kdvyuz,sk.brim,
    h.brmfiy,(h.brmfiy*(1+h.kdvyuz)),
    (h.mik*carpan),
    (h.brmfiy-h.genisktut),
    h.Top_isk_Yuz,
    (h.Top_isk_Tut),
    (h.kdvyuz*100),
    h.kdvtut*(h.mik*h.carpan) stk_kdvtop,
    h.kdvtevkifatYuzde*100,
    h.kdvtevkifatTutar,
    h.kdvtevkifatKod,
    h.kdvtevkifatAck,
    (h.mik*carpan)*h.brmfiy stk_aratop,
    ((h.mik*carpan)*h.brmfiy)-(h.genisktut*h.mik*carpan) stk_isktolutop,
    
   stk_olustarsaat=m.olustarsaat
  from faturahrklistesi as h 
  inner join faturamas as m 
  on h.fatid=m.fatid and h.sil=0 and m.sil=0
  left join Genel_Cari_Kart as car on car.cartip=m.cartip 
  and car.kod=m.carkod    
  left join gelgidlistok as sk on sk.tip=h.stktip and sk.kod=h.stkod
  Where  m.Firmano=@Firmano 
  and isnull(m.EBelgeTipId,0)>0 and m.gctip=2 /* Sadece Satis */
  /*and car.Efatura=1 */
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.fatRap_id in (select * from CsvToSTR(@fatRapin) )
   order by m.fatid
   

 return


END

================================================================================
