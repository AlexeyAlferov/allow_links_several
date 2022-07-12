-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_LOCATION_MATCHING
CREATE VIEW LH_LOCATION_MATCHING as

select t1.HAULING_SITE_id, t3.fac_name as HAULING_SITE_name, t1.ocs_disposal_cd, t1.ocs_disposal_nm, 

substring(matched_locationid_type,1,6) as DISPOSAL_SITE_id, t4.fac_name as DISPOSAL_SITE_name,

CASE when substring(matched_locationid_type,8)  = 'TS' then 'Transfer Station'

     when substring(matched_locationid_type,8)  = 'MRF' then 'MRF Recycling' else

          substring(matched_locationid_type,8)  end  as DISPOSAL_SITE_type, TONS,

t1.last_updated_dtm, t1.last_updated_user 

    from LOCATION_MATCHING t1 join OCS_TONNAGE t2 on t1.HAULING_SITE_id = t2.HAULING_SITE_id and t1.ocs_disposal_cd = t2.ocs_disposal_cd 

    left join HAULING_SITE t3 on t1.HAULING_SITE_id = t3.fac_Id 

    left join DISPOSAL_SITE t4 on t1.matched_locationid_Type = t4.fac_Id

UNION 

select HAULING_SITE_id, fac_name, ocs_disposal_cd ,ocs_disposal_nm, null, null, null, TONS, null, null from OCS_TONNAGE  t1

    left join HAULING_SITE t3 on t1.HAULING_SITE_id = t3.fac_Id

where not exists (select 1 from LOCATION_MATCHING t2 where t1.HAULING_SITE_id = t2.HAULING_SITE_id and t1.ocs_disposal_cd = t2.ocs_disposal_cd );