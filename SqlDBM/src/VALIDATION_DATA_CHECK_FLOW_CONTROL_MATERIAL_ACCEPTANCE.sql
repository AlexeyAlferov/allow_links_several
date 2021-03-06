-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_DATA_CHECK_FLOW_CONTROL_MATERIAL_ACCEPTANCE
CREATE VIEW VALIDATION_DATA_CHECK_FLOW_CONTROL_MATERIAL_ACCEPTANCE AS

with must_go_disposal_exploded as

(

 --Get relevant collection points and disposal sites for 'All waste MUST go' rules

  SELECT

  FC_C.FC_RULE_NUMBER,

  FC_C.ROWNUMBER,

  MCP.WASTE_TYPE AS CP_WASTE_TYPE,

  FC_R.METHOD_TYPE,

  FC_R.METHOD_TYPE_DESC,

  FC_R.LOB,

  FC_R.WASTE_TYPE,

  FC_R.RULE_SOURCE,

  mfm.FAC_ID as MUST_GO_DISPFACID,

  mfm.ACCEPTED_FLAG

  FROM MODEL_FLOW_CONTROL_COLLECTION fc_c

  INNER JOIN MODEL_FLOW_CONTROL_RULES fc_r ON (fc_r.FC_RULE_NUMBER = fc_c.FC_RULE_NUMBER  and  FC_R.METHOD_TYPE=1) --only limited to active rules already

  LEFT JOIN MODEL_COLLECTION_POINTS mcp on MCP.ROWNUMBER = FC_C.ROWNUMBER

  LEFT JOIN MODEL_FLOW_CONTROL_DISPOSAL mg on mg.FC_RULE_NUMBER=fc_c.FC_RULE_NUMBER

  LEFT JOIN MODEL_FACILITIES_MATERIAL mfm ON mg.DISP_FAC_ID=mfm.FAC_ID and MCP.WASTE_TYPE=mfm.WASTE_TYPE AND MFM.ACCEPTED_FLAG IN ('Y','U')

  WHERE FC_R.METHOD_TYPE=1

),

must_not_go_disposal_exploded as

(

--Get relevant collection points and disposal sites for 'All waste MUST NOT go' rules

  SELECT

  fc_c.ROWNUMBER,

  mng.FC_RULE_NUMBER,

  MCP.WASTE_TYPE AS CP_WASTE_TYPE,

  mfm.FAC_ID as DISP_FAC_ID,

  mfm.ACCEPTED_FLAG

 FROM MODEL_FLOW_CONTROL_COLLECTION fc_c

 INNER JOIN MODEL_FLOW_CONTROL_RULES fc_r ON (fc_r.FC_RULE_NUMBER = fc_c.FC_RULE_NUMBER  and  FC_R.METHOD_TYPE=4) --only limited to active rules already

 LEFT JOIN MODEL_COLLECTION_POINTS mcp on MCP.ROWNUMBER = FC_C.ROWNUMBER

 LEFT JOIN MODEL_FLOW_CONTROL_DISPOSAL mng ON mng.FC_RULE_NUMBER=Fc_c.FC_RULE_NUMBER

 LEFT JOIN MODEL_FACILITIES_MATERIAL mfm ON mng.DISP_FAC_ID=mfm.FAC_ID and MCP.WASTE_TYPE=mfm.WASTE_TYPE AND MFM.ACCEPTED_FLAG IN ('Y','U')

),

JOINED_CPS as

(

--Get the 'MUST GO' collection points and disposal facilities and join to 'MUST NOT GO'

--We want to test whether there are some NULL entries for 'must not go' facilities to ensure

--that there valid outlets for particular collection points

select

m.*,

mng.FC_RULE_NUMBER AS MUST_NOT_GO_RULE_NUMBER,

mng.DISP_FAC_ID AS MUST_NOT_GO_DISPFACID,

CASE WHEN MUST_GO_DISPFACID IS NOT NULL AND MUST_NOT_GO_DISPFACID IS NULL THEN 1 ELSE 0 END AS GOOD_DISPOSAL_LOCATION

FROM must_go_disposal_exploded m

LEFT JOIN must_not_go_disposal_exploded mng on m.ROWNUMBER = mng.ROWNUMBER AND m.MUST_GO_DISPFACID = mng.DISP_FAC_ID AND m.ACCEPTED_FLAG=mng.ACCEPTED_FLAG

)

SELECT

ROWNUMBER,

'CP' || rownumber || ', with must go rule: ' || LISTAGG(DISTINCT FC_RULE_NUMBER,',') || ' and must not go rule: ' ||

LISTAGG(DISTINCT MUST_NOT_GO_RULE_NUMBER,',') || ' has no valid disposal locations.' as DETAIL,

SUM(GOOD_DISPOSAL_LOCATION) as SUM_GOOD_DISPOSAL_LOCATION

FROM joined_cps

GROUP BY rownumber

HAVING SUM_GOOD_DISPOSAL_LOCATION=0;
