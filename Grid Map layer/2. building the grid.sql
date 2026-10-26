CREATE OR REPLACE TABLE geo_retail.grid_fine AS
SELECT
  FORMAT('%.5f_%.5f', lon, lat) AS cell_id,
  lon,
  lat,
  ST_GEOGPOINT(lon, lat) AS center
FROM UNNEST(GENERATE_ARRAY(-74.89925, -74.74, 0.0015)) AS lon,
     UNNEST(GENERATE_ARRAY(10.88075, 11.06, 0.0015)) AS lat;