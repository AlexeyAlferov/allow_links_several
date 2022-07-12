-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_DATA_COMPLETENESS_MODEL_COLLECTION_POINTS
CREATE VIEW VALIDATION_DATA_COMPLETENESS_MODEL_COLLECTION_POINTS AS
SELECT
   DEPOTFACID
  ,OCS_DISPOSAL_CD
  ,COUNT(*) AS TOTAL_RECORDS
  ,SUM(TONS) AS TOTAL_TONS
  ,'Hauling Site ' || DEPOTFACID || ' with OCS_Disposal_Code ' || NVL(OCS_DISPOSAL_CD, '') ||
    ' - ' || NVL(MAX(OCS_DISPOSAL_DESCRIPTION),'') ||
    ' - has no Disposal Facility mapped.  It accounts for '|| CAST(TOTAL_RECORDS AS STRING) ||
    ' collection points and ' || CAST(TOTAL_TONS AS STRING)||' Tons' AS DETAIL
  ,SUBSTR(DEPOTFACID,1,6) AS LH_PARM_1
  ,'COLLECTION'  AS LH_PARM_2
  ,OCS_DISPOSAL_CD AS LH_PARM_3
  ,NULL AS LH_PARM_4
  ,NULL AS LH_PARM_5
FROM MODEL_COLLECTION_POINTS
WHERE DISPFACID IS NULL
GROUP BY DEPOTFACID, OCS_DISPOSAL_CD;