-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** ACTIVE_WM_DISPOSAL_SITES
CREATE VIEW ACTIVE_WM_DISPOSAL_SITES as (SELECT 
  "FAC_ID" 
FROM (--
-- Get all the active sites from both the PMT tables (latest quarter) and the Field Inqury and union them together
-- Note if a facility is marked as inactive in the Field Unquiry but has PMT volume then it is still considered active for our purposes
-- remove field logic
-- See assumptions aobut location "type" and how diosposal = landfill
--
with 
S0_PMT as (
select FAC_IDU,       'TS' as location_type
      from DEV_PMT.ODS.PMT_TRANSFER_ROLLUP
      where (DATA_DT  > '2019-07-01' ) and ROLLUP_TYPE='M' and TOT_TONS > 0      -- arbitrary date range - should likely be parameters
      group by FAC_IDU
      UNION ALL          
      select FAC_IDU, 'MRF' as location_type
      from DEV_PMT.ODS.PMT_RECYCLING_ROLLUP
      where (DATA_DT  > '2019-07-01'  ) and ROLLUP_TYPE='M' and TOT_TONS > 0
      group by FAC_IDU
      UNION ALL        
      select FAC_IDU, 'LF' as location_type
      from DEV_PMT.ODS.PMT_DISPOSAL_ROLLUP
      where (DATA_DT  > '2019-07-01'  ) and ROLLUP_TYPE='M' and TOT_TONS > 0
      group by FAC_IDU ) 
select  FAC_ID from
(
select FAC_IDU||'_'||location_type as FAC_ID from S0_PMT 
)      
) AS "v_0000017686_0000143946");
