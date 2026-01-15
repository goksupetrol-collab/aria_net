-- Function: dbo.Udf_Logo_Fatura_Firma_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.737751
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Fatura_Firma_Hrk]
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
  fat_tarih              datetime,
  fat_saat               varchar(10),
  stk_logo_tip           int,                
  stk_kod				 varchar(30),
  stk_muhonkod			 varchar(30),
  stk_muhkod			 varchar(30),
  stk_muhkdvkod			 varchar(30), 
  stk_brim				 varchar(5),
  stk_brmfiy			 float,
  stk_brmfiykdvli    	 float,
  stk_miktar			 float,
  stk_isktop			 float,					
  stk_kdv     			 float,
  stk_kdvtop     	     float,
  stk_aratop             float,
  stk_isktolutop         float,
  stk_olustarsaat        datetime
  )
AS
BEGIN

  insert into @TB_LOGO_FATURA
  (fat_id,FatRap_id,Petro_Evrak_Tip,hrk_tipno,fat_tarih,
  fat_saat,stk_logo_tip,stk_kod,stk_muhonkod,
  stk_muhkod,stk_muhkdvkod,stk_brim,
  stk_brmfiy,stk_brmfiykdvli,
  stk_miktar,stk_isktop,stk_kdv,stk_kdvtop,
  stk_aratop,stk_isktolutop,
  stk_olustarsaat)

  select m.fatid,m.fatrap_id,m.fattip,
  cha_tip=case
     when (m.gctip=2) and (m.fattip='FATVERSAT')  then 7
     when (m.gctip=2) and (m.fattip<>'FATVERSAT') then 8
     when m.gctip=1 then 1
     when m.fattip='FATIADALS' then  8
     when m.fattip='FATIADSAT' then  1 end, /*0 borc ,1 alacak */
    m.tarih,m.saat,
    case 
    when h.stktip='akykt' then  0
    when h.stktip='markt' then  0
    when h.stktip='gelgid' then 4 
    end,
    h.stkod,sk.muhonkod,
    case
     when (m.gctip=1) then   sk.muhgrskod
     when (m.gctip=2) then  sk.muhckskod
     when m.fattip='FATIADALS' then  sk.muhckskod
     when m.fattip='FATIADSAT' then  sk.muhgrskod end,
     case
     when (m.gctip=1)  then dbo.Udf_KdvMuhKodu(1,sk.sat1kdv)
     when (m.gctip=2) then dbo.Udf_KdvMuhKodu(2,sk.sat1kdv)
     when m.fattip='FATIADALS' then dbo.Udf_KdvMuhKodu(3,sk.sat1kdv)
     when m.fattip='FATIADSAT' then dbo.Udf_KdvMuhKodu(4,sk.sat1kdv)
     end,
    h.brim,
    h.brmfiy,
    (h.brmfiy*(1+h.kdvyuz)),
    (h.mik*carpan),
    h.genisktut,
    (h.kdvyuz*100),
    h.kdvtut*h.mik,(h.mik*carpan)*h.brmfiy,
    ((h.mik*carpan)*h.brmfiy)-h.genisktut,
   stk_olustarsaat=m.olustarsaat
  from faturahrk as h 
  inner join faturamas as m 
  on h.fatid=m.fatid and h.sil=0 and m.sil=0 and m.firmano=@Firmano
  and isnull(m.Entegre,0)=0 
  left join gelgidlistok as sk on sk.tip=h.stktip and sk.kod=h.stkod
  Where m.tarih>=@bastar and m.tarih <=@bittar
  and m.FatTip_id in (select * from CsvToSTR(@fatRapin) )
   order by m.fatid
   
   
   
 
   
   

 return


END

================================================================================
