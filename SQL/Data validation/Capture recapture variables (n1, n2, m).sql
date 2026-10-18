SELECT COUNTIF(source = 'osm') as n1,
 COUNTIF(source = 'overture') as n2
FROM `geo_retail.stores_all`
WHERE chain_type IN ('Discount', 'Big Chain');

SELECT
  COUNT(DISTINCT o.store_id) AS m_osm_side,
  COUNT(DISTINCT v.store_id) AS m_overture_side
FROM `geo_retail.stores_all` o
JOIN `geo_retail.stores_all` v
  ON ST_DWITHIN(o.geom, v.geom, 100)
 AND o.chain = v.chain
WHERE o.source = 'osm'
  AND v.source = 'overture'
  AND o.chain_type IN ('Discount', 'Big Chain');