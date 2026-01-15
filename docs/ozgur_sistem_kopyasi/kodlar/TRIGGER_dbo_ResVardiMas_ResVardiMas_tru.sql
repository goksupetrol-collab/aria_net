-- Trigger: dbo.ResVardiMas_tru
-- Tablo: dbo.ResVardiMas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.010857
================================================================================

CREATE TRIGGER [dbo].[ResVardiMas_tru] ON [dbo].[ResVardiMas]
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

set @yertip='resvardimas'  /*ResVardiMas */


 select @firmano=firmano,@varno=varno,@varok=varok,
 @sil=sil,@ins_tarih=tarih from inserted

 select @del_tarih=tarih from deleted


if (UPDATE(varok) or UPDATE(sil))
begin

  if @sil=1
    update ressatmas set sil=@sil where varno=@varno and sil=0
  

 /*update veresimas set varok=@varok,sil=@sil where varno=@varno */
 /*and (yertip=@yertip ) and sil=0 */

 update carihrk set varok=@varok,sil=@sil where varno=@varno
 and yertip=@yertip and sil=0

 update kasahrk set varok=@varok,sil=@sil where varno=@varno
  and (yertip=@yertip ) and sil=0
  
 /*update bankahrk set varok=@varok,sil=@sil where varno=@varno */
 /*and (yertip=@yertip ) and sil=0 */
 
  update poshrk set varok=@varok,sil=@sil where varno=@varno
   and (yertip=@yertip ) and sil=0
   
  /*update cekkart set varok=@varok,sil=@sil where varno=@varno */
  /*and (yertip=@yertip or yertip=@yertipyaz) and sil=0 */

  EXECUTE resvarkabul @varno,@varok,@sil
  
end


  if (UPDATE(varok) or UPDATE(sil) or UPDATE(varno) )
   EXECUTE  Restaurat_BozukPara @firmano,@varno,@sil
 




SET NOCOUNT OFF

END

================================================================================
