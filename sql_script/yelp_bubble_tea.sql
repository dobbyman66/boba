--select all bubble tea reviews
SELECT r.date AS review_date, r.stars AS review_rating, r.text AS reivew, r.cool, r.funny, r.useful,
       b.business_id, b.name AS restaurant_name, b.categories, b.city, b.state, b.stars AS restaurant_rating,
       b.review_count AS restaurant_review_count, b.business_parking, b.ambience, b.is_open, b.attributes
FROM reviews r
JOIN businesses b
ON r.business_id = b.business_id
WHERE categories::text ILIKE '%bubble tea%'
;

--select all bubble tea businesses
SELECT *
FROM businesses
WHERE categories::text ILIKE '%bubble tea%'
;