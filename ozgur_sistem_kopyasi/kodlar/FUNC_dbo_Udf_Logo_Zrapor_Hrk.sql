-- Function: dbo.Udf_Logo_Zrapor_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.745775
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Zrapor_Hrk]
(@Firmano int,
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
  hrk_tipno,stk_logo_tip,
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

  select h.zrapid,0,'ZRAPOR',
    cha_tip=8,
    case 
    when h.tip='akykt' then  0
    when h.tip='markt' then  0
    when h.tip='gelgid' then 4 
    end,
    SK.kod,
    sk.muhonkod,
    sk.muhckskod,
    dbo.Udf_KdvMuhKodu(2,sk.kdv),
    case
    when h.tip='akykt' then  @AkaryakitBrm
    when h.tip='markt' then  @MarketBrm
    when h.tip='gelgid' then @MasrafBrm
    end,
    (h.brmfiy/(1+h.kdvyuz)), /*BRMKDVSIZ, */
    h.brmfiy,/*h.STOK_BRMKDVLI, */
    h.miktar,/*miktar */
    0,/*isktop */
    h.kdvyuz*100,
    (h.brmfiy-(h.brmfiy/(1+h.kdvyuz)))*h.miktar,/*kdvtop */
    (h.brmfiy/(1+h.kdvyuz))*h.miktar,/*kdvsiztop */
    h.brmfiy*h.miktar,/*kdvtoplam */
    stk_olustarsaat=h.olustarsaat
    from zrapormas as m 
    inner join  zraporhrk h on h.zrapid=m.zrapid and m.sil=0 and h.sil=0
    inner join Zrapor_UrunKart_Listesi as sk on sk.tip=h.tip and sk.kod=h.kod 
    where m.firmano=@Firmano and m.tarih>=@Bastar and  m.tarih<=@Bittar
    and isnull(m.Entegre,0)=0
    

    
  
  
   
   

 return


END

================================================================================
