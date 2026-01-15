-- Stored Procedure: dbo.pomvardistokduzelt
-- Tarih: 2026-01-14 20:06:08.356298
================================================================================

CREATE PROCEDURE [dbo].pomvardistokduzelt (@varno float)
AS
BEGIN

 declare @tankod varchar(20)
 declare @stkod varchar(20)
 declare @stktip varchar(20)
 declare @id float
 declare @TARIH1 datetime
 declare @SAAT1 VARCHAR(8)
 
 declare @stkkalanmik float
 declare @tnkkalanmik float

 select @TARIH1=tarih,@SAAT1=cast(saat as varchar) from pomvardimas where varno=@varno

 DECLARE pomtankstokduz CURSOR FAST_FORWARD FOR SELECT id,kod,stkod,stktip
 FROM pomvarditank where varno=@varno and Sil=0
 OPEN pomtankstokduz
 FETCH NEXT FROM pomtankstokduz INTO  @id,@tankod,@stkod,@stktip
 WHILE @@FETCH_STATUS = 0
 BEGIN


 set @stkkalanmik=isnull((select MIKTAR from dbo.DEPO_TARIHLI_STOK ('',@stktip,@stkod,@TARIH1,@SAAT1)),0)
 set @tnkkalanmik=isnull((select MIKTAR from dbo.DEPO_TARIHLI_STOK (@tankod,@stktip,@stkod,@TARIH1,@SAAT1)),0)

  update pomvardistok set acmik=@stkkalanmik,kalan=@stkkalanmik-(satmik+testmik+transfer_cks_mik)
  from pomvardistok where kod=@stkod and stktip=@stktip and varno=@varno and Sil=0
 
  update pomvarditank set acmik=@tnkkalanmik,kalan=(@tnkkalanmik)-(satmik+testmik+transfer_cks_mik)
  from pomvarditank where kod=@tankod and varno=@varno and Sil=0



 FETCH NEXT FROM pomtankstokduz INTO  @id,@tankod,@stkod,@stktip
 END
 CLOSE pomtankstokduz
 DEALLOCATE pomtankstokduz

  
END

================================================================================
