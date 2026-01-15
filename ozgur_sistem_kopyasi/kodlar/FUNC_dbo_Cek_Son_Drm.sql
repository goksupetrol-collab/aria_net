-- Function: dbo.Cek_Son_Drm
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.648272
================================================================================

CREATE FUNCTION [dbo].Cek_Son_Drm 
(
@FIRMANO 		int,
@DRM			VARCHAR(20),
@BAS_TAR		datetime,
@BIT_TAR		datetime
)
RETURNS

  @TABLE_CEK_DRM TABLE (
   id					int,
   Drm					VARCHAR(20) COLLATE Turkish_CI_AS,
   Car_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Car_Kod				VARCHAR(50) COLLATE Turkish_CI_AS,
   BelgeNo				VARCHAR(50) COLLATE Turkish_CI_AS,
   Borc					float,
   Alacak				float,
   Tarih				datetime)
AS
BEGIN

    declare @son_drm   	varchar(20)
    declare @CEK_ID		int   
    declare @BelgeNo   	varchar(50)

     declare cek_cur CURSOR FAST_FORWARD  FOR 
      select cekid,ceksenno from cekkart as k
      where k.sil=0 and 
      cekid=(select top 1 cekid from cekhrk as h where 
        h.tarih >= @BAS_TAR and h.tarih <= @BIT_TAR
        and k.cekid=h.cekid and aktif=1
         order by h.tarih desc,h.saat desc,h.id asc)
     
       open cek_cur
         fetch next from  cek_cur into 
          @CEK_ID,@belgeNo
           while @@FETCH_STATUS=0
            begin 
        
    
              select top 1 @son_drm=drm from cekhrk with (NOLOCK)
              where cekid=@CEK_ID 
              and tarih >= @BAS_TAR and tarih <= @BIT_TAR
              and sil=0 and aktif=1 and drm<>'KGR'
              order by id desc



              if (@son_drm='TGR') and (@DRM='POR')
              begin
                insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                Car_Kod,belgeno,Borc,Alacak,Tarih)
                select top 1 id,drm,cartip,carkod,@belgeNo,
                tutar,0,tarih 
                from cekhrk with (NOLOCK)
                where cekid=@CEK_ID and drm in ('POR')
                and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                and sil=0 and aktif=1
                order by id desc
               end 
               
               
              if (@son_drm='CGR') and (@DRM='POR')
              begin
                insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                Car_Kod,belgeno,Borc,Alacak,Tarih)
                select top 1 id,drm,cartip,carkod,@belgeNo,
                tutar,0,tarih 
                from cekhrk  with (NOLOCK)
                where cekid=@CEK_ID and drm in ('POR')
                and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                and sil=0 and aktif=1
                order by id desc
               end 
               
               
               
               
                
                
                if (@son_drm='POR') and (@DRM='POR')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,
                  @belgeNo,tutar,0,tarih from 
                  cekhrk with (NOLOCK) where cekid=@CEK_ID and drm in ('POR')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  
                end
                
                if (@son_drm='TAK') and (@DRM='TAK')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,
                  @belgeNo,tutar,0,tarih from cekhrk with (NOLOCK)
                  where cekid=@CEK_ID and drm in ('TAK')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  
                end  
                
  
                if (@son_drm='KSN') and (@DRM='KSN')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,@belgeNo,
                  0,tutar,tarih 
                  from cekhrk with (NOLOCK)
                  where cekid=@CEK_ID and drm in ('KSN')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  /* tarih desc,saat desc  */
                end
                
                
                if (@son_drm='OTI') and (@DRM='TAK')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,@belgeNo,
                  tutar,0,tarih from cekhrk with (NOLOCK)
                  where cekid=@CEK_ID and drm in ('TAK')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  
                end  
                
                
                if (@son_drm='OTI') and (@DRM='KSN')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,@belgeNo,
                  0,tutar,tarih from cekhrk with (NOLOCK)
                  where cekid=@CEK_ID and drm in ('KSN')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  
                end 
                
                              
                if (@son_drm='OTI') and (@DRM='POR')
                begin 
                  insert into @TABLE_CEK_DRM (id,drm,Car_Tip,
                  Car_Kod,belgeno,Borc,Alacak,Tarih)
                  select top 1 id,drm,cartip,carkod,
                  @belgeNo,tutar,0,tarih from 
                  cekhrk with (NOLOCK) where cekid=@CEK_ID and drm in ('POR')
                  and tarih >= @BAS_TAR and tarih <= @BIT_TAR
                  and sil=0 and aktif=1
                  order by id desc  
                end  
                



          FETCH next from  cek_cur into @CEK_ID,@belgeNo
         end
        Close cek_cur
        deallocate cek_cur 
        
        
        
        
        


     RETURN


END

================================================================================
