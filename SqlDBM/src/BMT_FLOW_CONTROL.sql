-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** BMT_FLOW_CONTROL
CREATE VIEW BMT_FLOW_CONTROL as

select * from

(select

 PKEY ,

 RULE_TYPE ,

 LOB ,

 WASTE_TYPE ,

 METHOD_TYPE ,

 TIME_HORIZON_NM ,

 NOTES ,

 SRC_HAULING_SITE_ID ,

 SRC_COUNTY_NM ,

 SRC_CITY_NM ,

 SRC_CUSTOMER_NM ,

 SRC_MARKET_AREA_CD ,

 CASE WHEN DEST_DISPOSAL_SITE_ID = '' THEN ''

 ELSE DEST_DISPOSAL_SITE_ID ||'_' ||

    case when DEST_DISPOSAL_SITE_TYPE = 'Transfer Station' then 'TS'

        when DEST_DISPOSAL_SITE_TYPE = 'MRF Recycling' then 'MRF'

        else DEST_DISPOSAL_SITE_TYPE

    end

 END as DEST_DISPOSAL_SITE_ID,

 case when DEST_DISPOSAL_SITE_TYPE = 'Transfer Station' then 'TS'

     when DEST_DISPOSAL_SITE_TYPE = 'MRF Recycling' then 'MRF'

     else DEST_DISPOSAL_SITE_TYPE

 end as DEST_DISPOSAL_SITE_TYPE,

 DEST_COUNTY_NM ,

 DEST_CITY_NM     ,

 DEST_MARKET_AREA_CD ,

 CUSTOMER_NM ,

 MIN_TONS ,

 MAX_TONS ,

 SPECIAL_RATE_AMT ,

 LAST_UPDATED_DTM ,

 LAST_UPDATED_USER,

 DATA_COLLCTION_ADD_DELETE_UPDATE ,

row_number() over (partition by PKEY order by last_updated_dtm desc nulls last) as rnk,

 ACTIVE_FLAG,

 SRC_STATE_CD,

 DEST_STATE_CD,

 SRC_HAULING_SITE_NM,

 DEST_DISPOSAL_SITE_NM,

 SRC_OCS_DISPOSAL_CD,             --Added New column

 SRC_STATE_NM,

 DEST_STATE_NM,

 SRC_OCS_DISPOSAL_NM

 from STG.FACILITY_FLOW_CONTROL_BMT_DATA_COLLCTN

 )  where rnk=1;
