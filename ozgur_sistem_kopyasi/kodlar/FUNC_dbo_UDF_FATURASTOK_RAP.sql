-- Function: dbo.UDF_FATURASTOK_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.716171
================================================================================

CREATE FUNCTION [dbo].UDF_FATURASTOK_RAP
(@FATIN          VARCHAR(4000),
@CARTIPIN        VARCHAR(300),
@CARIN           VARCHAR(8000),
@TARTIP          INT,
@BASTAR          DATETIME,
@BITTAR          DATETIME,
@AKSTKIN 		 VARCHAR(8000),
@MARSTKGRPIN  	 VARCHAR(8000),
@GELSTKIN  		 VARCHAR(8000)
)
RETURNS
  @TB_FATURA_RAP TABLE (
  FAT_ID                  INT,
  CARI_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  CARI_UNVAN              VARCHAR(150) COLLATE Turkish_CI_AS,
  FAT_SERINO              VARCHAR(30) COLLATE Turkish_CI_AS,
  FAT_AD                  VARCHAR(50) COLLATE Turkish_CI_AS,
  ISLEMTARIHI             DATETIME,
  VADETARIHI              DATETIME,
  STOK_TIP                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_GRPID              INT,
  STOK_AD                 VARCHAR(150) COLLATE Turkish_CI_AS,
  STOK_BIRIM              VARCHAR(30) COLLATE Turkish_CI_AS,
  KDV                     FLOAT,
  MIKTAR                  FLOAT,
  BRIMFIYAT               FLOAT,
  KDVLIBRIMFIYAT          FLOAT,
  TUTAR                   FLOAT,
  KDVLITUTAR              FLOAT,
  KDVTUTAR				  FLOAT)
AS
BEGIN


     if @TARTIP=0 /*işlem tarihine göre */
     insert into @TB_FATURA_RAP
     (FAT_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,MIKTAR,BRIMFIYAT,KDVLIBRIMFIYAT,
      TUTAR,KDVLITUTAR)
      select m.fatid,car.kod,car.ad,(fatseri+fatno) FATSERINO,m.fatad,
      m.tarih,m.vadtar,
      st.tip,st.kod,st.ad,h.brim,h.kdvyuz*100,(mik),
      ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)),
      ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))*(1+h.kdvyuz),
      ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))*h.mik,
      (( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))* (1+h.kdvyuz))*h.mik
      from faturamas as m WITH (NOLOCK) 
      inner join  faturahrklistesi as h WITH (NOLOCK)  
      on h.fatid=m.fatid and m.sil=0 and h.sil=0
      inner join Genel_Kart as car 
      on m.carkod=car.kod and m.cartip=car.cartp
      inner join gelgidlistok as st WITH (NOLOCK)
      on h.stkod=st.kod and st.tip=h.stktip
      where m.fattip_id in (select * from CsvToSTR(@FATIN) )
      and m.tarih>=@BASTAR and m.tarih<=@BITTAR
      and m.cartip in (select * from CsvToSTR(@CARTIPIN))
      /* and ( (@CARIN<>'' and m.carkod in (select * from CsvToSTR(@CARIN)) ) */
     /* or (@CARIN='' and m.carkod like '%') ) */
      order by st.kod
      
      
      
     if @TARTIP=1 /*işlem tarihine göre */
     insert into @TB_FATURA_RAP
     (FAT_ID,CARI_KOD,CARI_UNVAN,FAT_SERINO,FAT_AD,ISLEMTARIHI,VADETARIHI,
      STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,KDV,MIKTAR,BRIMFIYAT,TUTAR,KDVLITUTAR)
      select m.fatid,car.kod,car.ad,(fatseri+fatno) FATSERINO,m.fatad,m.tarih,m.vadtar,
      st.tip,st.kod,st.ad,h.brim,h.kdvyuz*100,(mik),(brmfiy),((brmfiy*mik)+otvtut),
      (((brmfiy*mik)+otvtut)*(1+KDVYUZ) )
      from faturamas as m  WITH (NOLOCK)
      inner join  faturahrk as h WITH (NOLOCK)
       on h.fatid=m.fatid and m.sil=0 and h.sil=0
      inner join Genel_Kart as car on m.carkod=car.kod and m.cartip=car.cartp
      inner join gelgidlistok as st WITH (NOLOCK) on h.stkod=st.kod and st.tip=h.stktip
      where m.fattip_id in (select * from CsvToSTR(@FATIN) )
      and m.vadtar>=@BASTAR and m.vadtar<=@BITTAR
      and m.cartip in (select * from CsvToSTR(@CARTIPIN))
      order by st.kod
      
      
      
      update @TB_FATURA_RAP set STOK_GRPID=
      case when k.grp3>0 then k.grp3
      when k.grp2>0 then k.grp2
      when k.grp1>0 then k.grp1 end
      from @TB_FATURA_RAP as t inner join stokkart as k
      on k.kod=t.STOK_KOD and t.STOK_TIP='markt'
      and t.STOK_TIP ='markt'
      
      
      
       delete from @TB_FATURA_RAP
  		where STOK_TIP='akykt' and  STOK_KOD not in (select * from CsvToSTR(@AKSTKIN))

       delete from @TB_FATURA_RAP
  		where STOK_TIP='gelgid' and STOK_KOD not in (select * from CsvToSTR(@GELSTKIN))
  
 	   delete from @TB_FATURA_RAP
  	    where STOK_TIP='markt' and STOK_GRPID not in (select * from CsvToSTR(@MARSTKGRPIN))
  
          

     if @CARIN<>'' 
      delete from  @TB_FATURA_RAP
      where CARI_KOD not in (select * from CsvToSTR(@CARIN)) 
      
      
      UPDATE @TB_FATURA_RAP set 
      KDVTUTAR=KDVLITUTAR-TUTAR



   RETURN


END

================================================================================
