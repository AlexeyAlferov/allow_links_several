-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** TMS_MARKET_AREAS
CREATE VIEW TMS_MARKET_AREAS as (SELECT 
  "FAC_ID", 
  "FAC_MA_NM", 
  "FAC_MA_IDU" 
FROM (--
--  Lets get the TMS destination facilities.  Here is the logic we are implmenting:-
--  For each destination assume the MA associated with the origin.
--  If a detination is attached to multiple MAs then choose the one with the most entries in the TMS contracts table
--  Only consider non-S0 destinations
--
SELECT 
  LANE_DESTINATION_CODE as FAC_ID, 
  FAC_MA_NM, 
  FAC_MA_IDU 
from 
  (
    select 
      LANE_DESTINATION_CODE, 
      FAC_MA_NM, 
      FAC_MA_IDU, 
      row_number() over (
        partition by LANE_DESTINATION_CODE 
        order by 
          COUNT(*) desc nulls last
      ) as rnk 
    from 
      DEV_ONEWM.MART.TMS_CONTRACT_RATES_VW t1, 
      DEV_CORPDB.ODS.RDN2_FAC_FULL t2 
    where 
      t1.LANE_ORIGIN_CODE = t2.FAC_IDU 
      and t1.LANE_DESTINATION_CODE not like 'S0%' -- not only S0
      and t1.LANE_DESTINATION_CODE not like 'S1%' 
      and t1.LANE_DESTINATION_CODE not like 'S5%' 
    group by 
      LANE_DESTINATION_CODE, 
      FAC_MA_NM, 
      FAC_MA_IDU
  ) 
where 
  rnk = 1
) AS "v_0000017686_0000143682");
