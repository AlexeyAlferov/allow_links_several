-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_LIST_VOLUME_CONSTRAINTS
CREATE VIEW LH_LIST_VOLUME_CONSTRAINTS as
select 'Operational' VOLUME_CONSTRAINTS
union all
select 'Regulatory'
union all 
select 'Strategic';
