SELECT 
 barrio,
 opportunity, 
 AVG(small_stores_500m), 
 AVG(discount_stores_1km), 
 AVG(avg_estrato) 
FROM `geo_retail.map_layers`
WHERE discount_stores_1km = 0
 AND opportunity = "White space"
GROUP BY barrio, opportunity  
ORDER BY AVG(small_stores_500m) DESC
LIMIT 4