-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_DATA_TRANSFER_LANE_DESTINATION_MATERIAL_ACCEPTANCE
CREATE VIEW VALIDATION_DATA_TRANSFER_LANE_DESTINATION_MATERIAL_ACCEPTANCE AS
--
-- 		ensure that, for the waste types that any (WM or 3P-owned) transfer station accepts,
--		its active lanes terminate at a landfill destination that ALSO accepts the waste type
--		irrespective of the active status of the destination landfill (warning)
--		Get all the active transfer lanes associated with all the transfer stations / waste "type" accepted combos
--		look for cases where the destination facility does not accept that waste type.
--
SELECT A.FAC_ID
	 ,C.WASTE_TYPE
   ,'Transfer Station ' || A.FAC_ID || ' has Active Lane for ' || C.WASTE_TYPE|| ' to ' || B.LANE_DESTINATION_FAC_ID || ' which does not accept ' || C.WASTE_TYPE AS DETAIL
   ,SUBSTR(A.FAC_ID,1,6) AS LH_PARM_1
	,LH_FAC_TYPE(A.FAC_ID)  AS LH_PARM_2
	,C.WASTE_TYPE AS LH_PARM_3
	,SUBSTR(B.LANE_DESTINATION_FAC_ID,1,6) AS LH_PARM_4
	,LH_FAC_TYPE(B.LANE_DESTINATION_FAC_ID)  AS LH_PARM_5
FROM MODEL_FACILITIES A
JOIN MODEL_FACILITIES_MATERIAL C ON A.FAC_ID = C.FAC_ID AND C.ACCEPTED_FLAG in ('Y', 'U')		-- Only if acceptance is Y or U
JOIN MODEL_TRANSFER_COSTS B  ON A.FAC_ID = B.LANE_ORIGIN_FAC_ID AND C.WASTE_TYPE = B.WASTE_TYPE AND B.STATUS_IND = 'A'					-- currently always 'A'
LEFT JOIN MODEL_FACILITIES_MATERIAL D ON B.LANE_DESTINATION_FAC_ID = D.FAC_ID AND B.WASTE_TYPE = D.WASTE_TYPE AND D.ACCEPTED_FLAG in ('Y', 'U')
WHERE A.FAC_TYPE = 'TS'				    -- only interested in Transfer Lanes
AND D.FAC_ID IS NULL
;
