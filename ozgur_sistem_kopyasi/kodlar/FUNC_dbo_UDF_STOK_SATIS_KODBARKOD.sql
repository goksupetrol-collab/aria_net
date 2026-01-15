-- Function: dbo.UDF_STOK_SATIS_KODBARKOD
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.771121
================================================================================

CREATE FUNCTION dbo.UDF_STOK_SATIS_KODBARKOD (
@FirmaNo   	int,
@DepoKod   	varchar(50),
@AraTip		varchar(10),
@StokTip   	varchar(10),
@StokKod    varchar(50),
@StokBarkod varchar(50)
)
RETURNS
    @TB_STOK_SATIS TABLE (
    STOK_FIRMANO         INT,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_ID              INT,
    STOK_BARKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD             VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_AD              VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_MINMIKTAR		 FLOAT,
    STOK_CARPAN 		 FLOAT,
    STOK_TERAZI 		 INT,
    STOK_BRIMCARPAN		 FLOAT,
    STOK_MEVCUTMIKTAR    FLOAT,
    STOK_SAYIM  		 INT,
    STOK_EKSISATIS       INT,
    STOK_RECETELI        bit default 0,
    STOK_GTIP            varchar(20),
    STOK_BEDELSIZ        BIT DEFAULT 0,
    STOK_SATIS1FIYAT     FLOAT DEFAULT 0,
    STOK_SATIS1PBRMKOD   VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_SATIS2FIYAT     FLOAT DEFAULT 0,
    STOK_SATIS2PBRMKOD   VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_SATIS3FIYAT     FLOAT DEFAULT 0,
    STOK_SATIS3PBRMKOD   VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_SATIS4FIYAT     FLOAT DEFAULT 0,
    STOK_SATIS4PBRMKOD   VARCHAR(20) COLLATE Turkish_CI_AS,
    
    STOK_YKNO            VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_GRP1ID          int,
    STOK_BRM			 VARCHAR(20) COLLATE Turkish_CI_AS,	
    STOK_KDV             FLOAT DEFAULT 0)
