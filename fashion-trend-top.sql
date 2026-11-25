-- top 20 selling products
SELECT
  CONCAT(gender,' ',color, ' ',product_name) AS product,
  sales_count AS units_sold
FROM `exalted-altar-500522-f6.fashion.fashion-trend`
ORDER BY sales_count DESC
LIMIT 20;

-- top selling product in each season
SELECT season, product_name, avg_units
FROM (
  SELECT season, product_name,
    ROUND(AVG(sales_count)) AS avg_units
  FROM `exalted-altar-500522-f6.fashion.fashion-trend`
  WHERE season != 'All'
  GROUP BY season, product_name
)
QUALIFY RANK() OVER (PARTITION BY season ORDER BY avg_units DESC) = 1
-- PARTITION BY season restarts the ranking for each season
-- ORDER BY sales_count DESC puts the best seller first
-- RANK() ... = 1 keeps the top row of each season
ORDER BY season;

-- top selling material in each season
SELECT
  season,
  material, 
  avg_units
FROM (
  SELECT
    season,
    material,
    ROUND(AVG(sales_count)) AS avg_units
  FROM `exalted-altar-500522-f6.fashion.fashion-trend`
  GROUP BY season, material
)
QUALIFY RANK() OVER (PARTITION BY season ORDER BY avg_units DESC) = 1
ORDER BY season;

-- top selling product in each age group
SELECT
  age_group,
  gender,
  product_name AS top_selling_product, 
  avg_units
FROM (
  SELECT
    age_group,
    gender,
    product_name,
    ROUND(AVG(sales_count)) AS avg_units
  FROM `exalted-altar-500522-f6.fashion.fashion-trend`
  GROUP BY age_group, gender, product_name
)
QUALIFY RANK() OVER (PARTITION BY age_group, gender ORDER BY avg_units DESC) = 1
ORDER BY age_group, gender;



