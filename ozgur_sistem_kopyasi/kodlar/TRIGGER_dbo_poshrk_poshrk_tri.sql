-- Trigger: dbo.poshrk_tri
-- Tablo: dbo.poshrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.004460
================================================================================

CREATE TRIGGER [dbo].[poshrk_tri] ON [dbo].[poshrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @varno 		float
declare @idx 		float
declare @masterid 	float
declare @poshrkid 	float
declare @sil 		int
declare @yertip 	varchar(30)
declare @belno		varchar(50)
declare @islmtip    varchar(30)
declare @islmhrk    varchar(30)
declare @marsatid 	float
declare @tahodeid 	float
declare @aktip		varchar(20)
declare @mesaj     varchar(500)
declare @firmano    int
declare @poshrkIdcount  int
declare @id  int

SET NOCOUNT ON


/*if update(varok) */
/*return */



set @poshrkIdcount=0

select @marsatid=marsatid,@poshrkid=poshrkid,@id=id,
@idx=id,@masterid=masterid,@firmano=firmano,
@yertip=yertip,@belno=belno,@islmtip=islmtip,@islmhrk=islmhrk,
@varno=varno,@sil=sil,@tahodeid=tahodeid,
@aktip=aktip  from inserted

select @poshrkIdcount=count(*) from poshrk with (nolock)
where isnull(poshrkid,0)=0 and firmano=@firmano 


if @poshrkIdcount>1
 begin
   RAISERROR ('PoshrkId Hatası', 16,1) 
   ROLLBACK TRANSACTION
   RETURN
 end

 
 

   if isnull(@poshrkid,0)=0
   begin
    update poshrk set poshrkid=id where id=@id
    /*return */
   end
  
   exec numara_no_yaz 'makbuz',@belno
  
  
  if (@sil=1) 
    begin
    
     if (@aktip<>'BK')      
      begin
       set @mesaj=' Silmek İstediğiniz Pos Slibi Aktarılmış Durumda..!';
       RAISERROR (@mesaj, 16,1)
       ROLLBACK TRANSACTION
       RETURN
     end
      
          
     delete from TahsilatOdeme where id=@tahodeid
    end
  
  
  if (@yertip='pomvardimas') and (@islmtip='TAH') and (@islmhrk='POS')
  begin
  
  update pomvardimas set gelirtop=
   (select isnull(sum(giren*kur),0) from Poshrk with (nolock) where varno=@varno and sil=0
   and ( islmtip='TAH' and cartip='gelgidkart'  )
    and cartip='gelgidkart' and yertip=@yertip )
   where varno=@varno
   
   
   update pomvardimas set gelirtop=gelirtop+
   (select isnull(sum(alacak*kur),0) from carihrk with (nolock) where varno=@varno and sil=0
   and ( islmtip='TAH' and islmhrk='NAK' and cartip='gelgidkart'  )
    and cartip='gelgidkart' and yertip=@yertip )
   where varno=@varno

  
  end



 if ((@yertip='marvardimas') or (@yertip='yazarkasa')  or (@yertip='promakscsv')  )
  and (@islmtip='TAH') and (@islmhrk='POS')
  begin

    update marsatmas set cartip='poskart',carkod=dt.poskod,
     islmhrk=dt.islmhrk,islmhrkad=dt.islmhrkad,postop=dt.postop
     from marsatmas t join
     (select  marsatid,poskod,islmhrk,islmhrkad,
         isnull((giren*kur),0) as postop from poshrk with (nolock)
     where varno=@varno and sil=0 and marsatid=@marsatid )
     dt on dt.marsatid=t.marsatid and t.sil=0


    update marvardimas set postop=dt.postop,poscartop=dt.poscartp from
     marvardimas as t join
    (select isnull(sum(giren*kur),0) as postop,
    isnull(sum(case when carslip=1 then giren*kur else 0 end),0) as poscartp
    from poshrk with (nolock) where varno=@varno and sil=0 and
     yertip=@yertip) dt on t.varno=@varno



  end
  
  
  
  if (@yertip='resvardimas') and (@islmtip='TAH') and (@islmhrk='POS')
  begin
  

    update resvardimas set postop=dt.postop,poscartop=dt.poscartp from
     resvardimas as t join
    (select isnull(sum(giren*kur),0) as postop,
    isnull(sum(case when carslip=1 then giren*kur else 0 end),0) as poscartp
    from poshrk with (nolock) where varno=@varno and sil=0 and
     yertip=@yertip) dt on t.varno=@varno



  end


  if (@yertip='pomvardimas') and (@islmtip='TAH') and (@islmhrk='POS')
  update pomvardimas set postop=dt.postop,poscartop=dt.poscartp from
     pomvardimas as t join
    (select isnull(sum(giren*kur),0) as postop,
    isnull(sum(case when carslip=1 then giren*kur else 0 end),0) as poscartp from
    poshrk with (nolock) where varno=@varno and sil=0 and
     yertip=@yertip) dt on t.varno=@varno
  
  
  if @masterid=0
     exec poshrkgiris @poshrkid



SET NOCOUNT OFF


END

================================================================================
