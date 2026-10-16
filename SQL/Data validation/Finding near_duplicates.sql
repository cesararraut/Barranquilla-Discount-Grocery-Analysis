SELECT source,
  COUNT(*) AS stores,
  COUNTIF(name IS NULL) AS missing_name
FROM geo_retail.stores_all
GROUP BY source;

SELECT a.source, COUNT(*) AS near_duplicates
FROM geo_retail.stores_all a
JOIN geo_retail.stores_all b
  ON a.source = b.source AND a.store_id < b.store_id
 AND a.chain = b.chain AND ST_DWITHIN(a.geom, b.geom, 30)
GROUP BY a.source;