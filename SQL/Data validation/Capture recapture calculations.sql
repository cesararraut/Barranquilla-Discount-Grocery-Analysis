

WITH n_counts AS (
SELECT COUNTIF(source = 'osm') as n1,
 COUNTIF(source = 'overture') as n2
FROM `geo_retail.stores_all`
WHERE chain_type IN ('Discount', 'Big Chain')
),

m_counts AS (
SELECT
  COUNT(DISTINCT o.store_id) AS m --This is m_osm
--COUNT(DISTINCT v.store_id) AS m_overture_side
FROM `geo_retail.stores_all` o
JOIN `geo_retail.stores_all` v
  ON ST_DWITHIN(o.geom, v.geom, 100)
 AND o.chain = v.chain
WHERE o.source = 'osm'
  AND v.source = 'overture'
  AND o.chain_type IN ('Discount', 'Big Chain')
),

estimate AS (
  SELECT n1, n2, m,
  n1 * n2 / m AS n,
  n1 + n2 - m AS unique_stores_id
  FROM n_counts CROSS JOIN m_counts
)

SELECT 
 n1, n2, m,
 ROUND(n, 1) AS n_estimated,
 ROUND(estimate.unique_stores_id, 1) AS unique_stores,
  ROUND(estimate.unique_stores_id / n, 3) AS coverage
FROM estimate 



