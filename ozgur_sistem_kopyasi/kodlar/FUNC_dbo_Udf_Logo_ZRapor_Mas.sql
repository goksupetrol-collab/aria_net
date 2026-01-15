-- Function: dbo.Udf_Logo_ZRapor_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.746191
================================================================================

CREATE FUNCTION [dbo].[Udf_Logo_ZRapor_Mas]
(@Firmano int,@Bastar DATETIME,@Bittar DATETIME)
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
  fat_olustarsaat        datetime,
  Entegre				 bit default 0
  )
AS
BEGIN


  DECLARE @CAR_KOD             VARCHAR(30) 

   if @firmano=0  
    SELECT @CAR_KOD=zrap_carkod FROM sistemtanim


   if @firmano>0  
    SELECT @CAR_KOD=Entegre_ZraporOnMuhKod FROM Firma where id=@firmano


 
   
      insert into @TB_LOGO_FATURA
      (fat_id,FatRap_id,Petro_Evrak_Tip,
      hrk_tip,hrk_tipno,hrk_tipad,hrk_ack,
      tarih,saat,car_kod,car_muhonkod,car_muhkod,car_unvan,
      belgeno,fat_gider,
      fat_aratop,
      fat_iskonto,fat_isk_yuz,fat_kdvtop,
      fat_geneltop,
      fat_olustarsaat,Entegre)
  
      select m.zrapid,0,fistip='ZRAPOR',
      hrk_tip='var',hrk_tipno=8,'Z RAPORLARI',
      '',m.tarih,m.saat,
      @CAR_KOD,@CAR_KOD,@CAR_KOD,@CAR_KOD,
      fat_serino=M.zseri+cast(M.zserino as varchar),
      fat_gider=0,
       fat_aratop=m.Genel_Ara_Top,
       fat_iskonto=0,
       fat_isk_yuz=0,
       fat_kdvtop=M.Genel_Kdv_Top,
      fat_geneltop=M.Genel_Top,
      fat_olustarsaat=m.olustarsaat,
      Entegre=M.Entegre
      from zrapormas as m where m.firmano=@Firmano
      and m.tarih>=@Bastar and  m.tarih<=@Bittar
      and m.sil=0 and isnull(m.Entegre,0)=0
     
  
      update @TB_LOGO_FATURA set
      giren=case when hrk_tipno=1 then 
      fat_geneltop else 0 end,
      cikan=case 
      when (hrk_tipno=7) or (hrk_tipno=8) then 
      fat_geneltop else 0 end  
  
 

 return


END

================================================================================
