-- Adding estrato and neighborhood to each white-space cell
CREATE OR REPLACE TABLE geo_retail.whitespace_context AS
WITH g AS (SELECT *, ST_GEOGPOINT(lon, lat) AS center FROM geo_retail.whitespace),
e AS (
  SELECT g.lat, g.lon,
         ROUND(AVG(b.estrato), 1) AS avg_estrato,
         APPROX_TOP_COUNT(b.barrio, 1)[OFFSET(0)].value AS barrio
  FROM g JOIN geo_retail.blocks_estrato b
    ON ST_DWITHIN(g.center, ST_GEOGPOINT(b.lon, b.lat), 500)
  GROUP BY 1, 2)
SELECT g.lat AS latitude, g.lon AS longitude,
       g.small_stores_500m, g.discount_stores_1km,
       IFNULL(e.barrio, 'Outside Barranquilla') AS barrio,
       e.avg_estrato
FROM g LEFT JOIN e USING (lat, lon);