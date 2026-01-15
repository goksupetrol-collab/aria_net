-- Function: dbo.UDF_STOK_BARKOD
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.768835
================================================================================

CREATE  FUNCTION UDF_STOK_BARKOD (
@firmano int,
@stokin VARCHAR(8000),
@tip VARCHAR(30),
@bassayi int,
@satirsayi int,
@FiyatSec int)
RETURNS
  @TB_BARKOD TABLE (
    STOK_KOD        VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(100) COLLATE Turkish_CI_AS,
    BARKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    EAN             INT,
    SATISFIYATKDVLI FLOAT,
    SATPARABIRIM    VARCHAR(10) COLLATE Turkish_CI_AS,
    SATISFIYATDEGISIMTARIH  DATETIME,
    SATISBIRIMFIYATKDVLI FLOAT,
    SATISOLCUMBIRIM      VARCHAR(20) COLLATE Turkish_CI_AS,
    
    /*SATISFIYATKDVLI2 FLOAT,
    SATPARABIRIM2    VARCHAR(10) COLLATE Turkish_CI_AS,
    SATISFIYATDEGISIMTARIH2  DATETIME,
    SATISFIYATKDVLI3 FLOAT,
    SATPARABIRIM3    VARCHAR(10) COLLATE Turkish_CI_AS,
    SATISFIYATDEGISIMTARIH3  DATETIME,
    */
    SATISFIYATKDVLI4 FLOAT,
    SATPARABIRIM4    VARCHAR(10) COLLATE Turkish_CI_AS,
    SATISFIYATDEGISIMTARIH4  DATETIME,
    SATISBIRIMFIYATKDVLI4 FLOAT,
    YERLI			     BIT DEFAULT 0,
    URETIMYERID			 INT DEFAULT 0,
    URETIMYERAD			VARCHAR(100) COLLATE Turkish_CI_AS,
    KALANMIKTAR FLOAT   DEFAULT 0
    )
