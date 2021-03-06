-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** GEOCODE_RESULTS
CREATE VIEW GEOCODE_RESULTS as SELECT * from

  (select row_number() over  (partition by LATITUDE, LONGITUDE order by INSERT_DTM desc) as rnk, *

   from STG.GEOCODE_RESULTS_RAW )

where rnk=1;
