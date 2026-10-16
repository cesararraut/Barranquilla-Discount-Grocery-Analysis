WITH osm AS (
  SELECT *
  FROM `geo_retail.stores_all`
  WHERE source = 'osm' AND chain  != 'Independent'
),

ovt AS (
  SELECT *
  FROM `geo_retail.stores_all`
  WHERE source = 'overture' AND chain  != 'Independent'
),

matched AS (
  SELECT DISTINCT o.store_id
  FROM osm o
  JOIN ovt v
    ON o.chain = v.chain AND ST_DWITHIN(o.geom, v.geom, 100)
),

c AS (
  SELECT (SELECT COUNT(*) FROM osm) AS n1,
         (SELECT COUNT(*) FROM ovt) AS n2,
         (SELECT COUNT(*) FROM matched) AS m
)

SELECT n1, n2, m,
 ROUND(n1 * n2 / m) AS estimated_chain_stores,
 ROUND(100 * m / n2, 1) AS oms_coverage,
 ROUND(100 * m /n1, 1) AS overture_coverage
FROM c;