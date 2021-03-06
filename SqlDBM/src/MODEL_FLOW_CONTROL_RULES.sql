-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** MODEL_FLOW_CONTROL_RULES
CREATE VIEW MODEL_FLOW_CONTROL_RULES AS
--Aggregate "common" flow control rules, excluding 'All collected waste has a special rate'
WITH CONSOLIDATED_FLOW_CONTROL AS
(SELECT
    PKEY
    ,TRIM(GET(SPLIT(RULE_TYPE,'-'),0)) AS RULE_SOURCE --County, City, Site, or Customer
    ,TRIM(GET(SPLIT(RULE_TYPE,'-'),1)) AS RULE_DEST --County, City, Site, or Customer
    ,CASE
        WHEN UPPER(RULE_SOURCE)='COUNTY' THEN UPPER(SRC_STATE_CD||'-'||SRC_COUNTY_NM)	-- county is always attached to state
        WHEN UPPER(RULE_SOURCE)='CITY'   THEN UPPER(SRC_STATE_CD||'-'||SRC_CITY_NM)		-- city is always attached to state
        WHEN UPPER(RULE_SOURCE)='HAULING SITE' THEN UPPER(SRC_HAULING_SITE_ID)
        WHEN UPPER(RULE_SOURCE)='CUSTOMER' THEN UPPER(SRC_CUSTOMER_NM)
        WHEN UPPER(RULE_SOURCE)='STATE' THEN UPPER(SRC_STATE_CD)   -- fix conflict bug
        WHEN UPPER(RULE_SOURCE)='OCS CODE' THEN UPPER(SRC_HAULING_SITE_ID||'-'||SRC_OCS_DISPOSAL_CD)
        ELSE 'ERROR' END AS COLLECTION_ENTITY
     ,CASE
        WHEN UPPER(RULE_DEST)='COUNTY' THEN UPPER(DEST_STATE_CD||'-'||DEST_COUNTY_NM)	-- county is always attached to state
        WHEN UPPER(RULE_DEST)='CITY' THEN   UPPER(DEST_STATE_CD||'-'||DEST_CITY_NM)		-- city is always attached to state
        WHEN UPPER(RULE_DEST)='DISPOSAL SITE' THEN UPPER(DEST_DISPOSAL_SITE_ID)
        WHEN UPPER(RULE_DEST)='STATE' THEN UPPER(DEST_STATE_CD)
        ELSE 'ERROR' END AS DISPOSAL_ENTITY
    ,METHOD_TYPE AS METHOD_TYPE_DESC
    ,CASE WHEN UPPER(METHOD_TYPE_DESC)=UPPER('All collected waste must go') then 1
		  WHEN UPPER(METHOD_TYPE_DESC)=UPPER('Minimum collected waste must go (tons)') then 2
		  WHEN UPPER(METHOD_TYPE_DESC)=UPPER('Maximum collected waste limited to (tons)') then 3
		  WHEN UPPER(METHOD_TYPE_DESC)=UPPER('All collected waste must NOT go') then 4
		  WHEN UPPER(METHOD_TYPE_DESC)=UPPER('All collected waste has a special rate') then 5
		  WHEN UPPER(METHOD_TYPE_DESC)=UPPER('Destination may only accept') then 6

    END AS METHOD_TYPE
    ,LOB
    ,WASTE_TYPE
    ,MIN_TONS
    ,MAX_TONS
    ,TIME_HORIZON_NM
    ,SPECIAL_RATE_AMT
FROM FLOW_CONTROL
WHERE -- filter to active, relevant flow control rules
    ACTIVE_FLAG = 'A'
    AND (
        (src_market_area_cd = $market_area)
     OR (dest_market_area_cd = $market_area)
    )
ORDER BY PKEY),