AS
BEGIN

  DECLARE @HRK_STOK_KOD    VARCHAR(30)
  DECLARE @HRK_STOK_AD     VARCHAR(50)
  DECLARE @HRK_BARKOD      VARCHAR(20)
  DECLARE @HRK_EAN         INT
  
  DECLARE @HRK_SATISFKDVLI1 FLOAT
  DECLARE @HRK_SATPBRM1     VARCHAR(8)
  DECLARE @HRK_SATISDEGISIMTARIH1 DATETIME
  
  DECLARE @HRK_SATISFKDVLI2 FLOAT
  DECLARE @HRK_SATPBRM2     VARCHAR(8)
  DECLARE @HRK_SATISDEGISIMTARIH2 DATETIME
  
  DECLARE @HRK_SATISFKDVLI3 FLOAT
  DECLARE @HRK_SATPBRM3     VARCHAR(8)
  DECLARE @HRK_SATISDEGISIMTARIH3 DATETIME
  
  DECLARE @HRK_SATISFKDVLI4 FLOAT
  DECLARE @HRK_SATPBRM4     VARCHAR(8)
  DECLARE @HRK_SATISDEGISIMTARIH4 DATETIME
  
  DECLARE @HRK_URETIMYERID     INT
  DECLARE @HRK_YERLI           BIT
  
  
  DECLARE @HRK_OLCUMBIRIMID     INT
  DECLARE @HRK_OLCUMBIRIMCARPAN FLOAT
  
  
  Declare @MarketSubeFiyat Bit
  
  Select top 1 @MarketSubeFiyat=Market_Sube From SistemTanim
  
  
  
  DECLARE @i               INT
  DECLARE @HRK_ONSTOK_KOD  VARCHAR(30)


 DECLARE @EKSTRE_TEMP TABLE (
 stokid      int)
 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@stokin)) > 0)
 BEGIN
  set @stokin = @stokin + ','
 END

 while patindex('%,%' , @stokin) <> 0
 begin

   select @separator_position =  patindex('%,%' , @stokin)
   select @array_value = left(@stokin, @separator_position - 1)

  Insert @EKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @stokin = stuff(@stokin, 1, @separator_position, '')
 end


   SET @HRK_ONSTOK_KOD=''

  if isnull(@MarketSubeFiyat,0)=0
   DECLARE BARKOD_HRK CURSOR FAST_FORWARD FOR
    SELECT
    st.kod,st.ad,MIN(bd.BARKOD),LEN(MIN(bd.BARKOD)),
    case when sat1kdvtip='Dahil' then sat1fiy
    else sat1fiy*(1+(sat1kdv/100)) end,
    sat1pbrm AS SATPARABIRIM,
    case when sat2kdvtip='Dahil' then sat2fiy
    else sat2fiy*(1+(sat2kdv/100)) end,
    sat2pbrm AS SATPARABIRIM,
    case when sat3kdvtip='Dahil' then sat3fiy
    else sat3fiy*(1+(sat3kdv/100)) end,
    sat3pbrm AS SATPARABIRIM,
    case when sat4kdvtip='Dahil' then sat4fiy
    else sat4fiy*(1+(sat4kdv/100)) end,
    sat4pbrm AS SATPARABIRIM,
    st.Yerli,st.UretimYerId,
    st.SatisFiyat1DegisimTarih,st.SatisFiyat2DegisimTarih,
    st.SatisFiyat3DegisimTarih,st.SatisFiyat4DegisimTarih,
    st.OlcumBirimId,isnull(st.OlcumBirimCarpan,0) OlcumBirimCarpan 
    from stokkart as st with (nolock)
    inner join barkod bd with (nolock) on bd.kod=st.kod and bd.tip=st.tip
    where st.sil=0 and bd.sil=0 and st.tip=@tip and bd.master=1
    and st.id IN (SELECT * FROM @EKSTRE_TEMP )
    group by st.kod,st.ad,
    sat1kdvtip,sat1fiy,sat1pbrm,sat1kdv,
    sat2kdvtip,sat2fiy,sat2pbrm,sat2kdv,
    sat3kdvtip,sat3fiy,sat3pbrm,sat3kdv,
    sat4kdvtip,sat4fiy,sat4pbrm,sat4kdv,
    st.Yerli,st.UretimYerId,
    st.SatisFiyat1DegisimTarih,st.SatisFiyat2DegisimTarih,
    st.SatisFiyat3DegisimTarih,st.SatisFiyat4DegisimTarih,
    st.OlcumBirimId,st.OlcumBirimCarpan
    order by st.kod
    
    
   if isnull(@MarketSubeFiyat,0)=1
    begin
    
      Declare @TB_STOK_FIYAT TABLE (
      FirmaNo			int,
      Stktip_id    	tinyint,
      Stk_id     		int,
      SatisFiyat1      		Float,
      SatisFiyat2      		Float,
      SatisFiyat3      		Float,
      SatisFiyat4      		Float,
      SatisFiyat1DegisimTarih  datetime,
      SatisFiyat2DegisimTarih  datetime,
      SatisFiyat3DegisimTarih  datetime,
      SatisFiyat4DegisimTarih  datetime,
     
      ParaBrm			VARCHAR(20) COLLATE Turkish_CI_AS)
      
      
       /*Satış Fiyat 1  */
       insert @TB_STOK_FIYAT (FirmaNo,Stktip_id,Stk_id,SatisFiyat1,ParaBrm,
       SatisFiyat1DegisimTarih) 
       Select FirmaNo,Stktip_id,Stk_id,
       SatisFiyat1=case 
       when Kdvtip=1 then Fiyat 
       when Kdvtip=0 then Fiyat*(1+(Kdv/100))
       end,
       ParaBrm,FiyatDegisimTarih  
       from Stok_Fiyat with (nolock) 
       where Firmano=@Firmano and Stktip_id=2 
       and FiyTip=2 and FiyNo=1
       
       
       /*Satış Fiyat 2 */
       update  @TB_STOK_FIYAT set  SatisFiyat2=Dt.Fiyat,
       SatisFiyat2DegisimTarih=dt.FiyatDegisimTarih From @TB_STOK_FIYAT as t 
       join (Select FirmaNo,Stktip_id,Stk_id,FiyatDegisimTarih,
       Fiyat=case 
       when Kdvtip=1 then Fiyat 
       when Kdvtip=0 then Fiyat*(1+(Kdv/100))
       end
       from Stok_Fiyat with (nolock)
       where Firmano=@Firmano and Stktip_id=2 
       and FiyTip=2 and FiyNo=2) dt on t.Stktip_id=Dt.Stktip_id
       and t.Stk_id=dt.Stk_id 
       
      
      
      /*Satış Fiyat 3 */
       update  @TB_STOK_FIYAT set SatisFiyat3=Dt.Fiyat,
       SatisFiyat3DegisimTarih=dt.FiyatDegisimTarih From @TB_STOK_FIYAT as t 
       join (Select FirmaNo,Stktip_id,Stk_id,FiyatDegisimTarih,
       Fiyat=case 
       when Kdvtip=1 then Fiyat 
       when Kdvtip=0 then Fiyat*(1+(Kdv/100))
       end
       from Stok_Fiyat with (nolock)
       where Firmano=@Firmano and Stktip_id=2 
       and FiyTip=2 and FiyNo=3) dt on t.Stktip_id=Dt.Stktip_id
       and t.Stk_id=dt.Stk_id 
      
       /*Satış Fiyat 4 */
       update  @TB_STOK_FIYAT set SatisFiyat4=Dt.Fiyat,
       SatisFiyat4DegisimTarih=dt.FiyatDegisimTarih From @TB_STOK_FIYAT as t 
       join (Select FirmaNo,Stktip_id,Stk_id,FiyatDegisimTarih,
       Fiyat=case 
       when Kdvtip=1 then Fiyat 
       when Kdvtip=0 then Fiyat*(1+(Kdv/100))
       end
       from Stok_Fiyat with (nolock)
       where Firmano=@Firmano and Stktip_id=2 
       and FiyTip=2 and FiyNo=4) dt on t.Stktip_id=Dt.Stktip_id
       and t.Stk_id=dt.Stk_id 
      
     
      DECLARE BARKOD_HRK CURSOR FAST_FORWARD FOR
      SELECT
      st.kod,st.ad,MIN(bd.BARKOD),LEN(MIN(bd.BARKOD)),
      fiy.SatisFiyat1,
      sat1pbrm AS SATPARABIRIM,
      fiy.SatisFiyat2,
      sat2pbrm AS SATPARABIRIM,
      fiy.SatisFiyat3,
      sat3pbrm AS SATPARABIRIM,
      fiy.SatisFiyat4,
      sat4pbrm AS SATPARABIRIM,
      st.Yerli,st.UretimYerId,
      fiy.SatisFiyat1DegisimTarih,fiy.SatisFiyat2DegisimTarih,
      fiy.SatisFiyat3DegisimTarih,fiy.SatisFiyat4DegisimTarih,
      st.OlcumBirimId,isnull(st.OlcumBirimCarpan,0) OlcumBirimCarpan
      from stokkart as st with (nolock)
      inner join @TB_STOK_FIYAT as fiy on fiy.Stk_id=st.id
      inner join barkod bd with (nolock) on bd.kod=st.kod and bd.tip=st.tip
      where st.sil=0 and bd.sil=0 and st.tip=@tip and bd.master=1
      and st.id IN (SELECT * FROM @EKSTRE_TEMP )
      group by st.kod,st.ad,
      SatisFiyat1,sat1pbrm,
      SatisFiyat2,sat2pbrm,
      SatisFiyat3,sat3pbrm,
      SatisFiyat4,sat4pbrm,
      st.Yerli,st.UretimYerId,
      fiy.SatisFiyat1DegisimTarih,fiy.SatisFiyat2DegisimTarih,
      fiy.SatisFiyat3DegisimTarih,fiy.SatisFiyat4DegisimTarih,
      st.OlcumBirimId,st.OlcumBirimCarpan
      order by st.kod  
   end  
    
    

    OPEN BARKOD_HRK
    FETCH NEXT FROM BARKOD_HRK INTO
    @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_BARKOD,@HRK_EAN,
    @HRK_SATISFKDVLI1,@HRK_SATPBRM1,
    @HRK_SATISFKDVLI2,@HRK_SATPBRM2,
    @HRK_SATISFKDVLI3,@HRK_SATPBRM3,
    @HRK_SATISFKDVLI4,@HRK_SATPBRM4,
    @HRK_YERLI,@HRK_URETIMYERID,
    @HRK_SATISDEGISIMTARIH1,@HRK_SATISDEGISIMTARIH2,
    @HRK_SATISDEGISIMTARIH3,@HRK_SATISDEGISIMTARIH4,
    @HRK_OLCUMBIRIMID,@HRK_OLCUMBIRIMCARPAN
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    IF @HRK_ONSTOK_KOD<>@HRK_STOK_KOD
    begin
    set @HRK_ONSTOK_KOD=@HRK_STOK_KOD
    set @i=1
    end

     while @i<=@satirsayi
     begin
     
     
    
     
     INSERT @TB_BARKOD SELECT
        @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_BARKOD,@HRK_EAN,
        case 
        when @FiyatSec=1 then round(@HRK_SATISFKDVLI1,2)
        when @FiyatSec=2 then round(@HRK_SATISFKDVLI2,2)
        when @FiyatSec=3 then round(@HRK_SATISFKDVLI3,2)
        when @FiyatSec=4 then round(@HRK_SATISFKDVLI4,2) end,
        case
        when @FiyatSec=1 then @HRK_SATPBRM1
        when @FiyatSec=2 then @HRK_SATPBRM2
        when @FiyatSec=3 then @HRK_SATPBRM3
        when @FiyatSec=4 then @HRK_SATPBRM4 end, 
        case 
        when @FiyatSec=1 then @HRK_SATISDEGISIMTARIH1
        when @FiyatSec=2 then @HRK_SATISDEGISIMTARIH2
        when @FiyatSec=3 then @HRK_SATISDEGISIMTARIH3
        when @FiyatSec=4 then @HRK_SATISDEGISIMTARIH4 end,
        @HRK_OLCUMBIRIMCARPAN,
        
        case 
        when @HRK_OLCUMBIRIMID=0 then ''
        when @HRK_OLCUMBIRIMID=1 then 'KG'
        when @HRK_OLCUMBIRIMID=2 then 'LT' end, 
             
        round(@HRK_SATISFKDVLI4,2),
        @HRK_SATPBRM4,
        @HRK_SATISDEGISIMTARIH4,
        @HRK_OLCUMBIRIMCARPAN, 
        
        
        @HRK_YERLI,@HRK_URETIMYERID,'',0
         
      
        
        
      set @i=@i+1
      end

     FETCH NEXT FROM BARKOD_HRK INTO
       @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_BARKOD,@HRK_EAN,
       @HRK_SATISFKDVLI1,@HRK_SATPBRM1,
      @HRK_SATISFKDVLI2,@HRK_SATPBRM2,
      @HRK_SATISFKDVLI3,@HRK_SATPBRM3,
      @HRK_SATISFKDVLI4,@HRK_SATPBRM4,
      @HRK_YERLI,@HRK_URETIMYERID,
      @HRK_SATISDEGISIMTARIH1,@HRK_SATISDEGISIMTARIH2,
      @HRK_SATISDEGISIMTARIH3,@HRK_SATISDEGISIMTARIH4,
      @HRK_OLCUMBIRIMID,@HRK_OLCUMBIRIMCARPAN
     END

    CLOSE BARKOD_HRK
    DEALLOCATE BARKOD_HRK

   
   
    UPDATE @TB_BARKOD SET 
    SATISBIRIMFIYATKDVLI=
    case when SATISBIRIMFIYATKDVLI>0 then 
    round(SATISFIYATKDVLI/SATISBIRIMFIYATKDVLI,2)
    else SATISFIYATKDVLI end,       
    SATISBIRIMFIYATKDVLI4=
    case when SATISBIRIMFIYATKDVLI4>0 then 
    round(SATISFIYATKDVLI4/SATISBIRIMFIYATKDVLI4,2)
    else SATISFIYATKDVLI4 end
    
    
    
    update @TB_BARKOD set KALANMIKTAR=mev_miktar from @TB_BARKOD as t 
    join (select Kod,tip,mev_miktar from Bakiye_Stok_Miktar as Ul WITH (NOLOCK) ) dt
    on t.STOK_KOD=dt.kod and dt.tip=@tip
    
        
    
    update @TB_BARKOD set URETIMYERAD=dt.ad from @TB_BARKOD as t 
    join (select Id,Ad from  UlkeList as Ul WITH (NOLOCK) ) dt
    on dt.Id=t.URETIMYERID
    
    
     delete from @TB_BARKOD where  (SATISFIYATDEGISIMTARIH is null or
     URETIMYERAD='') 
     
    
    
    

  RETURN

END

================================================================================
