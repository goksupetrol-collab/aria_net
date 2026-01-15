-- Stored Procedure: dbo.Vardiya_Kasa_Kapat
-- Tarih: 2026-01-14 20:06:08.387234
================================================================================

CREATE  PROCEDURE [dbo].Vardiya_Kasa_Kapat (
@yertip varchar(20),
@varno float)
AS
BEGIN
  
  DECLARE @HRK_KASKOD      VARCHAR(30)
  DECLARE @HRK_BAKIYE      FLOAT
  DECLARE @HRK_FIRMANO      FLOAT
  DECLARE @HRK_KUR         FLOAT
  DECLARE @VAR_TARIH	   DATETIME
  DECLARE @VAR_SAAT		   VARCHAR(10)
  DECLARE @VAR_USER        VARCHAR(50)
  DECLARE @YER_AD          VARCHAR(50)
  DECLARE @PARA_BRM        VARCHAR(10)

  DECLARE @newid           FLOAT
  DECLARE @giren           FLOAT
  DECLARE @cikan           FLOAT
  DECLARE @gctip           varchar(1)
  
  declare @islmtip         varchar(20)
  declare @islmtipad       varchar(30)
  declare @islmhrk         varchar(20)
  declare @islmhrkad       varchar(30)

  declare @ack             VARCHAR(50)

  
  select @islmtip=tip,@islmtipad=ad from islemturtip where tip='VAR'
  select @islmhrk=hrk,@islmhrkad=ad from islemhrktip where tip='VAR' and hrk='VTO'
  
  select @YER_AD=ad from yertipad where kod=@yertip
  
  
  
  
   declare  @drm     tinyint

  select @drm=Var_Hrk_Tar_isle from sistemtanim
  
  if @yertip='pomvardimas'
  select @ack=varad+' (POMPACI)',
    @VAR_TARIH=kaptar,
    @VAR_SAAT=kapsaat,
    @VAR_USER=deguser from 
    pomvardimas WITH (NOLOCK) where varno=@varno and sil=0

  
   if @yertip='marvardimas'
    select @ack=varad+' (MARKET)',
      @VAR_TARIH=kaptar,
      @VAR_SAAT=kapsaat,
      @VAR_USER=deguser from 
     marvardimas WITH (NOLOCK) where varno=@varno and sil=0
  

   if (@drm>0) and (@yertip='pomvardimas') /*acılıs tarihi */
     select
     @ack=varad+' (POMPACI)', 
     @VAR_TARIH=tarih,
     @VAR_SAAT=saat,
     @VAR_USER=deguser from 
     pomvardimas WITH (NOLOCK) where varno=@varno and sil=0
    
   if (@drm>0) and (@yertip='marvardimas') /*acılıs tarihi */
     select @ack=varad+' (MARKET)',
     @VAR_TARIH=tarih,
     @Var_saat=saat,
     @VAR_USER=deguser from 
     marvardimas WITH (NOLOCK) where varno=@varno and sil=0
  
  
 /*ilgili vardiyadaki kasa cari tahsilat odemesini siliyoruz */
 /*cari tahsilat odeme cek odeme banka yatan çekilen vs. */
 delete from kasahrk where islmhrk='VTO' and varno=@varno and yertip=@yertip


   DECLARE CRS_KASA_KAP CURSOR FAST_FORWARD FOR
   select h.firmano,h.kaskod,h.parabrm,sum(h.giren-h.cikan),avg(kur) from kasahrk as h WITH (NOLOCK)
   where h.varno=@varno and h.yertip=@yertip and h.sil=0 and h.islmhrk<>'TES'
   group by h.firmano,h.kaskod,h.parabrm
   
   OPEN CRS_KASA_KAP
   
    FETCH NEXT FROM CRS_KASA_KAP INTO
    @HRK_FIRMANO,@HRK_KASKOD,@PARA_BRM,@HRK_BAKIYE,@HRK_KUR

      WHILE @@FETCH_STATUS = 0
      BEGIN
 
      set @giren=0
      set @cikan=0
      if @HRK_BAKIYE>0
      begin
      SET @gctip='C'
      set @cikan=@HRK_BAKIYE
      end

      if @HRK_BAKIYE<0
      begin
      SET @gctip='G'
      set @giren=(-1*@HRK_BAKIYE)
      end

     if abs(@HRK_BAKIYE)>0
      begin
      select @newid=0
      insert into kasahrk (firmano,kaskod,kashrkid,gctip,varno,masterid,
      fisfattip,fisfatid,
      islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      perkod,adaid,giren,cikan,bakiye,carkod,cartip,
      tarih,saat,belno,ack,kur,varok,sil,olususer,
      olustarsaat,parabrm,karsihestip,karsiheskod)
      select @HRK_FIRMANO,@HRK_KASKOD,@newid,@gctip,@varno,@varno,'KENDI',0,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,@yertip,@YER_AD,
      'Diger',0,@giren,@cikan,0,'VRDKASA','vardikasa',@VAR_TARIH,@VAR_SAAT,
      cast(@varno as varchar),@ack,
      1,1,0,@VAR_USER,getdate(),'VRDKASA','kasakart',@HRK_KASKOD
 
      select @newid=SCOPE_IDENTITY()
      update kasahrk set kashrkid=@newid where id=@newid 
      
      
      
      end

      
      FETCH NEXT FROM CRS_KASA_KAP INTO
      @HRK_FIRMANO,@HRK_KASKOD,@PARA_BRM,@HRK_BAKIYE,@HRK_KUR
      END

     CLOSE CRS_KASA_KAP
     DEALLOCATE CRS_KASA_KAP

  
END

================================================================================
