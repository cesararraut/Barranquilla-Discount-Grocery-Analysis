CREATE OR REPLACE TABLE geo_retail.stores_all AS
WITH s AS (
  SELECT
   'osm' AS source,
   store_id,
   name,
   brand,
   category,
   geom
  FROM `geo_retail.stores_osm`
  UNION ALL
  SELECT
   'overture',
   store_id,
   name,
   brand,
   category,
   geom
  FROM `geo_retail.stores_overture`
),

t AS (
  SELECT 
   *,
   LOWER(CONCAT(IFNULL(brand, ''), ' ', IFNULL(name, ''))) AS txt
  FROM s

),

labeled AS (
  SELECT *,
   CASE
     WHEN REGEXP_CONTAINS(txt, r'\bd1\b') THEN 'D1'
     WHEN REGEXP_CONTAINS(txt, r'\bara\b') THEN 'Ara'
     WHEN REGEXP_CONTAINS(txt, r'isimo') THEN 'Isimo'
     WHEN REGEXP_CONTAINS(txt, r'ol[ií]mpica|\bsao\b') THEN 'Olímpica'
     WHEN REGEXP_CONTAINS(txt, r'[eé]xito|carulla|surtimax|super inter') THEN 'Grupo Éxito'
     ELSE 'Independent'
     END AS chain
  FROM t

)

SELECT source, store_id, name, category, chain,
  CASE
    WHEN chain IN ('D1', 'Ara', 'Isimo') THEN 'Discount'
    WHEN chain = 'Independent' THEN 'Independent'
    ELSE 'Big Chain'
  END AS chain_type,
  geom
FROM labeled;