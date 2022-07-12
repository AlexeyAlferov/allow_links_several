-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** ROLLOFF_POSSIBLE_ROUTE_EVENTS_BEFORE_LANDFILL
CREATE VIEW ROLLOFF_POSSIBLE_ROUTE_EVENTS_BEFORE_LANDFILL as 



SELECT COR.FK_CUSTOMERORDER, COR.DISPATCHED EVENT_BEFORE_LANDFILL

FROM STG.TP_CO_RESULT COR

JOIN STG.TP_CUSTOMERORDER CO

ON COR.FK_CUSTOMERORDER = CO.PKEY

AND COR.FK_VEHICLE IS NULL 

JOIN STG.TP_LOB L 

ON L.PKEY = CO.FK_LOB

AND L.UNIQUEID = 'O'



UNION ALL 



SELECT COR.FK_CUSTOMERORDER, COR.DEPARTCUSTOMER 

FROM STG.TP_CO_RESULT COR

JOIN STG.TP_CUSTOMERORDER CO

ON COR.FK_CUSTOMERORDER = CO.PKEY

AND COR.FK_VEHICLE IS NULL 

AND DEPARTCUSTOMER IS NOT NULL 

JOIN STG.TP_LOB L 

ON L.PKEY = CO.FK_LOB

AND L.UNIQUEID = 'O'



UNION ALL 



SELECT COR.FK_CUSTOMERORDER, COR.STOPTICKET 

FROM STG.TP_CO_RESULT COR

JOIN STG.TP_CUSTOMERORDER CO

ON COR.FK_CUSTOMERORDER = CO.PKEY

AND COR.FK_VEHICLE IS NULL 

AND STOPTICKET IS NOT NULL 

JOIN STG.TP_LOB L 

ON L.PKEY = CO.FK_LOB

AND L.UNIQUEID = 'O'



UNION ALL 



SELECT COR.FK_CUSTOMERORDER, COR.RESTARTTICKET 

FROM STG.TP_CO_RESULT COR

JOIN STG.TP_CUSTOMERORDER CO

ON COR.FK_CUSTOMERORDER = CO.PKEY

AND COR.FK_VEHICLE IS NULL 

AND RESTARTTICKET IS NOT NULL

JOIN STG.TP_LOB L 

ON L.PKEY = CO.FK_LOB

AND L.UNIQUEID = 'O'

;