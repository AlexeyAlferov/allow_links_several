-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_DISPOSAL_SITE_LOB
CREATE VIEW LH_DISPOSAL_SITE_LOB as
 select 
	substring(FAC_ID,1,6) as FAC_ID,
	CASE when substring(FAC_ID,8) = 'TS' then 'Transfer Station'
    when substring(FAC_ID,8) = 'MRF' then 'MRF Recycling' else
    substring(FAC_ID,8) end  as FAC_TYPE,
	LOB_CD,
	CYCLE_MINUTE_CNT,
	LAST_UPDATED_DTM,
	LAST_UPDATED_USER,
	DATA_COLLCTION_ADD_DELETE_UPDATE
 from DISPOSAL_SITE_LOB;
