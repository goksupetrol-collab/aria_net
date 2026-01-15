-- Function: dbo.Udf_Logo_Fatura_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.738664
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Fatura_Hrk]
(@Firmano		int,
@fatRapin  varchar(8000),
@Bastar DATETIME,
@Bittar DATETIME,
@AkaryakitBrm   Varchar(20),
@MarketBrm   Varchar(20),
@MasrafBrm   Varchar(20))
RETURNS
  @TB_LOGO_FATURA TABLE (
  Firmano				 int,
  fat_id                 int,
  FatRap_id				 int,
  Petro_Evrak_Tip        varchar(30),
  hrk_tipno				 int,
  fat_tarih              datetime,
  fat_saat               varchar(10),
  stk_logo_tip           int,                
  stk_kod				 varchar(50),
  stk_muhonkod			 varchar(50),
  stk_muhkod			 varchar(50),
  stk_muhkdvkod			 varchar(50), 
  stk_brim				 varchar(5),
  stk_tip				 varchar(10),
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

 declare @MarketKdv0OnMuhKod varchar(50)
 declare @MarketKdv1OnMuhKod varchar(50)
 declare @MarketKdv8OnMuhKod varchar(50)
 declare @MarketKdv18OnMuhKod varchar(50)
 
  
 
 select @MarketKdv0OnMuhKod=EntegreMarketKdv0OnMuhKod,
 @MarketKdv1OnMuhKod=EntegreMarketKdv1OnMuhKod,
 @MarketKdv8OnMuhKod=EntegreMarketKdv8OnMuhKod,
 @MarketKdv18OnMuhKod=EntegreMarketKdv18OnMuhKod
 from firma where id=@Firmano
 


  insert into @TB_LOGO_FATURA
  (Firmano,fat_id,FatRap_id,Petro_Evrak_Tip,hrk_tipno,fat_tarih,
  fat_saat,stk_logo_tip,stk_kod,stk_muhonkod,
  stk_muhkod,stk_muhkdvkod,stk_brim,stk_tip,
  stk_brmfiy,stk_brmfiykdvli,
  stk_miktar,stk_isktop,stk_kdv,stk_kdvtop,
  stk_aratop,stk_isktolutop,stk_olustarsaat)

  select m.firmano,m.fatid,m.fatrap_id,m.fattip,
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
    h.stkod,
    sk.muhonkod,
    case
     when (m.gctip=1) then  sk.muhgrskod
     when (m.gctip=2) then  sk.muhckskod
     when m.fattip='FATIADALS' then  sk.muhckskod
     when m.fattip='FATIADSAT' then  sk.muhgrskod end,
     case
     when (m.gctip=1)  then dbo.Udf_KdvMuhKodu(1,sk.sat1kdv)
     when (m.gctip=2) then dbo.Udf_KdvMuhKodu(2,sk.sat1kdv)
     when m.fattip='FATIADALS' then dbo.Udf_KdvMuhKodu(3,sk.sat1kdv)
     when m.fattip='FATIADSAT' then dbo.Udf_KdvMuhKodu(4,sk.sat1kdv)
     end,
    case 
    when h.stktip='akykt' then  @AkaryakitBrm
    when h.stktip='markt' then  @MarketBrm
    when h.stktip='gelgid' then @MasrafBrm
    end,
    h.stktip,    
    
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
  on h.fatid=m.fatid and h.sil=0 and m.sil=0
  left join gelgidlistok as sk on sk.tip=h.stktip and sk.kod=h.stkod
  Where m.tarih>=@bastar and m.tarih <=@bittar
  and m.fatRap_id in (select * from CsvToSTR(@fatRapin) )
   order by m.fatid
   
   
   
  /*İRSALİYE  */
   
  insert into @TB_LOGO_FATURA
  (firmano,fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tipno,fat_tarih,
  fat_saat,stk_logo_tip,
  stk_kod,stk_muhonkod,
  stk_muhkod,stk_muhkdvkod,
  stk_brim,stk_tip,
  stk_brmfiy,stk_brmfiykdvli,
  stk_miktar,stk_isktop,
  stk_kdv,stk_kdvtop,
  stk_aratop,
  stk_isktolutop,
  stk_olustarsaat)

  select m.Firmano,m.verid,m.fisrap_id,m.fistip,
  cha_tip=case
     when (m.fistip='FISVERSAT')  then 7
     when (m.fistip='FISALCSAT') then 1 end,
     /*0 borc ,1 alacak */
    m.tarih,m.saat,
    case 
    when h.stktip='akykt' then  0
    when h.stktip='markt' then  0
    when h.stktip='gelgid' then 4 
    end, h.stkod,
    sk.muhonkod,
    case
     when m.fistip='FISVERSAT' then  sk.muhckskod
     when m.fistip='FISALCSAT' then  sk.muhgrskod end,
     
    case
     when m.fistip='FISALCSAT' then   dbo.Udf_KdvMuhKodu(1,sk.sat1kdv) 
     when m.fistip='FISVERSAT' then   dbo.Udf_KdvMuhKodu(2,sk.sat1kdv) 
     end,
    case 
     when h.stktip='akykt' then  @AkaryakitBrm
    when h.stktip='markt' then  @MarketBrm
    when h.stktip='gelgid' then @MasrafBrm
    end,
    h.stktip,    
    h.brmfiy/(1+h.kdvyuz),
    h.brmfiy,
    (h.mik),
    ((h.brmfiy)-(h.brmfiy*(1+h.iskyuz)))*h.mik, /*isktut */
    (h.kdvyuz*100),
    ((h.brmfiy*h.mik)*(h.kdvyuz*100))/( (1+h.kdvyuz)*100),
    (h.mik)*(h.brmfiy/(1+h.kdvyuz)),
    
    (h.mik*h.brmfiy)-
    (((h.brmfiy)-(h.brmfiy*(1+h.iskyuz)))*h.mik),
    
   stk_olustarsaat=m.olustarsaat
  from veresihrk as h 
  inner join veresimas as m 
  on h.verid=m.verid and h.sil=0 and m.sil=0
  left join gelgidlistok as sk on sk.tip=h.stktip and sk.kod=h.stkod
  Where m.tarih>=@bastar and m.tarih <=@bittar
  and m.fisRap_id in (select * from CsvToSTR(@fatRapin) )
   order by m.fatid
      
   
   
   /*pomvardiya */
 

if (select COUNT(*) from CsvToSTR(@fatRapin) where STRValue=0)>0
 begin
  insert into @TB_LOGO_FATURA
  (firmano,fat_id,FatRap_id,Petro_Evrak_Tip,
  hrk_tipno,fat_tarih,
  fat_saat,stk_logo_tip,
  stk_kod,stk_muhonkod,
  stk_muhkod,stk_muhkdvkod,
  stk_brim,stk_tip,
  stk_brmfiy,
  stk_brmfiykdvli,
  stk_miktar,
  stk_isktop,
  stk_kdv,
  stk_kdvtop,
  stk_aratop,
  stk_isktolutop,
  stk_olustarsaat)

  select h.FIRMANO,h.varno,0,'pomvardimas',
  cha_tip=8,
    h.TARIH,h.SAAT,
    case 
    when h.STOK_TIP='akykt' then  0
    when h.STOK_TIP='markt' then  0
    when h.STOK_TIP='gelgid' then 4 
    end,
    SK.kod,
    sk.muhonkod,
    sk.muhckskod,
    dbo.Udf_KdvMuhKodu(2,sk.sat1kdv),
    
   case 
    when h.STOK_TIP='akykt' then  @AkaryakitBrm
    when h.STOK_TIP='markt' then  @MarketBrm
    when h.STOK_TIP='gelgid' then @MasrafBrm
    end,  
    h.STOK_TIP,  
    h.STOK_BRMKDVSIZ,
    h.STOK_BRMKDVLI,
    (h.STOK_MIKTAR),
    0, /*isktut */
    (h.STOK_KDVYUZ*100),
    (h.STOK_TUTARKDVLI-h.STOK_TUTARKDVSIZ),
    (h.STOK_TUTARKDVSIZ),
    (h.STOK_TUTARKDVLI),
    stk_olustarsaat=h.olustarsaat
    from UDF_PomVarNakitStokHrk (0,'pomvardimas',@Bastar,@Bittar) as h
     left join gelgidlistok as sk on sk.tip=h.STOK_TIP and sk.kod=h.STOK_KOD
     order by h.varno
  end 
   
  
  if isnull(@MarketKdv0OnMuhKod,'')!=''
   begin  
    update  @TB_LOGO_FATURA set 
    stk_muhonkod=
    case 
    when stk_kdv=0 then
    @MarketKdv0OnMuhKod    
    when stk_kdv=1  then
    @MarketKdv1OnMuhKod    
    when stk_kdv=8  then
    @MarketKdv8OnMuhKod    
    when stk_kdv=18 then
    @MarketKdv18OnMuhKod
    end    
    where stk_tip='markt'
  end 
   
   

 return


END

================================================================================
