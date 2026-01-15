-- Function: dbo.Stok_Listesi
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.674906
================================================================================

CREATE FUNCTION [dbo].[Stok_Listesi] (
@firmano 		varchar(500),
@tip  			varchar(5),
@tip_id 		int,
@Dep_Tip 		varchar(5),
@Dep_id         varchar(500), 
@Depo_kod 		varchar(1000)
)
RETURNS
   @TB_STOK_LIST TABLE (
    id					int,
    remote_id           int,
    Tip_id              int,
    firmano             int, 
    tip                 VARCHAR(20) COLLATE Turkish_CI_AS,
    kod                 VARCHAR(30) COLLATE Turkish_CI_AS, 
    ad                  VARCHAR(200) COLLATE Turkish_CI_AS, 
    barkod              VARCHAR(30) COLLATE Turkish_CI_AS, 
    grp1                int,
    grp2                int,
    grp3                int,
    grup				VARCHAR(100) COLLATE Turkish_CI_AS, 
    sat1fiy 	        float, 
    sat1kdv             float,
    sat1kdvtip          VARCHAR(20) COLLATE Turkish_CI_AS,
    sat1pbrm            VARCHAR(20) COLLATE Turkish_CI_AS,
    sat2fiy 	        float,
    sat2kdv             float,
    sat2kdvtip          VARCHAR(20) COLLATE Turkish_CI_AS,
    sat2pbrm            VARCHAR(20) COLLATE Turkish_CI_AS,    
    sat3fiy 	        float, 
    sat3kdv             float,
    sat3kdvtip          VARCHAR(20) COLLATE Turkish_CI_AS,
    sat3pbrm            VARCHAR(20) COLLATE Turkish_CI_AS,    
    sat4fiy 	        float, 
    sat4kdv             float,
    sat4kdvtip          VARCHAR(20) COLLATE Turkish_CI_AS,
    sat4pbrm            VARCHAR(20) COLLATE Turkish_CI_AS,    
    alsfiy              float,  
    alskdv 				float,	
    alskdvtip 			VARCHAR(20) COLLATE Turkish_CI_AS,
    alspbrm 			VARCHAR(20) COLLATE Turkish_CI_AS,
    kesft				float,
    brim                VARCHAR(20) COLLATE Turkish_CI_AS,
    otv					float,
    eksat				VARCHAR(20) COLLATE Turkish_CI_AS,
    minmik              float,
    drm					Varchar(10),
    zrapor				tinyint,
    muhonkod            VARCHAR(20) COLLATE Turkish_CI_AS,
    muhgrskod           VARCHAR(20) COLLATE Turkish_CI_AS,
    muhckskod			VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_als_iad_kod     VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_sat_iad_kod		VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_als_isk_kod     VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_sat_isk_kod		VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_als_otv_kod     VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_sat_otv_kod		VARCHAR(20) COLLATE Turkish_CI_AS,
    muh_sat_mal_kod		VARCHAR(20) COLLATE Turkish_CI_AS,
    brmcarp             float,
    brmust              VARCHAR(20) COLLATE Turkish_CI_AS,
    ykno                VARCHAR(20) COLLATE Turkish_CI_AS,
    sil                 tinyint,
    olususer			VARCHAR(100) COLLATE Turkish_CI_AS,
    olustarsaat         Datetime,
    deguser				VARCHAR(100) COLLATE Turkish_CI_AS,
    degtarsaat			Datetime,	
    dataok              Tinyint,
    acmik               float,
    Prom  				bit,
    Prom_Urun			bit,
    Prom_Kac_Satis		int,
    Prom_Sat_Tip		int,
    Prom_Sat_Puan		float,
    Puan_Brm			float,
    karoran1            float,
    karoran2			float,
    grpkdvoran			float,
    alsiademik			float,
    satiademik			float,
    brmust2				VARCHAR(20) COLLATE Turkish_CI_AS,
    brmcarp2			float,
    har_miktar			float,
    gir_miktar			float,
    cik_miktar			float,
    gir_topkdvli		float,
    gir_topkdvsiz		float,
    cik_topkdvli		float,
    cik_topkdvsiz		float,
    mev_miktar			float,
    alsiade_mik			float,
    satiade_mik			float,
    alsiade_topkdvli	float,
    satiade_topkdvli	float,
    ortals_fiykdvli		float,
    ortals_fiykdvsiz	float,
    
    alsiadesiztopmik	float,
    satiadesiztopmik	float,
    alsiadesiztoptut	float,
    satiadesiztoptut    float,
    agirorttoptut		float,
    
    satfiykdvli			float,
    satfiykdvsiz		float,
   
    sat2fiykdvli		float,
    sat2fiykdvsiz		float,
    
    sat3fiykdvli		float,
    sat3fiykdvsiz		float,
    
    sat4fiykdvli		float,
    sat4fiykdvsiz		float,
    alsfiykdvli			float,
    alsfiykdvsiz		float,
    kalsattopkdvsiz		float,
    kalsattopkdvli		float,
    kalalstopkdvsiz		float,
    kalalstopkdvli		float,
    ozel_kod1			int,
    ozel_kod2			int,
    ozel_kod1_ad    	VARCHAR(50) COLLATE Turkish_CI_AS,
    ozel_kod2_ad		VARCHAR(50) COLLATE Turkish_CI_AS,
    Gtip				VARCHAR(50) COLLATE Turkish_CI_AS,
    Yerli 				bit Default 0 ,
    UretimYerId			int Default 0,
    UretimYerAd			VARCHAR(100) COLLATE Turkish_CI_AS,
    SatisFiyat1DegisimTarih Datetime,
    SatisFiyat2DegisimTarih Datetime,
    SatisFiyat3DegisimTarih Datetime,
    SatisFiyat4DegisimTarih Datetime,
    BagliCariKod            varchar(50),
    BagliCariUnvan          varchar(250)
    PRIMARY KEY ([id])
    /* PRIMARY KEY ([id],[tip],[sil]) */
   )
