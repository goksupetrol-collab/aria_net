-- Trigger: dbo.marvardimas_tri
-- Tablo: dbo.marvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.981233
================================================================================

CREATE TRIGGER [dbo].[marvardimas_tri] ON [dbo].[marvardimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno float,@varok int,@sil int
declare @yertipyaz varchar(20)
declare @yertip varchar(20)
declare @firmano	int

declare @del_tarih  datetime
declare @ins_tarih  datetime

set @yertip='marvardimas'
set @yertipyaz='yazarkasa'


 select @firmano=firmano,@varno=varno,@varok=varok,
 @sil=sil,@ins_tarih=tarih from inserted

 select @del_tarih=tarih from deleted





if (UPDATE(varok) or UPDATE (sil))
begin

update marsatmas set varok=@varok,sil=@sil where varno=@varno
/* and (yertip=@yertip or yertip=@yertipyaz)  */
 and sil=0

 update veresimas set varok=@varok,sil=@sil where varno=@varno
 and (yertip=@yertip) and sil=0

 update carihrk set varok=@varok,sil=@sil where varno=@varno
 and (yertip=@yertip) and sil=0


 update kasahrk set varok=@varok,sil=@sil where varno=@varno
  and (yertip=@yertip) and sil=0

  
 update bankahrk set varok=@varok,sil=@sil where varno=@varno
 and (yertip=@yertip) and sil=0

 
  update poshrk set varok=@varok,sil=@sil where varno=@varno
 and (yertip=@yertip) and sil=0
   
  update cekkart set varok=@varok,sil=@sil where varno=@varno
   and (yertip=@yertip) and sil=0


  EXECUTE marvarkabul @varno,@varok,@sil
  

  if @varok=1
  exec Vardiya_Hrk_Tar_Ata @firmano,@varno,@yertip

  
   
end


  if (UPDATE(varno) or UPDATE (sil) or UPDATE(bozukpara) or update(kas_kod))
     EXECUTE  Market_BozukPara @firmano,@varno,@sil 

  



  if (UPDATE(tarih)) and (@del_tarih<>@ins_tarih) and (@varok=0)
   begin
       update marsathrk set tarih=@ins_tarih where varno=@varno
       update marsatmas set tarih=@ins_tarih where varno=@varno
   end   
   
 
SET NOCOUNT OFF

END

================================================================================
