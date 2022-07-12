-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** DISPOSAL_SITE
CREATE VIEW DISPOSAL_SITE as (SELECT 
  "FAC_ID", 
  "FAC_TYPE", 
  "WM_OWNED_FLAG", 
  "FAC_NAME", 
  "FAC_SHORT_NM", 
  "ACTIVE_FLAG", 
  "MARKET_AREA_CD", 
  "MARKET_AREA_NM", 
  "LATITUDE", 
  "LONGITUDE", 
  "ADDRESS_1", 
  "ADDRESS_2", 
  "CITY_NM", 
  "STATE_CD", 
  "ZIP_CD", 
  "COUNTRY_CD", 
  "COUNTY_NM", 
  "FIXED_COST", 
  "UNIT_COST", 
  "SOURCE", 
  "LAST_UPDATED_DTM", 
  "LAST_UPDATED_USER", 
  "MONDAY_OPEN_AT", 
  "MONDAY_CLOSE_AT", 
  "TUESDAY_OPEN_AT", 
  "TUESDAY_CLOSE_AT", 
  "WEDNESDAY_OPEN_AT", 
  "WEDNESDAY_CLOSE_AT", 
  "THURSDAY_OPEN_AT", 
  "THURSDAY_CLOSE_AT", 
  "FRIDAY_OPEN_AT", 
  "FRIDAY_CLOSE_AT", 
  "SATURDAY_OPEN_AT", 
  "SATURDAY_CLOSE_AT", 
  "SUNDAY_OPEN_AT", 
  "SUNDAY_CLOSE_AT", 
  "GEO_CITY_NM", 
  "GEO_COUNTY_NM", 
  "GEO_STATE_CD", 
  "GEO_ZIP_CD" 
FROM (select
coalesce( t1.FAC_ID, t2.FAC_ID) as FAC_ID,
coalesce( t1.FAC_TYPE, t2.FAC_TYPE) as FAC_TYPE,
coalesce( t1.WM_OWNED_FLAG, t2.WM_OWNED_FLAG) as WM_OWNED_FLAG,
coalesce( t1.FAC_NAME, T2.FAC_NAME) as FAC_NAME,
t1.FAC_SHORT_NM as FAC_SHORT_NM,
coalesce( t1.ACTIVE_FLAG, t2.ACTIVE_FLAG) as ACTIVE_FLAG,
coalesce( t1.MARKET_AREA_CD, t2.MARKET_AREA_CD) as MARKET_AREA_CD,
coalesce( t1.MARKET_AREA_NM, T2.MARKET_AREA_NM) AS MARKET_AREA_NM,
coalesce( t1.LATITUDE, t2.LATITUDE) as LATITUDE,
coalesce( t1.LONGITUDE, t2.LONGITUDE) as LONGITUDE,
coalesce( t1.ADDRESS_1, t2.ADDRESS_1) as ADDRESS_1,
coalesce( t1.ADDRESS_2, t2.ADDRESS_2) as ADDRESS_2,
coalesce( t1.CITY_NM, t2.CITY_NM) as CITY_NM,
coalesce( t1.STATE_CD, t2.STATE_CD) as STATE_CD,
coalesce( t1.ZIP_CD, t2.ZIP_CD) as ZIP_CD,
coalesce( t1.COUNTRY, t2.COUNTRY_CD) as COUNTRY_CD,
coalesce( t1.COUNTY_NM, t2.COUNTY_NM) as COUNTY_NM,
t1.FIXED_COST,
case when t1.UNIT_COST is null or t1.UNIT_COST=0 then T2.UNIT_COST else t1.UNIT_COST end as UNIT_COST,
case when t1.FAC_ID is not null then 'LH' else 'MART' end as SOURCE,
LAST_UPDATED_DTM,
LAST_UPDATED_USER,
Monday_OPEN_AT,
Monday_CLOSE_AT,
Tuesday_OPEN_AT,
Tuesday_CLOSE_AT,
Wednesday_OPEN_AT,
Wednesday_CLOSE_AT,
Thursday_OPEN_AT,
Thursday_CLOSE_AT,
Friday_OPEN_AT,
Friday_CLOSE_AT,
Saturday_OPEN_AT,
Saturday_CLOSE_AT,
Sunday_OPEN_AT,
Sunday_CLOSE_AT,
t1.GEO_CITY_NM,
t1.GEO_COUNTY_NM,
t1.GEO_STATE_CD,
t1.GEO_ZIP_CD
from DEV_ONEWM.MART.BMT_DISPOSAL_SITE t1
left outer join DEV_ONEWM.MART.BMT_FACILITY_OPERATING_HOURS_VW FH
on t1.FAC_ID = FH.FAC_ID --AND FH.FAC_TYPE=t1.FAC_TYPE
full outer join DEV_ONEWM.MART.CORP_DISPOSAL_SITE t2 on T1.FAC_ID = T2.FAC_ID
where nvl(DATA_COLLCTION_ADD_DELETE_UPDATE,'A') != 'D'
) AS "v_0000017686_0000143765");