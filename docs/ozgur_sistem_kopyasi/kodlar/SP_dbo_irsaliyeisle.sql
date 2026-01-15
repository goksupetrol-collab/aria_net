-- Stored Procedure: dbo.irsaliyeisle
-- Tarih: 2026-01-14 20:06:08.337217
================================================================================

CREATE PROCEDURE [dbo].irsaliyeisle @fatid float
AS
BEGIN
declare @kaptip varchar(30)
declare @tarih  datetime
declare @sql    nvarchar(500)
declare @kayok  int
declare @sil    int


declare @cartip varchar(20)
declare @carkod varchar(50)

select @kayok=kayok,@sil=sil,@tarih=tarih,
@sql=kapidler,@kaptip=kaptip
from faturamas where fatid=@fatid

 if @kaptip='IRS'
  begin

     if @kayok=1 and @sil=0
      begin
      update irsaliyemas set aktip='FT',aktar=@tarih,akid=@fatid where fatid=@fatid
        
        
      update irsaliyehrk set 
       brmfiy=(dt.brmfiy+isnull(dt.otvbrim,0)),
       Mik=dt.mik,
       satiskyuz=dt.satiskyuz,
       satisktut=dt.satisktut,
       geniskyuz=dt.geniskyuz, 
       genisktut=dt.genisktut
       from irsaliyehrk as t join 
       (select kaphrkid,brmfiy,otvbrim,mik,
       satiskyuz,satisktut,geniskyuz,genisktut
       from faturahrk as h with (nolock) where fatid=@fatid)
       dt on dt.kaphrkid=t.id
       
       exec irsaliye_topyaz @fatid

        
      end  

     if @sil=1
     begin
      select @cartip=cartip,@carkod=carkod from irsaliyemas where fatid=@fatid

      update irsaliyemas set aktip='BK',aktar=NULL,akid=0,fatid=0 where fatid=@fatid
            
       
    end
  end


END

================================================================================
