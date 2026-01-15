-- Stored Procedure: dbo.hrk_sil
-- Tarih: 2026-01-14 20:06:08.335523
================================================================================

CREATE PROCEDURE [dbo].hrk_sil
@tablead varchar(30),
@hrkid int,
@firmano int,
@deguser varchar(50)
AS
BEGIN
declare @masid int
declare @karsihestip varchar(20)
declare @degtarsaat datetime
declare @cartip     varchar(20)

set @degtarsaat=getdate()

 if @tablead='kasahrk'
 begin
 select @hrkid=kashrkid,@masid=masterid,@karsihestip=karsihestip,
 @cartip=cartip from kasahrk with (nolock)
 where kashrkid=@hrkid /*firmano=@firmano */
 update kasahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
 where kashrkid=@hrkid
 
 
 if isnull(@hrkid,0)>0
  begin
  
   if @karsihestip='bankakart'
   update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
   where bankhrkid=@masid
 
   if @karsihestip='carikart'
   update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
   where carhrkid=@masid

  if @cartip='istkart'
  update istkhrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
  where masterid=@hrkid and karsihestip='kasakart'

 end


 end


 if @tablead='carihrk'
 begin
 select @hrkid=carhrkid,@masid=masterid,@karsihestip=karsihestip 
 from carihrk with (nolock)  where carhrkid=@hrkid
 
 if isnull(@hrkid,0)>0
  begin
     update carihrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
     where carhrkid=@hrkid

     if @karsihestip='bankakart'
     update bankahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
     where bankhrkid=@masid 

     if @karsihestip='kasakart'
     update kasahrk set sil=1,deguser=@deguser,degtarsaat=@degtarsaat
     where kashrkid=@masid 
  end
 end


 if @tablead='poshrk'
 begin
    select @hrkid=poshrkid,@masid=masterid/*,@karsihestip=karsihestip */
    from poshrk with (nolock)  where poshrkid=@hrkid

 end

 if @tablead='bankhrk'
 begin
 select @hrkid=bankhrkid,@masid=masterid,@karsihestip=karsihestip
 from bankahrk with (nolock) where bankhrkid=@hrkid
 end

 if @tablead='istkhrk'
 begin
 select @hrkid=istkhrkid,@masid=masterid,@karsihestip=karsihestip
  from istkhrk  with (nolock) where istkhrkid=@hrkid

 end


END

================================================================================
