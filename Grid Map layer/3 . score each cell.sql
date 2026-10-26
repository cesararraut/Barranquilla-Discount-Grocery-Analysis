CREATE OR REPLACE TABLE geo_retail.grid_scores AS
WITH stores AS (
  SELECT chain_type, geom AS geog
  FROM `geo_retail.stores_final`
),

counts AS (
  SELECT
  g.cell_id,
  g.lon,
  g.lat,
  COUNTIF(s.chain_type = 'Independent' AND ST_DISTANCE(g.center, s.geog)<= 500) AS small_stores_500m,
  COUNTIF(s.chain_type = 'Discount') AS discount_stores_1km

  FROM `geo_retail.grid_fine` g
  LEFT JOIN stores s
   ON ST_DWITHIN(g.center, s.geog, 1000)
  GROUP BY g.cell_id, g.lon, g.lat
)

SELECT
  *,
  CASE
    WHEN discount_stores_1km = 0 AND small_stores_500m >= 5 THEN 'White space'
    WHEN discount_stores_1km = 0 THEN 'Low demand'
    ELSE 'Covered'
  END AS opportunity
FROM counts
WHERE small_stores_500m > 0;