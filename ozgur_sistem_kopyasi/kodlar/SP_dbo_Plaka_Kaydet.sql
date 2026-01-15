-- Stored Procedure: dbo.Plaka_Kaydet
-- Tarih: 2026-01-14 20:06:08.353142
================================================================================

CREATE PROCEDURE [dbo].Plaka_Kaydet
(@firmano    int,
@cartip 	varchar(20),
@carkod 	varchar(20),
@plaka 		varchar(30),
@userad  	varchar(50))
AS
BEGIN
declare @say           int
declare @limit         float
declare @limit_tip     varchar(20)
declare @limit_harlt   float
declare @limit_hartut  float


  if @plaka=''
    return
  
  select @say=isnull(count(*),0),
  @limit=isnull(limit,0),
  @limit_tip=isnull(limitturu,'')
  from otomasgenkod  with (nolock) where cartip=@cartip and kod=@carkod
  and plaka=@plaka 
  group by isnull(limit,0),isnull(limitturu,'')
  
  
  
  set @say=isnull(@say,0)
  set @limit=isnull(@limit,0)
  set @limit_tip=isnull(@limit_tip,'')
  
  
  
  if @say=0
   begin
    insert into otomasgenkod (firmano,cartip,kod,plaka,otomaskod,
    olususer,olustarsaat)
    select @firmano,@cartip,@carkod,@plaka,'',@userad,getdate()
   end

  


  DECLARE @TB_PLAKA_LIMIT TABLE (
  CAR_TIP         VARCHAR(20),
  CAR_KOD         VARCHAR(50),
  LIMIT_TIP       VARCHAR(20),
  LIMIT           FLOAT,
  LIMIT_KUL       FLOAT )
  
  
  if @say>0
   begin
    if @limit=0
     return

   /*degerler alınıyor.. */
    select @limit_harlt=isnull(sum(miktarlt),0),
    @limit_hartut=isnull(sum(lttutar),0) from _Plaka_Limit_Miktar as l with (nolock)
    where l.cartip=@cartip and l.carkod=@carkod
    and l.plaka=@plaka
    group by l.cartip,l.carkod
    
    if (@limit_tip='Litre') /*and @limit<@limit_harlt */
    insert into @TB_PLAKA_LIMIT (CAR_TIP,CAR_KOD,LIMIT_TIP,LIMIT,LIMIT_KUL)
    select  @cartip,@carkod,@limit_tip,@limit,@limit_harlt
    
    if (@limit_tip='Tutar') /*and @limit<@limit_hartut */
    insert into @TB_PLAKA_LIMIT (CAR_TIP,CAR_KOD,LIMIT_TIP,LIMIT,LIMIT_KUL)
    select  @cartip,@carkod,@limit_tip,@limit,@limit_hartut

    
   
   
   end
  

  SELECT * FROM @TB_PLAKA_LIMIT


END

================================================================================
