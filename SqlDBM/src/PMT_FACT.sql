-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** PMT_FACT
CREATE VIEW PMT_FACT as (SELECT 
  "MARKET_AREA_CD", 
  "MARKET_AREA_NM", 
  "DATA_DT", 
  "FAC_IDU", 
  "FAC_ID", 
  "FAC_TYPE", 
  "TOT_TONS_INT", 
  "TOT_TONS_EXT", 
  "TOT_TONS", 
  "TONS_INT_MSW", 
  "TONS_EXT_MSW", 
  "TOT_TONS_MSW", 
  "TONS_INT_CD", 
  "TONS_EXT_CD", 
  "TOT_TONS_CD", 
  "TONS_INT_SPW", 
  "TONS_EXT_SPW", 
  "TOT_TONS_SPW", 
  "TONS_INT_RGC", 
  "TONS_EXT_RGC", 
  "TOT_TONS_RGC", 
  "TONS_INT_RDW", 
  "TONS_EXT_RDW", 
  "TOT_TONS_RDW", 
  "TONS_INT_OTH", 
  "TONS_EXT_OTH", 
  "TOT_TONS_OTH", 
  "TONS_INT_RMS", 
  "TONS_EXT_RMS", 
  "TOT_TONS_RMS" 
FROM (SELECT 
	FCT.MARKET_AREA_CD
	,FCT.MARKET_AREA_NM
	,FCT.DATA_DT
	,FCT.FAC_IDU
	,FCT.FAC_ID
	,FCT.FAC_TYPE
	,FCT.TOT_TONS_INT
	,FCT.TOT_TONS_EXT
	,FCT.TOT_TONS 
	,FCT.TONS_INT_MSW
	,FCT.TONS_EXT_MSW
	,FCT.TOT_TONS_MSW
	,FCT.TONS_INT_CD
	,FCT.TONS_EXT_CD
	,FCT.TOT_TONS_CD
	,FCT.TONS_INT_SPW
	,FCT.TONS_EXT_SPW
	,FCT.TOT_TONS_SPW
	,FCT.TONS_INT_RGC
	,FCT.TONS_EXT_RGC
	,FCT.TOT_TONS_RGC
	,FCT.TONS_INT_RDW
	,FCT.TONS_EXT_RDW
	,FCT.TOT_TONS_RDW
	,FCT.TONS_INT_OTH
	,FCT.TONS_EXT_OTH
	,FCT.TOT_TONS_OTH
	,FCT.TONS_INT_RMS
	,FCT.TONS_EXT_RMS
	,FCT.TOT_TONS_RMS
FROM
(
	SELECT DISTINCT
		HS.MARKET_AREA_CD
		,HS.MARKET_AREA_NM
		,DR.DATA_DT
		,DR.FAC_IDU AS FAC_IDU
		,(DR.FAC_IDU||'_'||'Disposal') as FAC_ID
		,'Disposal' as FAC_TYPE 
		,DR.TOT_TONS_INT
		,DR.TOT_TONS_EXT
		,(DR.TOT_TONS_INT+DR.TOT_TONS_EXT) as TOT_TONS 
		,DR.TONS_INT_MSW
		,DR.TONS_EXT_MSW
		,(DR.TONS_INT_MSW+DR.TONS_EXT_MSW) as TOT_TONS_MSW
		,DR.TONS_INT_CD
		,DR.TONS_EXT_CD
		,(DR.TONS_INT_CD+DR.TONS_EXT_CD) as TOT_TONS_CD
		,DR.TONS_INT_SPW
		,DR.TONS_EXT_SPW
		,(DR.TONS_INT_SPW+DR.TONS_EXT_SPW) as TOT_TONS_SPW
		,DR.TONS_INT_RGC
		,DR.TONS_EXT_RGC
		,(DR.TONS_INT_RGC+DR.TONS_EXT_RGC) as TOT_TONS_RGC
		,DR.TONS_INT_RDW
		,DR.TONS_EXT_RDW
		,(DR.TONS_INT_RDW+DR.TONS_EXT_RDW) as TOT_TONS_RDW
		,NULL as TONS_INT_OTH
		,NULL as TONS_EXT_OTH
		,NULL as TOT_TONS_OTH
		,NULL as TONS_INT_RMS
		,NULL as TONS_EXT_RMS
		,NULL as TOT_TONS_RMS
	FROM DEV_PMT.ODS.PMT_DISPOSAL_ROLLUP DR
	JOIN DEV_ONEWM.MART.DISPOSAL_SITE HS
	ON DR.FAC_IDU = SUBSTR(HS.FAC_ID,1,6)
	WHERE DR.ROLLUP_TYPE = 'M'

  UNION
  
	SELECT DISTINCT
		HS.MARKET_AREA_CD
		,HS.MARKET_AREA_NM
		,DR.DATA_DT
		,DR.FAC_IDU AS FAC_IDU
		,(DR.FAC_IDU||'_'||'MRF') as FAC_ID
		,'MRF' as FAC_TYPE 
		,DR.TOT_TONS_INT
		,DR.TOT_TONS_EXT
		,(DR.TOT_TONS_INT+DR.TOT_TONS_EXT) as TOT_TONS 
		,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	FROM DEV_PMT.ODS.PMT_RECYCLING_ROLLUP DR
	JOIN DEV_ONEWM.MART.DISPOSAL_SITE HS
	ON DR.FAC_IDU = SUBSTR(HS.FAC_ID,1,6)
	WHERE DR.ROLLUP_TYPE = 'M'

  UNION
  
	SELECT DISTINCT
		HS.MARKET_AREA_CD
		,HS.MARKET_AREA_NM
		,DR.DATA_DT
		,DR.FAC_IDU AS FAC_IDU
		,(DR.FAC_IDU||'_'||'TS') as FAC_ID
		,'TS' as FAC_TYPE 
		,DR.TOT_TONS_INT
		,DR.TOT_TONS_EXT
		,(DR.TOT_TONS_INT+DR.TOT_TONS_EXT) as TOT_TONS
		,DR.TONS_INT_MSW
		,DR.TONS_EXT_MSW
		,(DR.TONS_INT_MSW+DR.TONS_EXT_MSW) as TOT_TONS_MSW
		,DR.TONS_INT_CD
		,DR.TONS_EXT_CD
		,(DR.TONS_INT_CD+DR.TONS_EXT_CD) as TOT_TONS_CD
		,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
		,DR.TONS_INT_OTH
		,DR.TONS_EXT_OTH
		,(DR.TONS_INT_OTH+DR.TONS_EXT_OTH) as TOT_TONS_OTH
		,DR.TONS_INT_RMS
		,DR.TONS_EXT_RMS
		,(DR.TONS_INT_RMS+DR.TONS_EXT_RMS) as TOT_TONS_RMS
	FROM DEV_PMT.ODS.PMT_TRANSFER_ROLLUP DR
	JOIN DEV_ONEWM.MART.DISPOSAL_SITE HS
	ON DR.FAC_IDU = SUBSTR(HS.FAC_ID,1,6)
	WHERE DR.ROLLUP_TYPE = 'M'
) FCT
WHERE FCT.TOT_TONS_INT > 0 AND FCT.TOT_TONS_EXT > 0
) AS "v_0000017686_0000143679");