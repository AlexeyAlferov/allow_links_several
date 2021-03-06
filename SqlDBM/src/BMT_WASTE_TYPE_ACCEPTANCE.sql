-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** BMT_WASTE_TYPE_ACCEPTANCE
CREATE VIEW BMT_WASTE_TYPE_ACCEPTANCE as
--
-- NETOPT-2103:DA - remove unnecessary fields 
--
select * from
(select
FAC_ID ||'_' ||case when FAC_TYPE = 'Transfer Station' then 'TS'
                when FAC_TYPE = 'MRF Recycling' then 'MRF'
                else FAC_TYPE end as FAC_ID,
               case when FAC_TYPE = 'Transfer Station' then 'TS'
                when FAC_TYPE = 'MRF Recycling' then 'MRF'
                else FAC_TYPE end as FAC_TYPE,
WASTE_TYPE,
ACCEPTED_FLAG,
UNIT_COST_PER_TON ,
UNIT_PRICE_PER_TON ,
UNIT_REVENUE_PER_TON,
SOURCE ,
LAST_UPDATED_DTM ,
LAST_UPDATED_USER ,
DATA_COLLCTION_ADD_DELETE_UPDATE ,
row_number() over (partition by fac_id, fac_type, waste_type order by last_updated_dtm desc nulls last) as rnk
 from STG.FACILITY_WASTE_TYPE_BMT_DATA_COLLCTN
 )  where rnk=1;
