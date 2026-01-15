-- Function: dbo.Belge_No_Getir
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.645232
================================================================================

CREATE FUNCTION [dbo].Belge_No_Getir
(@firmano              int,
@seriver               bit,
@belgetip              varchar(10),
@seri                  varchar(10))
RETURNS
   @TB_BELGE_SERI_NO TABLE (
    BELGE_SERI           VARCHAR(10) COLLATE Turkish_CI_AS,
    BELGE_SERINO         FLOAT)
AS
BEGIN


declare @max_id      int
declare @HRK_SERINO  float

declare @HRK_SERI    varchar(10)
set @HRK_SERI=@seri


  /*-Promosyon Fis */
    if (@belgetip='PRS') 
     begin
     
     
     if @seriver=1
       select top 1
       @HRK_SERINO=isnull(v.no,0),
       @HRK_SERI=isnull(v.seri,'') from 
       Prom_Sat_Baslik as v WITH (NOLOCK) where sil=0
        and ISNUMERIC(v.no)=1 and firmano=@firmano
        and v.seri <>'AUTO' order by id desc
        
     if @seriver=0
       select top 1
       @HRK_SERINO=isnull(v.no,0),
       @HRK_SERI=@seri from 
       Prom_Sat_Baslik as v WITH (NOLOCK) where sil=0
        and v.seri=@seri and firmano=@firmano
        and ISNUMERIC(v.no)=1
        and v.seri <>'AUTO' order by id desc
        
        
        
       if @HRK_SERINO is null
       insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,'1'
        else
        insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,@HRK_SERINO+1
     end


  /*-Zrapor */
    if (@belgetip='ZRAP') 
     begin
     
     
     if @seriver=1
       select top 1
       @HRK_SERINO=isnull(v.zserino,0),
       @HRK_SERI=isnull(v.zseri,'') from 
       zrapormas as v WITH (NOLOCK) where sil=0
        and ISNUMERIC(v.zserino)=1 and firmano=@firmano
        order by id desc
        
     if @seriver=0
       select top 1
       @HRK_SERINO=isnull(v.zserino,0),
       @HRK_SERI=@seri from 
       zrapormas as v WITH (NOLOCK) where sil=0
        and v.zserino=@seri and firmano=@firmano
        and ISNUMERIC(v.zserino)=1
        order by id desc
        
        
        
       if @HRK_SERINO is null
       insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,'1'
        else
        insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,@HRK_SERINO+1
     end

   /*-fisler */
    if (@belgetip='FIS') 
     begin
     
     
     if @seriver=1
       select top 1
       @HRK_SERINO=isnull(v.no,0),
       @HRK_SERI=isnull(v.seri,'') from veresimas as v 
       WITH (NOLOCK) where sil=0
        and ISNUMERIC(v.no)=1 and firmano=@firmano
        and v.seri <>'AUTO' and bagid=0 order by id desc
        
     if @seriver=0
       select top 1
       @HRK_SERINO=isnull(v.no,0),
       @HRK_SERI=@seri from veresimas as v WITH (NOLOCK) where sil=0
        and v.seri=@seri and firmano=@firmano
        and ISNUMERIC(v.no)=1
        and v.seri <>'AUTO' and bagid=0 order by id desc
        
        
        
       if @HRK_SERINO is null
       insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,'1'
        else
        insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,@HRK_SERINO+1
     end

   /*-faturalar */
    if (@belgetip='FAT')
     begin

     if @seriver=1
       select top 1
       @max_id=(id),
       @HRK_SERINO=isnull(f.fatno,0),
       @HRK_SERI=isnull(f.fatseri,'') from faturamas as f 
       WITH (NOLOCK) where sil=0
        and firmano=@firmano
        /*and f.fattip=@islemtip */
         and f.gctip=2 
         and ISNUMERIC(f.fatno)=1
        order by id desc
        
        
       if @seriver=0
       select top 1
       @max_id=(id),
       @HRK_SERINO=isnull(f.fatno,0),
       @HRK_SERI=@seri from faturamas as f WITH (NOLOCK)
        where sil=0
         and firmano=@firmano
         and f.fatseri=@seri
         and f.gctip=2 
         and ISNUMERIC(f.fatno)=1
        order by id desc   
        
        

      
        if @HRK_SERINO is null
       insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,'1'
        else
        insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,@HRK_SERINO+1
       
     end
     
     
     
     /*-irsaliye */
    if (@belgetip='IRS')
     begin

     if @seriver=1
       select top 1
       @max_id=(id),
       @HRK_SERINO=isnull(f.irno,0),
       @HRK_SERI=isnull(f.irseri,'') from irsaliyemas as f 
       WITH (NOLOCK) where sil=0
        and firmano=@firmano
        /*and f.fattip=@islemtip */
         and f.gctip=2 
         and ISNUMERIC(f.irno)=1
        order by id desc
        
        
       if @seriver=0
       select top 1
       @max_id=(id),
       @HRK_SERINO=isnull(f.irno,0),
       @HRK_SERI=@seri from irsaliyemas as f WITH (NOLOCK)
        where sil=0
         and firmano=@firmano
         and f.irseri=@seri
         and f.gctip=2 
         and ISNUMERIC(f.irno)=1
        order by id desc   
        
        

      
        if @HRK_SERINO is null
         insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,'1'
        else
        insert into @TB_BELGE_SERI_NO (BELGE_SERI,BELGE_SERINO)
        select @HRK_SERI,@HRK_SERINO+1
       
     end


RETURN

END

================================================================================
