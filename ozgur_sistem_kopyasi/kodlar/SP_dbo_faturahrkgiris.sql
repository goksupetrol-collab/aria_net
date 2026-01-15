-- Stored Procedure: dbo.faturahrkgiris
-- Tarih: 2026-01-14 20:06:08.327760
================================================================================

CREATE PROCEDURE [dbo].faturahrkgiris (@fatid float,@kayok int,@sil int)
AS
BEGIN
 declare @satirtoplam float
 declare @kdvtip varchar(10)
 declare @stktip varchar(10)
 declare @satiristip varchar(10)
 declare @brimfiyatkdvsiz float
 declare @otvbrim float
 declare @brimfiy float
 declare @mik float
 declare @carpan float
 declare @geniskorn float
 declare @genelisktop float
 declare @gidertop float
 declare @giderbrmtut float
 declare @gen_ind_tip tinyint
 
 declare @id float
 declare @satirbrmisktut float
 declare @satirbrmisklutut float
 declare @satirisktop float
 declare @giderbrmcarp float
 declare @kdvyuz float
 declare @kdvtevkifatyuz float
 declare @satiriskyuz float
 declare @satirbrimfiyat float
 declare @satgenelisktut float
 declare @satirkdvtut float
 declare @satirkdvtevkifattut float
 

 declare @baslik_faturatop          float
 declare @baslik_satiriskontotop    float
 declare @baslik_satirgeniskontotop float
 declare @baslik_gidertop           float
 declare @baslik_kdvtop             float
 declare @baslik_giderkdvtop        float
 declare @genel_isk_top             float
 declare @genel_kdv_top				float
 declare @genel_kdv_tevkifat_top	float
 declare @genel_ara_top             float
 declare @genel_net_top				float

 declare  @hrk_stk_pro  		bit
 
 declare @gn_matrah 			float 
 declare @ak_matrah 			float 
 declare @mr_matrah 			float
 declare @gg_matrah 			float
 
 declare @ak_isk_tip           	int
 declare @ak_isk_yuz   			float
 declare @ak_isk_top   			float
 declare @ak_sat_isk_yuz   		float
 declare @ak_sat_isk_top   		float
 
 
 declare @mr_isk_tip       		int
 declare @mr_isk_yuz       		float
 declare @mr_isk_top       		float
 declare @mr_sat_isk_yuz   		float
 declare @mr_sat_isk_top   		float
 
 declare @gg_isk_tip       		int
 declare @gg_isk_yuz       		float
 declare @gg_isk_top       		float
 declare @gg_sat_isk_yuz   		float
 declare @gg_sat_isk_top   		float
 

 
 
 declare @Sat_Top_isk_Tut       Float       


 set @Sat_Top_isk_Tut=0
 set @baslik_satiriskontotop=0
 set @baslik_satirgeniskontotop=0
 set @baslik_kdvtop=0
 set @baslik_giderkdvtop=0
 set @baslik_faturatop=0
 set @genel_kdv_tevkifat_top=0



  select @satirtoplam=
  isnull(sum(case when satirtip='S' then
  ((brmfiy+otvbrim)-isnull(brmfiy*(satiskyuz/100),0))*mik else 0 end),0),
  
  /*isnull(satisktut,0) */
  
  /*@satirisktop=satisktut, */
  @gidertop=
  isnull(sum(case when satirtip='M' then
  (brmfiy+otvbrim)*mik else 0 end),0),
  
  @ak_matrah=isnull(sum(case when stktip='akykt' then
  ((brmfiy+otvbrim)- ((brmfiy+otvbrim)*(satiskyuz/100)) )*mik else 0 end),0),
  @mr_matrah=isnull(sum(case when stktip='markt' then
  ((brmfiy+otvbrim)-((brmfiy+otvbrim)*(satiskyuz/100) ))*mik else 0 end),0),
  
   @gg_matrah=isnull(sum(case when stktip='gelgid' and satirtip='S' then
  ((brmfiy+otvbrim)-((brmfiy+otvbrim)*(satiskyuz/100) ))*mik else 0 end),0)
  
  
  
  from faturahrklistesi WITH (NOLOCK)  where fatid=@fatid and sil=0

  set @baslik_gidertop=@gidertop

  /*@geniskorn=case when isnull(geniskyuz,0)>0 then geniskyuz/100 else 0 end */
  select @hrk_stk_pro=hrk_stk_pro,
  @gen_ind_tip=isnull(gen_ind_tip,0),
  @geniskorn=isnull(geniskyuz,0),
  @genelisktop=isnull(genisktop,0),
  @ak_isk_tip=isnull(ak_isk_tip,0),
  @ak_isk_yuz=isnull(ak_isk_yuz,0),
  @ak_isk_top=isnull(ak_isk_top,0),
  @mr_isk_tip=isnull(mr_isk_tip,0),
  @mr_isk_yuz=isnull(mr_isk_yuz,0),
  @mr_isk_top=isnull(mr_isk_top,0),
  @gg_isk_tip=isnull(gg_isk_tip,0),
  @gg_isk_yuz=isnull(gg_isk_yuz,0),
  @gg_isk_top=isnull(gg_isk_top,0)
  
  
  
  from faturamas WITH (NOLOCK) where fatid=@fatid and sil=0


  set @geniskorn=@geniskorn/100

  if @satirtoplam>0
  set @giderbrmcarp=@gidertop/@satirtoplam/*oranı */

  if (@satirtoplam>0) and (@gen_ind_tip=1) /*tutar indrim */
  set @geniskorn=(@genelisktop/@satirtoplam)/*oranı */
  
  if (@satirtoplam>0) and (@gen_ind_tip=0) /*yuzde indrim */
  set @genelisktop=(@geniskorn*@satirtoplam)/*oranı */
  
  
  set @gn_matrah=0
  /*set @ak_matrah=0 */
 /* set @mr_matrah=0 */
  

 DECLARE faturahrkisle CURSOR FAST_FORWARD FOR 
 SELECT id,satirtip,kayok,sil,
 brmfiy,otvbrim,kdvyuz,kdvtevkifatyuzde,satiskyuz,mik,carpan,kdvtip,stktip
 FROM faturahrklistesi WITH (NOLOCK) where fatid=@fatid and sil=0
 OPEN faturahrkisle
 FETCH NEXT FROM faturahrkisle INTO  @id,@satiristip,@kayok,@sil,
 @brimfiy,@otvbrim,@kdvyuz,@kdvtevkifatyuz,@satiriskyuz,@mik,@carpan,@kdvtip,@stktip
 WHILE @@FETCH_STATUS = 0
 BEGIN

  /*kdv hariç */
 set @satirbrimfiyat=@brimfiy+@otvbrim


 set @satirbrmisktut=(@brimfiy)*(CASE when @satiriskyuz>0 then
 (@satiriskyuz/100) else 0 end)

 set @gn_matrah=@gn_matrah+((@satirbrimfiyat-@satirbrmisktut)*@mik)


 set @ak_sat_isk_yuz=0
 set @ak_sat_isk_top=0
 set @mr_sat_isk_yuz=0
 set @mr_sat_isk_top=0 
 set @gg_sat_isk_yuz=0
 set @gg_sat_isk_top=0 
 


 if @stktip='akykt'
  begin
    /*set @ak_matrah=@ak_matrah+((@satirbrimfiyat-@satirbrmisktut)*@mik) */
      if @ak_isk_tip=0
       begin
          set @ak_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@ak_isk_yuz/100)
          set @ak_sat_isk_yuz=@ak_isk_yuz/*/100 */
        end
        
      if @ak_isk_tip=1
       begin
          set @ak_sat_isk_yuz=(@ak_isk_top/(@ak_matrah))
          set @ak_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@ak_sat_isk_yuz)
     
        end

     if @ak_matrah=0
     begin
      set @ak_sat_isk_yuz=0
      set @ak_sat_isk_top=0
     end

   end
 
 if @stktip='markt'
  begin
    /* set @mr_matrah=@mr_matrah+((@satirbrimfiyat-@satirbrmisktut)*@mik) */
       if @mr_isk_tip=0
       begin
        set @mr_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@mr_isk_yuz/100)
        set @mr_sat_isk_yuz=@mr_isk_yuz/*/100 */
        end
 
    if @mr_isk_tip=1
     begin
       set @mr_sat_isk_yuz=(@mr_isk_top/(@mr_matrah))
       set @mr_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@mr_sat_isk_yuz)
     end
     
     if @mr_matrah=0
     begin
      set @mr_sat_isk_yuz=0
      set @mr_sat_isk_top=0
     end
     
     
    end
    

  if (@stktip='gelgid') and (@satiristip='S')
   begin
    /* set @gg_matrah=@gg_matrah+((@satirbrimfiyat-@satirbrmisktut)*@mik) */
       if @gg_isk_tip=0
       begin
        set @gg_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@gg_isk_yuz/100)
        set @gg_sat_isk_yuz=@gg_isk_yuz/100
        end
 
    if @gg_isk_tip=1
     begin
       set @gg_sat_isk_yuz=(@gg_isk_top/(@gg_matrah))
       set @gg_sat_isk_top=((@satirbrimfiyat-@satirbrmisktut))*(@gg_sat_isk_yuz)
     end
     
     if @gg_matrah=0
     begin
      set @gg_sat_isk_yuz=0
      set @gg_sat_isk_top=0
     end
     
     
    end

    
    
    

 if @satiristip='M'
 set @satgenelisktut=0
 if @satiristip='S'
 set @satgenelisktut=(@satirbrimfiyat-@satirbrmisktut)*@geniskorn
 
 set @giderbrmtut=@giderbrmcarp*@satirbrimfiyat
 set @satirbrmisklutut=(@satirbrimfiyat-
 (@satirbrmisktut+@satgenelisktut+
 isnull(@mr_sat_isk_top,0)+
 isnull(@ak_sat_isk_top,0)+
 isnull(@gg_sat_isk_top,0)))
 set @satirkdvtut=@satirbrmisklutut*@kdvyuz
 
 
 set @satirkdvtevkifattut=( (@satirkdvtut*@mik)*@kdvtevkifatyuz)
 
 
 set @Sat_Top_isk_Tut=(@mik*@satirbrmisktut)+
  (@mik*@satgenelisktut)+(@mik*@ak_sat_isk_top)+
  (@mik*@mr_sat_isk_top)+(@mik*@gg_sat_isk_top)
 
 if @satiristip='S'
   update faturahrk set
     hrk_stk_pro=@hrk_stk_pro,
     giderbrmtut=@giderbrmtut,
     satisktut=@satirbrmisktut,
     geniskyuz=@geniskorn,
     genisktut=@satgenelisktut,
   
     ak_isk_yuz=@ak_sat_isk_yuz,
     ak_isk_tut=@ak_sat_isk_top,
  
     mr_isk_yuz=@mr_sat_isk_yuz,
     mr_isk_tut=@mr_sat_isk_top,
     
     gg_isk_yuz=@gg_sat_isk_yuz,
     gg_isk_tut=@gg_sat_isk_top,
         
     Top_isk_Yuz= case when (@Mik*@satirbrimfiyat)>0 then 
     (@Sat_Top_isk_Tut*100) / ((@Mik*@satirbrimfiyat)) else 0 end,
     Top_isk_Tut=@Sat_Top_isk_Tut, 
 
    
     kdvtut=@satirkdvtut,
     
     top_kdv_tut=@satirkdvtut*@Mik,
     
     KdvTevkifatTutar=@satirkdvtevkifattut,
     
     top_tut_kdvsiz=Mik*brmfiy,
     
     top_tut_isk_kdvsiz=(Mik*brmfiy)-@Sat_Top_isk_Tut,
     
     top_tut_isk_kdvli=((Mik*brmfiy)-@Sat_Top_isk_Tut)+
     (@satirkdvtut*@Mik)
     

     
   where id=@id
  
 

  if @satiristip='S'
  begin
  set @baslik_faturatop=@baslik_faturatop+(@satirbrimfiyat*@mik)
  set @baslik_kdvtop=@baslik_kdvtop+(@satirkdvtut*@mik)
  set @genel_kdv_tevkifat_top=@genel_kdv_tevkifat_top+@satirkdvtevkifattut
  set @baslik_satiriskontotop=@baslik_satiriskontotop+(@satirbrmisktut*@mik)
  set @baslik_satirgeniskontotop=@baslik_satirgeniskontotop+(@satgenelisktut*@mik)
  end
  if @satiristip='M'
  set @baslik_giderkdvtop=@baslik_giderkdvtop+(@satirkdvtut*@mik)



  FETCH NEXT FROM faturahrkisle INTO  @id,@satiristip,@kayok,@sil,
 @brimfiy,@otvbrim,@kdvyuz,@kdvtevkifatyuz,@satiriskyuz,@mik,@carpan,@kdvtip,@stktip
 END
 CLOSE faturahrkisle
 DEALLOCATE faturahrkisle
 
 
 if @ak_matrah=0
 begin
 set @ak_isk_top=0
 set @ak_isk_yuz=0
 end
 else
  begin
 if @ak_isk_tip=0
   set @ak_isk_top=@ak_matrah*(@ak_isk_yuz/100)
 if @ak_isk_tip=1
   set @ak_isk_yuz=(@ak_isk_top/@ak_matrah)*100
 end  


 if @mr_matrah=0
 begin
  set @mr_isk_top=0
  set @mr_isk_yuz=0
 end
 else
  begin
  if @mr_isk_tip=0
    set @mr_isk_top=@mr_matrah*(@mr_isk_yuz/100)

  if @mr_isk_tip=1
    set @mr_isk_yuz=(@mr_isk_top/@mr_matrah)*100
  end  
  
  
  if @gg_matrah=0
   begin
   set @gg_isk_top=0
   set @gg_isk_yuz=0
  end
 else
  begin
  if @gg_isk_tip=0
    set @gg_isk_top=@gg_matrah*(@gg_isk_yuz/100)

  if @gg_isk_tip=1
    set @gg_isk_yuz=@gg_isk_top/@gg_matrah
  end  
  
  
  


  /* ara toplam */
    set @genel_ara_top=
    round(@baslik_faturatop,2)

   /* gider top */
    set @gidertop=round(@gidertop,2)

