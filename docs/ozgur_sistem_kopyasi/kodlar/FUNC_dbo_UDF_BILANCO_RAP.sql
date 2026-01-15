-- Function: dbo.UDF_BILANCO_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.689114
================================================================================

CREATE FUNCTION [dbo].UDF_BILANCO_RAP 
(@FIRMA_NO	 INT,
@RAP_KOD	 VARCHAR(30),
@KAY_ID		 INT,
@TARIH       DATETIME)
RETURNS
  
  @TABLE_BILANCO TABLE (
   ID					int,
   PAR_ID				int,
   Ana_Id				INT,
   Grp_No				Int,
   Deger_Tip			Int,
   Table_Id			    INT,
   Table_Name			VARCHAR(50) COLLATE Turkish_CI_AS,
   ACK					VARCHAR(100) COLLATE Turkish_CI_AS,
   DEGER				Float)
AS
BEGIN


    declare @mas_id	   		int
    declare @mashrk_id	   	int
    declare @id	   			int
    declare @Table_Id		int
    declare @Grp_No			int
    declare @deger			float
    
    declare @Top_Tutar		float
    
    
    declare @Deger_Tip			int
    
    
    declare @hrk_id	   		int
    
    declare @grp1_id	    int
    declare @grp2_id	    int
    declare @grp3_id	    int
    
    declare @grp1id 	 	int
    declare @grp2id 		int
    declare @ana_Id			int

    declare @ACK         	varchar(100)
    declare @Table_Name   	varchar(100)
    
    

     /*set @parentid=@id  */
   
    set @hrk_id=0


     declare mas_cur CURSOR FAST_FORWARD  FOR 
       select id,ack,Ana_Id from rapor_mas 
        where Rap_Kod=@RAP_KOD and sil=0 
        and Ana=1
        open mas_cur
          fetch next from  mas_cur into @grp1_id,@ACK,@ana_Id
           while @@FETCH_STATUS=0
            begin  

            set @Table_Name='rapor_mas'
            set @Table_Id=@grp1_id
            
             set @hrk_id=@hrk_id+1  
            
            insert into @TABLE_BILANCO 
            (ID,PAR_ID,Ana_Id,Grp_No,Table_Id,Table_Name,ACK,DEGER,Deger_Tip)
             VALUES  (@hrk_id,0,@ana_Id,0,@Table_Id,@Table_Name,@ACK,0,0)
             
             set  @mas_id=@hrk_id
             
             
           declare mas_bas CURSOR FAST_FORWARD  FOR 
           select id,ack,Ana_Id from rapor_mas 
            where Rap_Kod=@RAP_KOD and sil=0 
            and Ana=0 and ana_Id=@ana_Id
             open mas_bas
               fetch next from  mas_bas into @grp2_id,@ACK,@ana_Id
                while @@FETCH_STATUS=0
                 begin    
             
                 set @Table_Name='rapor_mas'
                 set @Table_Id=@grp2_id
                 
                  set @hrk_id=@hrk_id+1
             
             
                   insert into @TABLE_BILANCO 
                  (ID,PAR_ID,Ana_Id,Grp_No,Table_Id,
                  Table_Name,ACK,DEGER,Deger_Tip)
                   VALUES  (@hrk_id,@mas_id,@ana_Id,1,
                   @Table_Id,@Table_Name,@ACK,0,0)
             
             	            
                      set @mashrk_id=@hrk_id
             
                           
                        declare mas_hrk CURSOR FAST_FORWARD  FOR 
                         select id,ack,Deger_Tip 
                         from Rapor_Grup_Kriter
                          where Rap_Kod=@RAP_KOD and sil=0 and 
                            mas_Id=@grp2_id 
                           open mas_hrk  
                          
                          fetch next from  mas_hrk into 
                          @grp3_id,@ACK,@Deger_Tip
                            while @@FETCH_STATUS=0
                              begin
                             
                             set @Table_Name='Rapor_Grup_Kriter' 
                             set @Table_Id=@grp3_id
                             
                              set @hrk_id=@hrk_id+1     
                           
                          
                            /* kart hrk sesaplatma */
                          
                            set @deger=
                            dbo.UDF_RAPOR_DEGER_TUTAR 
                            (@FIRMA_NO,@RAP_KOD,@grp3_id,@KAY_ID,0,@TARIH)
                        
                                                 
                              insert into @TABLE_BILANCO 
                              (ID,PAR_ID,Ana_Id,Grp_No,
                              Table_Id,Table_Name,ACK,DEGER,Deger_Tip)
                              VALUES  (@hrk_id,@mashrk_id,@ana_Id,2,
                              @Table_Id,@Table_Name,@ACK,@Deger,@Deger_Tip)
                
                            
                              
                                                     
                          FETCH next from  mas_hrk into @grp3_id,@ACK,@Deger_Tip
                         end
                        Close mas_hrk
                        deallocate mas_hrk  
                        
                        
                      select @Top_Tutar=
                       Sum(Deger) from @TABLE_BILANCO     
                      where PAR_ID=@mashrk_id 
             
                      UPDATE @TABLE_BILANCO 
                      SET DEGER=@Top_Tutar
                      where ID=@mashrk_id   
                        
                        
                        
                  FETCH next from  mas_bas into @grp2_id,@ACK,@Ana_Id
               end
              Close mas_bas
              deallocate mas_bas
                        
              select @Top_Tutar=
               Sum(Deger) from @TABLE_BILANCO     
               where PAR_ID=@mas_id 
             
              UPDATE @TABLE_BILANCO 
               SET DEGER=@Top_Tutar
              where ID=@mas_id 
             
             
             
          FETCH next from  mas_cur into @grp1_id,@ACK,@Ana_Id
         end
        Close mas_cur
        deallocate mas_cur  





  RETURN




END

================================================================================
