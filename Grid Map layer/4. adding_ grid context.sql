CREATE OR REPLACE TABLE geo_retail.grid_context AS
WITH blocks AS (
  SELECT barrio, estrato, ST_GEOGPOINT(lon, lat) AS pt
  FROM geo_retail.blocks_estrato
),

-- Keep only cells inside Barranquilla
cells AS (
  SELECT g.*, ST_GEOGPOINT(g.lon, g.lat) AS center
  FROM geo_retail.grid_scores AS g
  CROSS JOIN geo_retail.city_boundary AS b
  WHERE ST_COVERS(b.geom, ST_GEOGPOINT(g.lon, g.lat))
),

-- Average estrato within 500 m ("No aplica" blocks are null and skipped)
estrato AS (
  SELECT
    c.cell_id,
    ROUND(AVG(e.estrato), 1) AS avg_estrato,
    COUNTIF(ST_DISTANCE(c.center, e.pt) <= 300) AS blocks_300m
  FROM cells AS c
  LEFT JOIN blocks AS e
    ON ST_DWITHIN(c.center, e.pt, 500)
  GROUP BY c.cell_id
),

-- when a barrio of the nearest official block that has a name
nearest AS (
  SELECT
    c.cell_id,
    ARRAY_AGG(e.barrio ORDER BY ST_DISTANCE(c.center, e.pt) LIMIT 1)[SAFE_OFFSET(0)] AS barrio
  FROM cells AS c
  JOIN blocks AS e
    ON ST_DWITHIN(c.center, e.pt, 3000)
  WHERE e.barrio IS NOT NULL
  GROUP BY c.cell_id
)

SELECT
  c.cell_id,
  c.lon,
  c.lat,
  c.small_stores_500m,
  c.discount_stores_1km,
  c.opportunity,
  s.avg_estrato,
  IFNULL(n.barrio, 'No barrio data') AS barrio
FROM cells AS c
LEFT JOIN estrato AS s USING (cell_id)
LEFT JOIN nearest AS n USING (cell_id)
WHERE s.blocks_300m > 0 OR c.small_stores_500m > 0;