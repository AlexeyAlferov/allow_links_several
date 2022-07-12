-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** FACILITY_VOLUME_CONSTRAINT_ADJUST_FACTOR
CREATE VIEW FACILITY_VOLUME_CONSTRAINT_ADJUST_FACTOR AS 
select cnst.FAC_ID, 
       cnst.FAC_TYPE, 
case when VOLUME_TIME_UNIT = 'Daily'     then 1
     when VOLUME_TIME_UNIT = 'Monthly'   then 30 - (FACILITY_CLOSED_DAYS_IN_SCOPE*4.3)
     when VOLUME_TIME_UNIT = 'Quarterly' then 90 - (FACILITY_CLOSED_DAYS_IN_SCOPE*13)
     when VOLUME_TIME_UNIT = 'Yearly'    then 90 - (FACILITY_CLOSED_DAYS_IN_SCOPE*52)
end volume_adjust_factor 
from
(select FAC_ID, FAC_TYPE,VOLUME_TIME_UNIT 
from mart.LH_SITE s 
) cnst
left join 
(select FAC_ID, FAC_TYPE, COUNT(distinct Closed_day) FACILITY_CLOSED_DAYS_IN_SCOPE
from mart.BMT_FACILITY_CLOSED_DAYS_VW cls
GROUP BY 1,2) clsd
on cnst.FAC_ID=clsd.FAC_ID
and cnst.FAC_TYPE = clsd.FAC_TYPE;