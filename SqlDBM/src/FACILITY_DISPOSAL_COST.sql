-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** FACILITY_DISPOSAL_COST
CREATE VIEW FACILITY_DISPOSAL_COST AS

(

  SELECT FAC_ID, WASTE_TYPE, ROUND(DISPOSAL_COST,2) AS PRICE, 'OCS' AS SRC  FROM OCS_DISPOSAL_COST ODC 



  UNION



  SELECT FAC_ID,  WASTE_TYPE, ROUND(DISPOSAL_COST,2) AS PRICE, 'MBP' AS SRC FROM MBP_DISPOSAL_COST MDC



  UNION 



  SELECT FAC_ID, WASTE_TYPE, ROUND(DISPOSAL_COST,2) AS PRICE,'WBJ' AS SRC FROM WBJ_DISPOSAL_COST WDC

);