AS
BEGIN


  DECLARE @TB_TEMP_STOKLIST
   TABLE (
     tip     varchar(20),
     kod     varchar(30),
     har_miktar float,
     gir_miktar   float,
     cik_miktar   float,
     gir_topkdvli  float,
     gir_topkdvsiz  float,
     cik_topkdvli   float,
     cik_topkdvsiz  float,
     mev_miktar    float,
     alsiade_mik  float, 
     satiade_mik  float,
     alsiade_topkdvli    float,
     satiade_topkdvli   float,
     ortals_fiykdvli   float,
     ortals_fiykdvsiz    float
     )
   



 declare @onda_tip  int
 
  set @onda_tip=2
 
   
     insert into @TB_STOK_LIST (id,remote_id,firmano,tip,kod,
     ad,barkod,grp1,grp2,grp3,
     sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
     sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
     sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
     sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
     alsfiy,alskdv,alskdvtip,alspbrm,
     kesft,brim,otv,eksat,
     minmik,drm,zrapor,
     Prom,Prom_Urun,Prom_Kac_Satis,
     Prom_Sat_Tip,Prom_Sat_Puan,
     Puan_Brm,
          
     muhonkod,muhgrskod,muhckskod,
     muh_als_iad_kod,muh_sat_iad_kod,
     muh_als_isk_kod,muh_sat_isk_kod,
     muh_als_otv_kod,muh_sat_otv_kod,
     muh_sat_mal_kod,brmcarp,brmust,ykno,
     sil,olususer,olustarsaat,
     deguser,degtarsaat,dataok,
     acmik,karoran1,karoran2,grpkdvoran,
     alsiademik,satiademik,brmust2,brmcarp2, 
     ozel_kod1,ozel_kod2,Gtip,Yerli,UretimYerId,
     SatisFiyat1DegisimTarih,SatisFiyat2DegisimTarih,
     SatisFiyat3DegisimTarih,SatisFiyat4DegisimTarih,
     BagliCariKod)
       select id,remote_id,firmano,tip,kod,
       ad,barkod,grp1,grp2,grp3,
       sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
       sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
       sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
       sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
       alsfiy,alskdv,alskdvtip,alspbrm,
       kesft,brim,otv,eksat,
       minmik,drm,zrapor,
       Prom,Prom_Urun,Prom_Kac_Satis,
       Prom_Sat_Tip,Prom_Sat_Puan,
       Puan_Brm,
       muhonkod,muhgrskod,muhckskod,
       muh_als_iad_kod,muh_sat_iad_kod,
       muh_als_isk_kod,muh_sat_isk_kod,
       muh_als_otv_kod,muh_sat_otv_kod,
       muh_sat_mal_kod,brmcarp,brmust,ykno,
       sil,olususer,olustarsaat,
       deguser,degtarsaat,dataok,
       acmik,karoran1,karoran2,grpkdvoran,
       alsiademik,satiademik,brmust2,brmcarp2, 
       ozel_kod1,ozel_kod2,Gtip,Yerli,UretimYerId,
       SatisFiyat1DegisimTarih,SatisFiyat2DegisimTarih,
       SatisFiyat3DegisimTarih,SatisFiyat4DegisimTarih,
       BagliCariKod
        from stokkart with (NOLOCK) where tip=@tip 
        
  
   if @Depo_kod<>'' 
   insert @TB_TEMP_STOKLIST (tip,kod,har_miktar,gir_miktar,cik_miktar,gir_topkdvli,gir_topkdvsiz,
   cik_topkdvli,cik_topkdvsiz,mev_miktar,alsiade_mik,satiade_mik,alsiade_topkdvli,satiade_topkdvli,
   ortals_fiykdvli,ortals_fiykdvsiz )
   select stktip,stkod,har_miktar,
      gir_miktar,cik_miktar,gir_topkdvli,gir_topkdvsiz,
      cik_topkdvli,cik_topkdvsiz,mev_miktar,
      alsiade_mik,alsiade_topkdvli,satiade_mik,
      satiade_topkdvli,ortals_fiykdvli,
      ortals_fiykdvsiz
      from StokDepoDurum as Mk with (nolock)
      where mk.stktip=@tip and  mk.depkod=@Depo_kod 
  
    if @firmano<>''
     insert @TB_TEMP_STOKLIST (tip,kod,har_miktar,gir_miktar,cik_miktar,gir_topkdvli,gir_topkdvsiz,
      cik_topkdvli,cik_topkdvsiz,mev_miktar,alsiade_mik,satiade_mik,alsiade_topkdvli,satiade_topkdvli,
      ortals_fiykdvli,ortals_fiykdvsiz )
      select stktip,stkod,har_miktar,
      gir_miktar,cik_miktar,gir_topkdvli,gir_topkdvsiz,
      cik_topkdvli,cik_topkdvsiz,mev_miktar,
      alsiade_mik,alsiade_topkdvli,satiade_mik,
      satiade_topkdvli,ortals_fiykdvli,
      ortals_fiykdvsiz
      from StokFirmaDurum as Mk with (nolock)
      where mk.stktip=@tip and mk.firmano in (Select * From CsvToInt(@firmano))

    
 
     
     update @TB_STOK_LIST
     set har_miktar=dt.har_miktar,
     gir_miktar=dt.gir_miktar,
     cik_miktar=dt.cik_miktar,
     gir_topkdvli=dt.gir_topkdvli,
     gir_topkdvsiz=dt.gir_topkdvsiz,
     cik_topkdvli=dt.cik_topkdvli,
     cik_topkdvsiz=dt.cik_topkdvsiz,
     mev_miktar=isnull(dt.mev_miktar,0),
     alsiade_mik=dt.alsiade_mik, /*alsiademik */
     satiade_mik=dt.satiade_mik,  /*satiademik */
     alsiade_topkdvli=dt.alsiade_topkdvli,
     satiade_topkdvli=dt.satiade_topkdvli,
     ortals_fiykdvli=dt.ortals_fiykdvli,
     ortals_fiykdvsiz=dt.ortals_fiykdvsiz
     from @TB_STOK_LIST as t join ( 
     select 
      tip,kod,sum(har_miktar) har_miktar,
      sum(gir_miktar) gir_miktar ,sum(cik_miktar)cik_miktar,
      sum(gir_topkdvli) gir_topkdvli,sum(gir_topkdvsiz) gir_topkdvsiz,
      sum(cik_topkdvli) cik_topkdvli,sum(cik_topkdvsiz) cik_topkdvsiz,
      sum(mev_miktar) mev_miktar,Sum(alsiade_mik) alsiade_mik,
      sum(alsiade_topkdvli) alsiade_topkdvli ,Sum(satiade_mik) satiade_mik, 
      sum(satiade_topkdvli) satiade_topkdvli,
      avg(ortals_fiykdvli) ortals_fiykdvli, avg(ortals_fiykdvsiz) ortals_fiykdvsiz
      from @TB_TEMP_STOKLIST as Mk group by Tip,Kod ) dt on
       dt.tip=t.tip and dt.kod=t.kod  
      
   
 
    update @TB_STOK_LIST
     set har_miktar=isnull(har_miktar,0),
     gir_miktar=isnull(gir_miktar,0),
     cik_miktar=isnull(cik_miktar,0),
     gir_topkdvli=isnull(gir_topkdvli,0),
     gir_topkdvsiz=isnull(gir_topkdvsiz,0),
     cik_topkdvli=isnull(cik_topkdvli,0),
     cik_topkdvsiz=isnull(cik_topkdvsiz,0),
     mev_miktar=isnull(mev_miktar,0),
     alsiade_mik=isnull(alsiade_mik,0), 
     satiade_mik=isnull(satiade_mik,0),
     alsiade_topkdvli=isnull(alsiade_topkdvli,0),
     satiade_topkdvli=isnull(satiade_topkdvli,0),
     ortals_fiykdvli=isnull(ortals_fiykdvli,0),
     ortals_fiykdvsiz=isnull(ortals_fiykdvsiz,0)
     
     
   update @TB_STOK_LIST
   set
   alsiadesiztopmik=(gir_miktar-(satiade_mik+alsiade_mik)),
   satiadesiztopmik=(cik_miktar-(satiade_mik+alsiade_mik)) ,
   alsiadesiztoptut=(gir_miktar-(satiade_mik+alsiade_mik))*(alsfiy) ,
   satiadesiztoptut=(cik_miktar-(satiade_mik+alsiade_mik))*
    (case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end ),
    agirorttoptut=(mev_miktar)*(ortals_fiykdvli) ,
  
   satfiykdvli=case when sat1kdvtip='Dahil' then sat1fiy else sat1fiy*(1+(sat1kdv/100)) end,
   satfiykdvsiz=case when sat1kdvtip='Hariç' then sat1fiy else sat1fiy/(1+(sat1kdv/100)) end ,
   
   sat2fiykdvli=case when sat2kdvtip='Dahil' then sat2fiy else sat2fiy*(1+(sat2kdv/100)) end,
   sat2fiykdvsiz=case when sat2kdvtip='Hariç' then sat2fiy else sat2fiy/(1+(sat2kdv/100)) end ,

   sat3fiykdvli=case when sat3kdvtip='Dahil' then sat3fiy else sat3fiy*(1+(sat3kdv/100)) end,
   sat3fiykdvsiz=case when sat3kdvtip='Hariç' then sat3fiy else sat3fiy/(1+(sat3kdv/100)) end ,

   sat4fiykdvli=case when sat4kdvtip='Dahil' then sat4fiy else sat4fiy*(1+(sat4kdv/100)) end,
   sat4fiykdvsiz=case when sat4kdvtip='Hariç' then sat4fiy else sat4fiy/(1+(sat4kdv/100)) end ,
   
   
   alsfiykdvli=case when alskdvtip='Dahil' then alsfiy else alsfiy*(1+(alskdv/100)) end ,
   alsfiykdvsiz=case when alskdvtip='Hariç' then alsfiy else alsfiy/(1+(alskdv/100)) end ,

   kalsattopkdvsiz=case when sat1kdvtip='Hariç' then (mev_miktar)*sat1fiy
   else (mev_miktar)*(sat1fiy/(1+(sat1kdv/100))) end ,
   kalsattopkdvli=case when sat1kdvtip='Dahil' then (mev_miktar)*sat1fiy
   else (mev_miktar)*(sat1fiy*(1+(sat1kdv/100))) end ,
   kalalstopkdvsiz=case when alskdvtip='Hariç' then (mev_miktar)*alsfiy
   else (mev_miktar)*(alsfiy/(1+(alskdv/100))) end,
   kalalstopkdvli=case when alskdvtip='Dahil' then (mev_miktar)*alsfiy
   else (mev_miktar)*(alsfiy*(1+(alskdv/100))) end
    
   
   update @TB_STOK_LIST set 
   ozel_kod1_ad=o.ad
   from @TB_STOK_LIST inner join Ozel_Kod as o on 
   ozel_kod1=o.id
     
   update @TB_STOK_LIST set 
   ozel_kod2_ad=o.ad
   from @TB_STOK_LIST inner join Ozel_Kod as o on 
   ozel_kod2=o.id
   
   
   update @TB_STOK_LIST set 
   grup=g.ad
   from @TB_STOK_LIST  as s
   left join grup as g  on g.id=case when s.grp3>0 then s.grp3
   when s.grp2>0 then s.grp2
   when s.grp1>0 then s.grp1 end 
   
   
   update @TB_STOK_LIST set 
   UretimYerAd=g.ad
   from @TB_STOK_LIST  as s
   left join UlkeList as g  on g.Id=s.UretimYerId 
   
   
   update @TB_STOK_LIST set 
   BagliCariUnvan=g.Unvan
   from @TB_STOK_LIST  as s
   left join carikart as g  on g.Kod=s.BagliCariKod  
   
 
 RETURN


END

================================================================================
