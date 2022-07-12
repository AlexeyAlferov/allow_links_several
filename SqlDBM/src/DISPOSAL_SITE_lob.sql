-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** DISPOSAL_SITE_lob
CREATE VIEW DISPOSAL_SITE_lob 

AS 

  SELECT Coalesce(t3.fac_id, t4.fac_id) AS FAC_ID, 

         Coalesce(t3.lob_cd, t4.lob_cd) AS LOB_CD, 

         CASE 

           WHEN t3.cycle_minute_cnt IS NULL 

                 OR t3.cycle_minute_cnt = 0 THEN T4.cycle_minute_cnt -- prefer CORP data to zeros or nulls

           ELSE t3.cycle_minute_cnt 

         END                            AS CYCLE_MINUTE_CNT,  

         last_updated_dtm, 

         last_updated_user, 

         data_collction_add_delete_update 

--

-- Coalesce the CORP data and the BMT data like what we normally do

-- Be sure to do the Delete check on the outside so that it applies to all the facilities including the defaults

--

  FROM   (SELECT Coalesce(t1.fac_id, t2.fac_id) AS FAC_ID, 

                 Coalesce(t1.lob_cd, t2.lob_cd) AS LOB_CD, 

                 CASE 

                   WHEN t1.cycle_minute_cnt IS NULL 

                         OR t1.cycle_minute_cnt = 0 THEN T2.cycle_minute_cnt 

                   ELSE t1.cycle_minute_cnt 

                 END                            AS CYCLE_MINUTE_CNT, 

                 last_updated_dtm, 

                 last_updated_user, 

                 data_collction_add_delete_update 

          FROM   BMT_DISPOSAL_SITE_LOB t1 

                 full outer join corp_disposal_lob t2 

                              ON T1.fac_id = T2.fac_id 

                                 AND T1.lob_cd = T2.lob_cd) t3 

--

--	Second full outer join to the defaults table

--

         full outer join TURN_TIME_DEFAULTS t4 

                      ON T3.fac_id = T4.fac_id 

                         AND T3.lob_cd = T4.lob_cd 

  WHERE  Nvl(data_collction_add_delete_update, 'A') != 'D';
