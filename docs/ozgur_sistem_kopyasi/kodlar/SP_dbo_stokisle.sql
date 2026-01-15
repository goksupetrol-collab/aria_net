-- Stored Procedure: dbo.stokisle
-- Tarih: 2026-01-14 20:06:08.383507
================================================================================

CREATE PROCEDURE [dbo].stokisle @id float
AS
BEGIN
declare @stktip 		varchar(10)
declare @stkod 			varchar(30)
declare @depkod 		varchar(30)
declare @islmtip 		varchar(20)
declare @yertip 		varchar(20)
declare @tarx 			datetime
declare @brimfiy 		float
declare @kdvyuz 		float
declare @giren 			float
declare @cikan 			float
declare @say 			int
declare @userad 		varchar(100)
declare @firmano        int
declare @StkId       int
declare @Sil       int
declare @tar 			datetime
declare @marsatid     int


   declare @Market_Sube  int
   Select @Market_Sube=Market_Sube  from sistemtanim


  select @firmano=firmano,@yertip=yertip,@stktip=stktip,@depkod=depkod,
  @userad=olususer,@tarx=olustarsaat,@tar=tarih,@stkod=stkod,@islmtip=islmtip,@Sil=sil,
  @brimfiy=brmfiykdvli,@kdvyuz=kdvyuz,@giren=giren,@cikan=cikan, 
  @marsatid=isnull(marsatid,0)  from
  stkhrk with (nolock) where id=@id
  
  
  if @Market_Sube>0 and @firmano>0 and @Sil=0 and @stktip='markt'
  and @marsatid=0
   begin
    select @StkId=id from stokkart with (nolock) 
    where kod=@stkod and tip=@stktip
    
   
    if @giren>0
     begin
         /*Sonrasi±nda Fatura Varsa bunu baz alma */
        if not EXISTS(select id from stkhrk with (nolock)
        where tarih>@tar and giren>0 and firmano=@firmano
        and  stktip=@stktip and stkod=@stkod and sil=0)     
        update Stok_Fiyat set 
        Fiyat=case when KdvTip=1 then @brimfiy else @brimfiy/(1+@kdvyuz) end
        where FiyTip=1 and FiyNo=1 and Stktip_id=2 and Stk_id=@StkId
        and firmano=@firmano
    
     end
    
    
    
    
   end 
  
  
  
  
 /*Genel */
  if  (@islmtip='FATAKALS') or (@islmtip='FATMRALS') 
     OR (@islmtip='IRSAKALS') or (@islmtip='IRSMRALS') 
     or (@islmtip='FATYGALS') or (@islmtip='KARTAC')
     UPDATE stokkart  SET
     olususer=@userad,
     olustarsaat=@tarx,
     ortalsfiykdvli=DT.ortalsfiy,
     alsfiy=isnull((select top 1 case when k.alskdvtip='Dahil' then 
      brmfiykdvli else (brmfiykdvli/(1+kdvyuz)) end
     from stkhrk as h with (nolock) 
     inner join stokkart as k with(nolock) on 
     k.kod=h.stkod and k.tip=h.stktip
     where h.stkod=@stkod and h.stktip=@stktip
     and h.brmfiykdvli>0
     and h.sil=0 and islmtip in 
     ('KARTAC','FATAKALS','FATMRALS',
     'IRSAKALS','IRSMRALS','FATYGALS')
     order by h.tarih desc),alsfiy)
     from stokkart as t  JOIN
     (select h.stkod,h.stktip,
     isnull(case when sum((h.giren-(h.aiademik+h.siademik))) >0  then
     sum((h.giren-(h.aiademik+h.siademik))*brmfiykdvli)
     / sum((h.giren-(h.aiademik+h.siademik)))
     else 0 end,0)   as ortalsfiy
     from stkhrk as h with (nolock) where h.stkod=@stkod and h.stktip=@stktip
     and h.sil=0 group by h.stkod,h.stktip ) DT on
     DT.stkod=T.kod AND DT.stktip=T.tip

END

================================================================================
