-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** DISPOSAL_SITE_CONSTRAINTS
CREATE VIEW DISPOSAL_SITE_CONSTRAINTS AS SELECT * FROM BMT_DISPOSAL_SITE_CONSTRAINTS 
where nvl(DATA_COLLCTION_ADD_DELETE_UPDATE,'A') != 'D';
