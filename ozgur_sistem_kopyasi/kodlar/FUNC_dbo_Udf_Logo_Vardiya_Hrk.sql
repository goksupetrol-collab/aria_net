-- Function: dbo.Udf_Logo_Vardiya_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.740450
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Hrk]
(@Firmano int,
@Tip    varchar(20),
@Bastar DATETIME,
@Bittar DATETIME,
@AkaryakitBrm   Varchar(20),
@MarketBrm   Varchar(20),
@MasrafBrm   Varchar(20))
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
  (fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tipno,fat_tarih,
  fat_saat,stk_logo_tip,
  stk_kod,stk_muhonkod,
  stk_muhkod,stk_muhkdvkod,
  stk_brim,
  stk_brmfiy,
  stk_brmfiykdvli,
  stk_miktar,
  stk_isktop,
  stk_kdv,
  stk_kdvtop,
  stk_aratop,
  stk_isktolutop,
  stk_olustarsaat)


    select h.varno,0,@Tip,/*'pomvardimas', */
    cha_tip=8,
    max(h.TARIH),max(h.SAAT),
    case 
    when h.STOK_TIP='akykt' then  0
    when h.STOK_TIP='markt' then  0
    when h.STOK_TIP='gelgid' then 4 
    end,
    SK.kod,
    sk.muhonkod,
    sk.muhckskod,
    dbo.Udf_KdvMuhKodu(2,sk.sat1kdv),
    case when h.STOK_TIP='akykt' then  @AkaryakitBrm
    when h.STOK_TIP='markt' then  @MarketBrm
    when h.STOK_TIP='gelgid' then @MasrafBrm
    end,    
    sum(h.STOK_TUTARKDVSIZ)/sum(h.STOK_MIKTAR),/*h.STOK_BRMKDVSIZ, */
    sum(h.STOK_TUTARKDVLI)/sum(h.STOK_MIKTAR),/*h.STOK_BRMKDVLI, */
    sum(h.STOK_MIKTAR),
    0, /*isktut */
    max(h.STOK_KDVYUZ*100),
    sum(h.STOK_TUTARKDVLI-h.STOK_TUTARKDVSIZ),
    sum(h.STOK_TUTARKDVSIZ),
    sum(h.STOK_TUTARKDVLI),
    stk_olustarsaat=max(h.olustarsaat)
    from UDF_PomVarNakitStokHrk (@Firmano,@Tip,@Bastar,@Bittar) as h /*'pomvardimas' */
     left join gelgidlistok as sk on sk.tip=h.STOK_TIP and sk.kod=h.STOK_KOD
     group by  h.varno,sk.kod,sk.muhonkod,sk.muhckskod,h.STOK_TIP,sk.sat1kdv,h.STOK_BRIM
    
    
   
   
   

 return


END

================================================================================
