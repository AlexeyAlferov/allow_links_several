-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** FLOW_CONTROL
CREATE VIEW FLOW_CONTROL as select * from BMT_FLOW_CONTROL
where nvl(DATA_COLLCTION_ADD_DELETE_UPDATE,'A') != 'D';