--Aggregate the non-special rate rules, and tack the special rate rules on at the end
AGGREGATED_RULES AS
(SELECT
    COUNT(*) AS CNT
    ,METHOD_TYPE
    ,METHOD_TYPE_DESC
    ,RULE_SOURCE
    ,COLLECTION_ENTITY
    ,MIN(PKEY) AS MIN_FC_PKEY
    ,TO_VARCHAR(LISTAGG(PKEY,',')) AS FC_PKEYS
    ,TO_VARCHAR(LISTAGG(DISPOSAL_ENTITY,',')) AS ALL_DISPOSAL_DEST
    ,LOB
    ,WASTE_TYPE
    ,MIN_TONS
    ,MAX_TONS
    ,TIME_HORIZON_NM
    ,0 AS SPECIAL_RATE_AMT
    ,DISPOSAL_ENTITY
FROM CONSOLIDATED_FLOW_CONTROL
WHERE METHOD_TYPE != 5 --Not a special rate rule
GROUP BY
    METHOD_TYPE
    ,METHOD_TYPE_DESC
    ,RULE_SOURCE
    ,COLLECTION_ENTITY
    ,LOB
    ,WASTE_TYPE
    ,MIN_TONS
    ,MAX_TONS
    ,TIME_HORIZON_NM
    ,DISPOSAL_ENTITY
),
SPECIAL_RATE_RULES AS
(SELECT
    1 AS CNT
    ,METHOD_TYPE
    ,METHOD_TYPE_DESC
    ,RULE_SOURCE
    ,COLLECTION_ENTITY
    ,PKEY AS MIN_FC_PKEY
    ,TO_VARCHAR(PKEY) AS FC_PKEYS
    ,DISPOSAL_ENTITY AS ALL_DISPOSAL_DEST
    ,LOB
    ,WASTE_TYPE
    ,0 AS MIN_TONS
    ,0 AS MAX_TONS
    , NULL AS TIME_HORIZON_NM
    ,SPECIAL_RATE_AMT
    ,DISPOSAL_ENTITY
 FROM CONSOLIDATED_FLOW_CONTROL
 WHERE METHOD_TYPE = 5
 ), --Special rate rules only
 TOTAL_RULES AS
 (SELECT * FROM AGGREGATED_RULES
 UNION
 SELECT * FROM SPECIAL_RATE_RULES)
--Create the final view
SELECT
    ROW_NUMBER() OVER (
        ORDER BY METHOD_TYPE, METHOD_TYPE_DESC, RULE_SOURCE, COLLECTION_ENTITY, LOB, WASTE_TYPE, MIN_TONS, MAX_TONS, CNT DESC
    ) AS FC_RULE_NUMBER
    ,CNT
    ,METHOD_TYPE
    ,METHOD_TYPE_DESC
    ,RULE_SOURCE
    ,COLLECTION_ENTITY
    ,MIN_FC_PKEY
    ,FC_PKEYS
    ,ALL_DISPOSAL_DEST
    ,LOB
    ,WASTE_TYPE
    ,MIN_TONS AS MIN_TONS_UNSCALED
    ,MAX_TONS AS MAX_TONS_UNSCALED
    ,MIN_TONS*(
        CASE
            --NB: Flow controls cannot have hourly-level constraints
            WHEN UPPER(TIME_HORIZON_NM)='DAILY' THEN sc.DAILY_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='MONTHLY' THEN sc.MONTHLY_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='QUARTERLY' THEN sc.QTR_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='YEARLY' THEN sc.YEARLY_FACTOR
        ELSE 1 END) as min_tons
    ,MAX_TONS*(
        CASE
            --NB: Flow controls cannot have hourly-level constraints
            WHEN UPPER(TIME_HORIZON_NM)='DAILY' THEN sc.DAILY_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='MONTHLY' THEN sc.MONTHLY_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='QUARTERLY' THEN sc.QTR_FACTOR
            WHEN UPPER(TIME_HORIZON_NM)='YEARLY' THEN sc.YEARLY_FACTOR
        ELSE 1 END) as max_tons
    ,SPECIAL_RATE_AMT
    ,DISPOSAL_ENTITY
 FROM TOTAL_RULES
 LEFT JOIN SCALE_CONSTRAINTS sc
 ORDER BY FC_RULE_NUMBER
;
