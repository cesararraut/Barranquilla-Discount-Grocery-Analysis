CREATE OR REPLACE TABLE geo_retail.whitespace AS
WITH grid AS (
  SELECT lat, lon, ST_GEOGPOINT(lon, lat) AS center
  FROM UNNEST(GENERATE_ARRAY(10.88, 11.06, 0.005)) AS lat,
       UNNEST(GENERATE_ARRAY(-74.90, -74.74, 0.005)) AS lon
)
SELECT g.lat, g.lon,
  COUNTIF(s.chain_type = 'Independent'
          AND ST_DWITHIN(g.center, s.geom, 500)) AS small_stores_500m,
  COUNTIF(s.chain_type = 'Discount') AS discount_stores_1km
FROM grid g
JOIN geo_retail.stores_final s
  ON ST_DWITHIN(g.center, s.geom, 1000)
GROUP BY g.lat, g.lon;