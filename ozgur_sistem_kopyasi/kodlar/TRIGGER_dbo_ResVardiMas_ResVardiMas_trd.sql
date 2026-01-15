-- Trigger: dbo.ResVardiMas_trd
-- Tablo: dbo.ResVardiMas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.010364
================================================================================

CREATE TRIGGER [dbo].[ResVardiMas_trd] ON [dbo].[ResVardiMas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @varno int
declare @firmano int
declare @yertipyaz varchar(20)
declare @yertip varchar(20)
set @yertip='resvardimas'
set @yertipyaz='yazarkasa'


  select @firmano=firmano,@varno=varno from DELETED


  update marsatmas set sil=1 where varno=@varno
  and (yertip=@yertip ) and sil=0

 /* update veresimas set sil=1 where varno=@varno */
 /* and (yertip=@yertip ) and sil=0 */

  update carihrk set sil=1 where varno=@varno
  and (yertip=@yertip ) and sil=0

  update kasahrk set sil=1 where varno=@varno
  and (yertip=@yertip ) and sil=0
 
/* update bankahrk set sil=1 where varno=@varno */
 /* and (yertip=@yertip ) and sil=0 */
  
  update poshrk set sil=1 where varno=@varno
  and (yertip=@yertip ) and sil=0
  
  /*update cekkart set sil=1 where varno=@varno */
 /* and (yertip=@yertip ) and sil=0 */

 EXECUTE resvarkabul @varno,0,1
 
 EXECUTE  Restaurat_BozukPara @firmano,@varno,1
END

================================================================================