/*- genel iskonto toplam */
   set @genel_isk_top=
   round(@genelisktop+@baslik_satiriskontotop+
   @ak_isk_top+@mr_isk_top+@gg_isk_top,2)
   
   
   set @genel_net_top=@baslik_faturatop-@genel_isk_top+@gidertop
   
   
 /*genel kdv toplam   */
    set @genel_kdv_top=round(@baslik_kdvtop+@baslik_giderkdvtop,2)
 
 
 /*-faturamas */
  update faturamas set
     fattop=@baslik_faturatop,
     genel_ara_top=@genel_ara_top,
     genel_net_top=@genel_net_top,
     gidertop=@gidertop,
     geniskyuz=@geniskorn*100,
     genisktop=@genelisktop,
     giderkdvtop=@baslik_giderkdvtop,
     satisktop=@baslik_satiriskontotop,
     kdvtop=@baslik_kdvtop,
       
     gn_matrah=@gn_matrah,
     ak_matrah=@ak_matrah,
     mr_matrah=@mr_matrah,
     gg_matrah=@gg_matrah,
     
     ak_isk_yuz=@ak_isk_yuz,
     ak_isk_top=@ak_isk_top,
   
     mr_isk_yuz=@mr_isk_yuz,
     mr_isk_top=@mr_isk_top,  
  
     gg_isk_yuz=@gg_isk_yuz,
     gg_isk_top=@gg_isk_top,  


        
     genel_isk_top=@genel_isk_top,
     /*round(@genelisktop+@baslik_satiriskontotop+@ak_isk_top+@mr_isk_top+@gg_isk_top,2), */
     
     genel_kdv_top=@genel_kdv_top,
     genel_kdv_tevkifat_top=@genel_kdv_tevkifat_top,
     
     genel_top=
     round((@genel_ara_top-@genel_isk_top+@gidertop)+
     (@genel_kdv_top-@genel_kdv_tevkifat_top+yuvtop),2)
          
    /* round(((@baslik_faturatop- */
    /* (@genelisktop+@baslik_satiriskontotop+@ak_isk_top+@mr_isk_top)) */
    /* +(@baslik_kdvtop+@baslik_giderkdvtop+@gidertop+yuvtop)),2) */
     where fatid=@fatid
 
 
END

================================================================================
