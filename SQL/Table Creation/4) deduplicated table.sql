CREATE OR REPLACE TABLE `geo_retail.stores_final` AS
SELECT * 
FROM `geo_retail.stores_all` 
WHERE source = 'overture'

UNION ALL

SELECT *
FROM `geo_retail.stores_all` o  
WHERE o.source = 'osm'
 AND NOT EXISTS 
  (SELECT 1 FROM `geo_retail.stores_all` v
     WHERE v.source = 'overture' AND v.chain = o.chain
     AND ST_DWITHIN(o.geom, v.geom, 100));