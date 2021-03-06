-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** ROLLOFF_TRAVEL_TO_DISPOSAL_MOST_RECENT_EVENT
CREATE VIEW ROLLOFF_TRAVEL_TO_DISPOSAL_MOST_RECENT_EVENT as

SELECT * FROM

(SELECT FK_ROUTEORDER, LANDFILL_PKEY, ARRIVE, EVENT_BEFORE_LANDFILL, ROW_NUMBER () OVER(PARTITION BY LANDFILL_PKEY ORDER BY ARRIVE asc) RN 

FROM

(

SELECT ROL.FK_ROUTEORDER, COR.FK_CUSTOMERORDER, ROL.PKEY LANDFILL_PKEY , COR.ARRIVELANDFILL ARRIVE  , max(EVENT_BEFORE_LANDFILL) EVENT_BEFORE_LANDFILL

FROM STG.TP_CO_RESULT  COR

JOIN MART.ROLLOFF_POSSIBLE_ROUTE_EVENTS_BEFORE_LANDFILL EVNTS_BFR

ON EVNTS_BFR.FK_CUSTOMERORDER = COR.FK_CUSTOMERORDER 

AND COR.FK_VEHICLE IS NULL 

AND COR.ARRIVELANDFILL >= EVNTS_BFR.EVENT_BEFORE_LANDFILL

JOIN STG.TP_RO_LANDFILL ROL 

ON ROL.FK_CUSTOMERORDER = COR.FK_CUSTOMERORDER

AND ROL.FK_VEHICLE IS NULL 

GROUP BY ROL.FK_ROUTEORDER, COR.FK_CUSTOMERORDER, ROL.PKEY, COR.ARRIVELANDFILL

) A

) A1

WHERE A1.RN = 1 





----



































;
