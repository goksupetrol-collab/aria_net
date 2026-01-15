-- Stored Procedure: dbo.marvarozet
-- Tarih: 2026-01-14 20:06:08.348473
================================================================================

CREATE PROCEDURE [dbo].marvarozet @varno float,@tip varchar(10),@tipdty varchar(10)
AS
BEGIN

declare @sql 		nvarchar(500)
declare @acik 		float
declare @fazla 		float
declare @perkod 	varchar(50)
declare @perad 		varchar(50)
declare @yertip 	varchar(20)

set @yertip='marvardimas'

SET NOCOUNT ON

if object_id( 'tempdb..##marvardiozet' ) is null
CREATE TABLE [dbo].[##marvardiozet] (
  [id] numeric(18, 0) IDENTITY(1, 1) NOT NULL,
  [varno] float NOT NULL,
  [perkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [perad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [ada] varchar(50) COLLATE Turkish_CI_AS NULL,
  [grs] float  DEFAULT 0 NULL,
  [cks] float DEFAULT 0 NULL,
  [ickkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [ickad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [sr] float NULL,
  PRIMARY KEY  ([id], [varno]))
  delete from ##marvardiozet where varno=@varno

/*
AKSAT
VERAT
VERBT
VEROT
POSST
MALST
NAKTS
ODETT
CAROD
PEROD
PRKOD
TAHTT
CARTH
PERTH
PRKTH
GELIR
GIDER

*/


DECLARE marvardiozetx CURSOR FAST_FORWARD FOR SELECT varno from marvardimas  WITH (NOLOCK) where varno=@varno
  OPEN marvardiozetx
  FETCH NEXT FROM marvardiozetx INTO  @varno
   WHILE @@FETCH_STATUS = 0
    BEGIN

       insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
       select @varno,'MRSAT','Market Satış - İade Tutarı',1,@perkod,@perad,
       isnull(sum(case when h.islmtip='satis' then round(h.mik*(h.brmfiy)*h.kur,2) else 0 end),0),
       isnull(sum(case when h.islmtip='iade' then round(h.mik*(h.brmfiy)*h.kur,2) else 0 end),0) 
       from marsathrk as h WITH (NOLOCK) inner join marsatmas as m  WITH (NOLOCK) on m.marsatid=h.marsatid
       where m.varno=@varno and m.sil=0 and h.sil=0 

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'BZPAR','Bozuk Para Tutarı',2.0,@perkod,@perad,isnull(sum(bozukpara),0),0 from 
      marvardimas WITH (NOLOCK)
      where varno=@varno 

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'VERAT','Veresiye Alacak Tutarı',2.1,@perkod,@perad,isnull(sum(toptut-(fiyfarktop+vadfarktop)),0),0 
      from veresimas WITH (NOLOCK)
      where varno=@varno and fistip='FISALCSAT' and sil=0 and adaid=@perkod and ototag=0 and yertip=@yertip


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'VERBT','Veresiye Borç Tutarı',2.2,@perkod,@perad,0,isnull(sum(toptut-(fiyfarktop+vadfarktop)),0) 
      from veresimas WITH (NOLOCK)
      where varno=@varno and fistip='FISVERSAT' and sil=0 and ototag<>1 and yertip=@yertip



      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'POSST','Pos Satış Tutarı',3,@perkod,@perad,
      isnull(sum(case when carslip=1 then giren*kur else 0 end),0),
      isnull(sum(giren*kur),0) from poshrk WITH (NOLOCK)
      where varno=@varno and sil=0 and ((yertip='marvardimas') or (yertip='yazarkasa')  or (yertip='promakscsv')  )

      /*
      update ##marvardiozet set grs=dt.giris from ##marvardiozet t join
      (select isnull(sum(giren*kur),0) as giris from poshrk where
      varno=@varno and carkod<>'' and sil=0 and yertip=@yertip)
      dt on t.ickkod='POSST' and t.perkod=@perkod
      */

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'GIDER','Gider Tutarı',5,@perkod,@perad,0,isnull(sum(borc*kur),0) 
      from carihrk WITH (NOLOCK)
      where varno=@varno and
      ( (islmtip='ODE') OR (islmhrk='IND') and (islmtip='GLG') OR (islmhrk='MAR') ) and cartip='gelgidkart' and sil=0 and yertip=@yertip


      if @tipdty='genel'
      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk WITH (NOLOCK)
      where varno=@varno and ((islmtip='ODE' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='YTN') )
      and sil=0 and yertip=@yertip

      if @tipdty='detay'
      begin

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      values (@varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,0)


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'CAROD','Cari Ödemeler',8,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk WITH (NOLOCK)
      where varno=@varno and (islmtip='ODE' and cartip='carikart') and sil=0 and yertip=@yertip


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'PEROD','Personel Ödemeler',10,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk WITH (NOLOCK)
      where varno=@varno and (islmtip='ODE' and cartip='perkart') and sil=0 and yertip=@yertip

      end;


      if @tipdty='genel'
      begin
      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk WITH (NOLOCK)
      where varno=@varno and ((islmtip='TAH' and islmhrk<>'TES' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='CKN') )
      and sil=0 and yertip=@yertip
      end;


      if @tipdty='detay'
      begin
      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      values (@varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,0,0);


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'CARTH','Cari Tahsilat',9,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk WITH (NOLOCK)
      where varno=@varno and (islmtip='TAH' and islmhrk<>'TES' and cartip='carikart')
      and sil=0 and yertip=@yertip

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'PERTH','Personel Tahsilat',11,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk WITH (NOLOCK)
      where varno=@varno and (islmtip='TAH' and islmhrk<>'TES' and cartip='perkart') and sil=0  and yertip=@yertip


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'PRKTH','Perakende Tahsilat',13,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk WITH (NOLOCK)
      where varno=@varno and (islmtip='TAH' and islmhrk<>'TES' and cartip='perakendekart') and sil=0 and yertip=@yertip

      end;



      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'GELIR','Gelir Tutarı',20,@perkod,@perad,isnull(sum(alacak*kur),0),0 from carihrk WITH (NOLOCK)
      where varno=@varno and islmtip='TAH' and islmhrk<>'TES' and cartip='gelgidkart' and sil=0 and yertip=@yertip



      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'NAKTS','Nakit Teslimat Tutarı',21,@perkod,@perad,0,isnull(sum(giren*kur),0) from kasahrk WITH (NOLOCK)
      where varno=@varno and sil=0 and yertip=@yertip and islmtip='TAH' AND islmhrk='TES' and masterid=0


      if @tipdty='detay'
      begin

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'CEKST','Çek-Senet',25,@perkod,@perad,isnull(sum(giren*kur),0),isnull(sum(cikan*kur),0) from cekkart WITH (NOLOCK)
      where varno=@varno and sil=0 and yertip=@yertip

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'BNKCK','Banka Çekilen',26,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk WITH (NOLOCK)
      where varno=@varno and islmtip='BNK' and islmhrk='CKN' and sil=0 and yertip=@yertip

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'BNKYT','Banka Yatan',27,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk WITH (NOLOCK)
      where varno=@varno and islmtip='BNK' and islmhrk='YTN' and sil=0 and yertip=@yertip
      
      
      
      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
       select @varno,'BNKEF','Banka Gelen EFT',28,@perkod,@perad,0,isnull(sum(borc*kur),0) from bankahrk 
       with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='C-B' and sil=0 and carkod='VRDHES'
       and yertip=@yertip


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
       select @varno,'BNKEF','Banka Giden EFT',29,@perkod,@perad,isnull(sum(alacak*kur),0),0 from bankahrk 
       with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='B-C' and sil=0 and carkod='VRDHES'
       and yertip=@yertip
      
      
      
      end;
      
      
      
      if @tipdty='genel' /* diğer satışlar olusturuluyor */
       begin

        insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
        select @varno,'DIGST','Diğer Tutarlar',39,@perkod,@perad,
        isnull(sum(case when cartip<>'vardicek' then giren*kur else 0 end),0),
        isnull(sum(giren*kur),0) from cekkart with (nolock)
        where varno=@varno and sil=0 and yertip=@yertip
       
       
        
         UPDATE ##marvardiozet SET grs=grs+giren,cks=cks+cikan from ##marvardiozet as t join
         (select isnull(sum(alacak*kur),0) as giren,isnull(sum(borc*kur),0) cikan from bankahrk with (nolock)
          where varno=@varno and islmtip='BNK' and islmhrk in ('C-B','B-C') and sil=0 and carkod='VRDHES' 
          and yertip=@yertip ) dt on t.sr=39 

      end

      
      
      
      


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      select @varno,'aratp','Ara Toplam',40,@perkod,@perad,sum(grs),sum(cks) from ##marvardiozet where varno=@varno


      select @acik=(grs-cks) from ##marvardiozet where ickkod='aratp' and varno=@varno

      if @acik<0
      begin
      set @fazla=0;
      set @acik=-@acik;
      end
      else
      begin
      set @fazla=@acik;
      set @acik=0;
      end;

      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      values(@varno,'ackfz','Fark',41,@perkod,@perad,@acik,@fazla) ;

      select @acik=sum(grs),@fazla=sum(cks) from ##marvardiozet where (ickkod='aratp' or ickkod='ackfz') and varno=@varno 


      insert into ##marvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
      values(@varno,'gentp','Genel Toplam',42,@perkod,@perad,@acik,@fazla) ;



  FETCH NEXT FROM marvardiozetx INTO  @varno
  END
  CLOSE marvardiozetx
  DEALLOCATE marvardiozetx



SET NOCOUNT OFF

/*select sr as id,varno,ickkod,ickad,sr,sum(grs) grs,sum(cks) cks from pomvardiozet */
/*where varno=@varno group by varno,ickkod,ickad,sr order by sr */



END

================================================================================
