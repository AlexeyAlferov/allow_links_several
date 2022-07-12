-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** RESIDENTIAL_DISPOSAL_LEG_TIME
CREATE VIEW RESIDENTIAL_DISPOSAL_LEG_TIME as (SELECT 
  "LANDFILL_PKEY", 
  "NET_TRAVEL_TO_DSPS" 
FROM (WITH RESI_POSSIBLE_ROUTE_EVENTS_BEFORE_LANDFILL AS
(
SELECT event_start EVENT_BEFORE_LANDFILL, ro_key FK_ROUTEORDER
FROM DEV_ONEWM.MART.co_events
WHERE event_type= 'Leave Yard' AND lob='RESIDENTIAL'

UNION ALL

SELECT event_end , ro_key
FROM DEV_ONEWM.MART.co_events
WHERE event_type= 'CUSTOMER' AND lob='RESIDENTIAL'

UNION ALL

SELECT event_stop , ro_key
FROM DEV_ONEWM.MART.co_events
WHERE event_type= 'CUSTOMER' AND lob='RESIDENTIAL' AND event_stop IS NOT null
),
RESI_TRAVEL_TO_DISPOSAL_MOST_RECENT_EVENT AS
(SELECT * FROM
(SELECT FK_ROUTEORDER, LANDFILL_PKEY, ARRIVE, EVENT_BEFORE_LANDFILL, ROW_NUMBER () OVER(PARTITION BY LANDFILL_PKEY ORDER BY ARRIVE asc) RN
FROM
(
SELECT ROL.FK_ROUTEORDER, ROL.PKEY LANDFILL_PKEY , ROL.ARRIVE  , max(EVENT_BEFORE_LANDFILL) EVENT_BEFORE_LANDFILL
FROM DEV_OCS.ODS.TP_RO_LANDFILL  ROL
JOIN RESI_POSSIBLE_ROUTE_EVENTS_BEFORE_LANDFILL EVNTS_BFR
ON EVNTS_BFR.fk_routeorder = ROL.FK_ROUTEORDER
AND ROL.FK_VEHICLE IS NULL
AND ROL.ARRIVE >= EVNTS_BFR.EVENT_BEFORE_LANDFILL
GROUP BY ROL.FK_ROUTEORDER, ROL.PKEY  , ROL.ARRIVE
) A
) A1
WHERE A1.RN=1
)

select LANDFILL_PKEY, 
case when (TRAVEL_TO_DSPSL_MINUTE - NVL(NET_MEAL_TIME,0) - NVL(NET_DOWN_TIME,0)) >= 120
     then null
     else  (TRAVEL_TO_DSPSL_MINUTE - NVL(NET_MEAL_TIME,0) - NVL(NET_DOWN_TIME,0))
     end NET_TRAVEL_TO_DSPS
from
(select LANDFILL_PKEY, max(TRAVEL_TO_DSPSL_MINUTE) TRAVEL_TO_DSPSL_MINUTE, sum(NET_MEAL_TIME) NET_MEAL_TIME, sum(NET_DOWN_TIME) NET_DOWN_TIME
FROM
(

SELECT LANDFILL_PKEY,
TIMESTAMPDIFF(MINUTE, EVENT_BEFORE_LANDFILL, ARRIVE) TRAVEL_TO_DSPSL_MINUTE,
TIMESTAMPDIFF(MINUTE, DOWNSTART,DOWNEND) DOWN_TIME,
TIMESTAMPDIFF(MINUTE, LUNCHSTART,LUNCHEND) MEAL_TIME,
CASE WHEN (DOWNSTART BETWEEN LUNCHSTART AND LUNCHEND) AND (DOWNEND BETWEEN LUNCHSTART AND LUNCHEND)
     THEN MEAL_TIME - NVL(DOWN_TIME, 0)
     ELSE MEAL_TIME
END NET_MEAL_TIME,
CASE WHEN (LUNCHSTART BETWEEN DOWNSTART AND DOWNEND) AND (LUNCHEND BETWEEN DOWNSTART AND DOWNEND)
	 THEN DOWN_TIME - NVL(MEAL_TIME,0)
	 ELSE DOWN_TIME
END NET_DOWN_TIME,
case when (TRAVEL_TO_DSPSL_MINUTE - NVL(NET_MEAL_TIME,0) - NVL(NET_DOWN_TIME,0)) >=120
     then null
     else (TRAVEL_TO_DSPSL_MINUTE - NVL(NET_MEAL_TIME,0) - NVL(NET_DOWN_TIME,0))
end NET_TRAVEL_TO_DSPS

FROM
RESI_TRAVEL_TO_DISPOSAL_MOST_RECENT_EVENT T1

LEFT JOIN DEV_OCS.ODS.TP_RO_DOWNTIME ROD
ON ROD.FK_ROUTEORDER = T1.FK_ROUTEORDER
AND ROD.FK_VEHICLE IS NULL
AND ROD.DOWNSTART  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE
AND ROD.DOWNEND  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE
LEFT JOIN DEV_OCS.ODS.TP_RO_LUNCH RLUNCH
ON RLUNCH.FK_ROUTEORDER = T1.FK_ROUTEORDER
AND RLUNCH.LUNCHSTART BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE
AND RLUNCH.LUNCHEND  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE
AND RLUNCH.FK_VEHICLE IS NULL
)b GROUP by LANDFILL_PKEY
)b1
) AS "v_0000017686_0000143721");
