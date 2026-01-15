-- Function: dbo.UDF_FATURAHRK_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.715747
================================================================================

CREATE FUNCTION [dbo].UDF_FATURAHRK_RAP
(@FATIN          VARCHAR(8000))
RETURNS
  @TB_FATURA_RAP TABLE (
  FAT_ID                  VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_TIP                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_KOD                VARCHAR(30) COLLATE Turkish_CI_AS,
  STOK_AD                 VARCHAR(150) COLLATE Turkish_CI_AS,
  STOK_BIRIM              VARCHAR(30) COLLATE Turkish_CI_AS,
  MIKTAR                  FLOAT,
  BRIMFIYAT               FLOAT,
  KDVLIBRIMFIYAT          FLOAT,
  TUTAR                   FLOAT,
  KDVLITUTAR              FLOAT)
AS
BEGIN


    insert into @TB_FATURA_RAP
    (FAT_ID,STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,MIKTAR,
    BRIMFIYAT,KDVLIBRIMFIYAT,TUTAR,KDVLITUTAR)
    select 'F'+CAST(h.fatid AS varchar),st.tip,st.kod,st.ad,h.brim,
    (mik*carpan),
    round( ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut)),2),
    ROUND( ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))*(1+h.kdvyuz),2),
    ((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))*h.mik,
    (( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))* (1+h.kdvyuz))*h.mik
    from faturahrklistesi h WITH (NOLOCK)
    inner join gelgidlistok as st WITH (NOLOCK) on 
    h.stkod=st.kod and st.tip=h.stktip and h.sil=0
    where 'F'+CAST(h.fatid AS varchar) 
    in (select * from CsvToStr(@FATIN))
    
       
    insert into @TB_FATURA_RAP
    (FAT_ID,STOK_TIP,STOK_KOD,STOK_AD,STOK_BIRIM,MIKTAR,
    BRIMFIYAT,KDVLIBRIMFIYAT,TUTAR,KDVLITUTAR)
    select 'Z'+CAST(h.zrapid AS varchar),st.tip,st.kod,st.ad,'-',
    (miktar),
    round(brmfiy/(1+h.kdvyuz),2),
    round(brmfiy,2),
    ((brmfiy/(1+h.kdvyuz))*miktar),
    brmfiy*miktar
    from zraporhrk h WITH (NOLOCK)
    inner join Zrapor_UrunKart_Listesi as st WITH (NOLOCK)
    on h.kod=st.kod and st.tip=h.tip and h.sil=0
    where 'Z'+CAST(h.zrapid AS varchar) 
    in (select * from CsvToStr(@FATIN))
    

   RETURN


END

================================================================================
