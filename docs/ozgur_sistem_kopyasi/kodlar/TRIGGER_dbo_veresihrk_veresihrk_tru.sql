-- Trigger: dbo.veresihrk_tru
-- Tablo: dbo.veresihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.041558
================================================================================

CREATE TRIGGER [dbo].[veresihrk_tru] ON [dbo].[veresihrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @id 		float
declare @varno 		float
declare @verid 		float
declare @vertop 	float
declare @varok 		int
declare @sil 		int
declare @kayok 		int
SET NOCOUNT ON

DECLARE veresihrkup CURSOR FAST_FORWARD FOR SELECT inserted.id,inserted.verid,m.varno,
m.varok,inserted.sil,inserted.kayok from inserted
inner join  veresimas as m on m.verid=inserted.verid
 OPEN veresihrkup
  FETCH NEXT FROM veresihrkup INTO  @id,@verid,@varno,@varok,@sil,@kayok
  WHILE @@FETCH_STATUS =0
  BEGIN


   update veresimas set 
   toptut=ROUND(CAST (dt.fistop AS decimal (20,2)),2),
   Top_Mik=dt.top_mik,
   Genel_KdvToplam=Dt.topkdv,
   Genel_KdvliToplam=Dt.topkdvli,
   isktop=dt.isktop,
   fiyfarktop=dt.fiyfarktop,
   vadfarktop=dt.vadfarktop 
   from veresimas as t
   join (select 
   isnull(sum(mik*brmfiy),0) as fistop,
   isnull(sum(mik),0) as top_mik,
   isnull(sum(mik*brmfiy*(iskyuz/100)),0) as isktop,
   
   (isnull(sum(mik*brmfiy),0)-isnull(sum(mik*brmfiy*(iskyuz/100)),0))
   -isnull( sum( ( (mik*brmfiy)-(mik*brmfiy*(iskyuz/100)))  /(1+kdvyuz)),0) as topkdv,
    
   (isnull(sum(mik*brmfiy),0)-isnull(sum(mik*brmfiy*(iskyuz/100)),0)) as topkdvli,

   isnull(sum(mik*fiyfarktop),0) as fiyfarktop,
   isnull(sum(mik*vadfarktop),0) as vadfarktop
   from veresihrk with (nolock) where verid=@verid and sil=0) dt
   on t.verid=@verid

   



  FETCH NEXT FROM veresihrkup INTO  @id,@verid,@varno,@varok,@sil,@kayok
  END
 CLOSE veresihrkup
 DEALLOCATE veresihrkup




SET NOCOUNT OFF
END

================================================================================
