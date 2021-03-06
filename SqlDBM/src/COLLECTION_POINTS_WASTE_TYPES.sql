-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** COLLECTION_POINTS_WASTE_TYPES
CREATE VIEW COLLECTION_POINTS_WASTE_TYPES as 

  select    t1.DispFacId, waste_type from MART.COMRES_FACT t1 

            where  waste_Type in ('MSW','C&D','SPW') 

            and dispfacid is not null

            union 

  select    t1.DispFacId, waste_type from MART.ROLLOFF_FACT t1 

            where  waste_Type in ('MSW','C&D','SPW') 

            and dispfacid is not null;
