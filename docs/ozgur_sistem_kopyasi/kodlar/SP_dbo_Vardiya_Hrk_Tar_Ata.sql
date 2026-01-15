-- Stored Procedure: dbo.Vardiya_Hrk_Tar_Ata
-- Tarih: 2026-01-14 20:06:08.386928
================================================================================

CREATE PROCEDURE [dbo].Vardiya_Hrk_Tar_Ata
(@Firmano    int,
@varno 		int,
@yertip   	varchar(50) )
AS
BEGIN


 declare  @drm     tinyint

  select @drm=Var_Hrk_Tar_isle from sistemtanim

  if not (@drm>0) 
     RETURN


   declare @Tarih           datetime

  if @yertip='pomvardimas' 
   begin
   
    
   select @Tarih=tarih from pomvardimas with (nolock) where varno=@varno
   and sil=0
   
   if not (@Tarih is null)
    begin
   

      /* pos hrk  */
       update poshrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
         
       /*fis   */
       update veresimas set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
         
      /*kasa    */
       update kasahrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
        
      /*emtia  */
       update emtiasat set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno  
       
       /*cari */
       update carihrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno     
       
       /*banka   */
       update bankahrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno 
         
       /*cek    */
        update cekkart set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno 
         and drm in ('POR','KSN')   
         
      end
    end 
     

  
 if @yertip='marvardimas' 
   begin
   
    
   select @Tarih=tarih from marvardimas with (nolock) where varno=@varno
   and sil=0
   
   if not (@Tarih is null)
    begin
   

      /* pos hrk  */
       update poshrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
         
       /*fis   */
       update veresimas set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
         
      /*kasa    */
       update kasahrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno
        
       
      /*market satis stok    */
       update marsatmas set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno 
       
       
      
       /*cari */
       update carihrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno     
       
       /*banka   */
       update bankahrk set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno 
         
       /*cek    */
        update cekkart set Tarih=@Tarih where 
         yertip=@yertip and varno=@varno 
         and drm in ('POR','KSN')   
         
   
  
       end
    end 
      






END

================================================================================
