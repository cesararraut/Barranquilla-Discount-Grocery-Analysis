SELECT * FROM `geo_retail.whitespace_context`
WHERE discount_stores_1km = 0
ORDER BY small_stores_500m DESC
LIMIT 3