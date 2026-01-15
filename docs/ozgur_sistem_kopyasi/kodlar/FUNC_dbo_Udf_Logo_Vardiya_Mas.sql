-- Function: dbo.Udf_Logo_Vardiya_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.742772
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_Vardiya_Mas]
(@Firmano int,
@Tip   varchar(20),
@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_LOGO_FATURA TABLE (
  fat_id                 int,
  FatRap_id				 int,
  Petro_Evrak_Tip        varchar(30),
  hrk_tipno				 int,
  hrk_tip				 varchar(10),
  hrk_tipad				 varchar(50),
  hrk_ack				 varchar(200),
  tarih                  datetime,
  saat                   varchar(10),
  car_kod				 varchar(30),
  car_muhonkod			 varchar(30),
  car_muhkod			 varchar(30),
  car_unvan				 varchar(150),
  belgeno			     Varchar(20),
  fat_gider              float,
  fat_iskonto			 float,
  fat_isk_yuz            float,					
  fat_kdvtop			 float,
  fat_aratop			 float,
  fat_geneltop			 float,
  giren					 float,
  cikan					 float,
  fat_olustarsaat        datetime
  )
AS
BEGIN

/*
  16777216	        318767104
  49	65536	      3211264
  28	256	             7168
  */

  
  
  /*- pomvardiya fatura */
  
   
      insert into @TB_LOGO_FATURA
      (fat_id,FatRap_id,Petro_Evrak_Tip,
      hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
      tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
      belgeno,fat_gider,
      fat_aratop,
      fat_iskonto,fat_isk_yuz,fat_kdvtop,
      fat_geneltop,
      fat_olustarsaat)
  
      select MAX(m.varno),0,fistip=@Tip,/*'pomvardimas', */
      hrk_tip='var',hrk_tipno=7,
      case when @Tip='pomvardimas' then 'POMPACI VARDIYA' else 'MARKET VARDIYA' end,
         '',MAX(m.TARIH),MAX(m.SAAT),
         CARKOD,CARKOD,CARKOD,CARKOD,
      fat_serino=case when @Tip='pomvardimas' then  'P'
      else 'M' end
      +cast(@Firmano as varchar)+''+
       CONVERT(VARCHAR(8), m.varno),   /* Varchar(15) */
      fat_gider=0,
       fat_aratop=SUM(STOK_TUTARKDVSIZ),
       fat_iskonto=0,
       fat_isk_yuz=0,
       fat_kdvtop=SUM(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ),/*kdv genel tutar */
      fat_geneltop=SUM(STOK_TUTARKDVLI),
      fat_olustarsaat=MAX(m.olustarsaat)
      from UDF_PomVarNakitStokhrk (@Firmano,@Tip,@Bastar,@Bittar)  as m 
       group by m.varno,m.CARKOD /* m.varno,m.SERINO,m.TARIH,m.SAAT, */

      
  
  update @TB_LOGO_FATURA set
  /*fat_aratop=fat_aratop,--fat_geneltop-fat_kdvtop,  */
  giren=case when hrk_tipno=1 then 
  fat_geneltop else 0 end,
  cikan=case 
  when (hrk_tipno=7) or (hrk_tipno=8) then 
  fat_geneltop else 0 end  
  
  

  



  

 return


END

================================================================================