BEGIN

    declare @UrunId   int 


   if @AraTip='stkkod'
    insert @TB_STOK_SATIS (STOK_FIRMANO,STOK_TIP,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,
    STOK_MINMIKTAR,STOK_CARPAN,STOK_TERAZI,STOK_BRIMCARPAN,
    STOK_YKNO,STOK_GRP1ID,STOK_BRM,STOK_KDV,
    STOK_MEVCUTMIKTAR,STOK_SAYIM,STOK_EKSISATIS,STOK_GTIP)
    select k.firmano,@StokTip,K.id,k.barkod,k.kod,k.ad,k.minmik,1 as carpan,
    (0) as TERAZI,k.brmcarp,
    k.ykno,k.grp1,k.brim,k.sat1kdv,
    dbo.stoksonmik(@DepoKod,k.tip,k.kod) as kalanmiktar,
    dbo.sayimvarmi(@FirmaNo,@DepoKod,k.tip,k.kod) as sayim,
    case when k.eksat='Evet' then 1 else 0 end,isnull(k.gtip,'') 
    from stokkart as k with (nolock) 
    where k.sil=0 and k.drm='Aktif' and k.tip=@StokTip and K.Kod=@StokKod
    
    
   if @AraTip='barkod'
    insert @TB_STOK_SATIS (STOK_FIRMANO,STOK_TIP,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,
    STOK_MINMIKTAR,STOK_CARPAN,STOK_TERAZI,STOK_BRIMCARPAN,
    STOK_YKNO,STOK_GRP1ID,STOK_BRM,STOK_KDV,
    STOK_MEVCUTMIKTAR,STOK_SAYIM,STOK_EKSISATIS,STOK_GTIP,STOK_BEDELSIZ)
     
    select STOK_FIRMANO,@StokTip,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,
    STOK_MIN,CARPAN,TERAZI,CARPAN,
    k.ykno,k.grp1,k.brim,k.sat1kdv,
    dbo.stoksonmik(@DepoKod,STOK_TIP,STOK_KOD) as kalanmiktar,
    dbo.sayimvarmi(@FirmaNo,@DepoKod,STOK_TIP,STOK_KOD) as sayim,
    case when STOK_EKSISAT='Evet' then 1 else 0 end,
    isnull(STOK_GTIP,''),STOK_BEDELSIZ from TERAZI_BARKOD_GETIR (@StokTip,@StokBarkod) as b
    inner join stokkart as k with (nolock) on k.id=b.STOK_ID

    
    select @UrunId=STOK_ID from @TB_STOK_SATIS 

    if isnull(@UrunId,0)>0
       if EXISTS(Select id From Stok_Recete Where Urun_id=@UrunId and Sil=0 )
         update @TB_STOK_SATIS Set STOK_RECETELI=1



    /*Fiyat bilgisi eklenecek */
    declare @Market_Sube   bit
    select @Market_Sube=isnull(Market_Sube,0) from sistemtanim
    
     if @Market_Sube=0
     begin
       update @TB_STOK_SATIS set 
       STOK_SATIS1FIYAT=case when sat1kdvtip='Dahil' then round(sat1fiy,2) else round(sat1fiy*(1+(sat1kdv/100)),2) end,
       STOK_SATIS1PBRMKOD=sat1pbrm,
       STOK_SATIS2FIYAT=case when sat2kdvtip='Dahil' then round(sat2fiy,2) else round(sat2fiy*(1+(sat2kdv/100)),2) end,
       STOK_SATIS2PBRMKOD=sat2pbrm,
       STOK_SATIS3FIYAT=case when sat3kdvtip='Dahil' then round(sat3fiy,2) else round(sat3fiy*(1+(sat3kdv/100)),2) end,
       STOK_SATIS3PBRMKOD=sat3pbrm,
       STOK_SATIS4FIYAT=case when sat4kdvtip='Dahil' then round(sat4fiy,2) else round(sat4fiy*(1+(sat4kdv/100)),2) end,
       STOK_SATIS4PBRMKOD=sat4pbrm
       from stokkart where id=@UrunId
     end
     
     
    if @Market_Sube=1
     begin
     
       update @TB_STOK_SATIS  set 
       STOK_SATIS1FIYAT=dt.Fiyat,
       STOK_SATIS1PBRMKOD=dt.ParaBrm
        from @TB_STOK_SATIS as t join 
       (select Stk_id,ParaBrm, case when kdvtip=1 then round(fiyat,2) else round(fiyat*(1+(kdv/100)),2) end as Fiyat
       from Stok_Fiyat with (nolock) Where Stk_id=@UrunId and FiyNo=1 and FiyTip=2 and Firmano=@FirmaNo ) dt
       on dt.Stk_id=t.STOK_ID
       
       
       update @TB_STOK_SATIS  set 
       STOK_SATIS2FIYAT=dt.Fiyat,
       STOK_SATIS2PBRMKOD=dt.ParaBrm
        from @TB_STOK_SATIS as t join 
       (select Stk_id,ParaBrm, case when kdvtip=1 then round(fiyat,2) else round(fiyat*(1+(kdv/100)),2) end as Fiyat
       from Stok_Fiyat with (nolock) Where Stk_id=@UrunId and FiyNo=2 and FiyTip=2 and Firmano=@FirmaNo ) dt
       on dt.Stk_id=t.STOK_ID
       
       
       
        update @TB_STOK_SATIS  set 
       STOK_SATIS3FIYAT=dt.Fiyat,
       STOK_SATIS3PBRMKOD=dt.ParaBrm
        from @TB_STOK_SATIS as t join 
       (select Stk_id,ParaBrm, case when kdvtip=1 then round(fiyat,2) else round(fiyat*(1+(kdv/100)),2) end as Fiyat
       from Stok_Fiyat with (nolock) Where Stk_id=@UrunId and FiyNo=3 and FiyTip=2 and Firmano=@FirmaNo ) dt
       on dt.Stk_id=t.STOK_ID
       
       
        update @TB_STOK_SATIS  set 
       STOK_SATIS4FIYAT=dt.Fiyat,
       STOK_SATIS4PBRMKOD=dt.ParaBrm
        from @TB_STOK_SATIS as t join 
       (select Stk_id,ParaBrm, case when kdvtip=1 then round(fiyat,2) else round(fiyat*(1+(kdv/100)),2) end as Fiyat
       from Stok_Fiyat with (nolock) Where Stk_id=@UrunId and FiyNo=4 and FiyTip=2 and Firmano=@FirmaNo ) dt
       on dt.Stk_id=t.STOK_ID
       

     end
     

    
    return
    
    
END

================================================================================
