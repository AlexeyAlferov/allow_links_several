-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** FACILITY_OPERATING_HOURS_VW
CREATE VIEW FACILITY_OPERATING_HOURS_VW as 
select 

FAC_ID 				,
FAC_NAME 			,
Monday_OPEN_AT 		,
Monday_CLOSE_AT 	,
Tuesday_OPEN_AT 	,
Tuesday_CLOSE_AT 	,
Wednesday_OPEN_AT 	,
Wednesday_CLOSE_AT  ,
Thursday_OPEN_AT 	,
Thursday_CLOSE_AT 	,
Friday_OPEN_AT 		,
Friday_CLOSE_AT 	,
Saturday_OPEN_AT 	,
Saturday_CLOSE_AT 	,
Sunday_OPEN_AT 		,
Sunday_CLOSE_AT 	

from
(
select
FAC_ID 				,
FAC_NAME 			,
Monday_OPEN_AT 		,
Monday_CLOSE_AT 	,
Tuesday_OPEN_AT 	,
Tuesday_CLOSE_AT 	,
Wednesday_OPEN_AT 	,
Wednesday_CLOSE_AT  ,
Thursday_OPEN_AT 	,
Thursday_CLOSE_AT 	,
Friday_OPEN_AT 		,
Friday_CLOSE_AT 	,
Saturday_OPEN_AT 	,
Saturday_CLOSE_AT 	,
Sunday_OPEN_AT 		,
Sunday_CLOSE_AT 	,
DATA_COLLCTION_ADD_DELETE_UPDATE,
row_number() over (partition by fac_id order by last_updated_dtm desc nulls last) as rnk
from stg.FACILITY_OPERATING_HOURS_BMT_DATA_COLLCTN
)  where rnk=1 and DATA_COLLCTION_ADD_DELETE_UPDATE != 'D'
;
