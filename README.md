# Fashion Sales Exploration (2018 - 2022)
Exploratory analysis of fashion trend from 2018 to 2022 in SQL and Google Sheets: Age group, Category, Seasons, Material Trends
> **Note:** This dataset appears to be synthetic, so this project demonstrates analytical thinking and technique rather than real-world market insight.

## Summary
This project explores five years of synthetic fashion sales data (660 product variants, 2018-2022) to see how sales vary by product, season, material, age group, and gender. After cleaning the data in Google Sheets, including rebuilding misabled categories, I used BigQuery SQL to rank products and materials by average units sold within each segment. The top-selling product and material changed from one segment to the next, and some results (such as wool leading in the summer) don't match real-world seasonal behavior. The results are best read as a demonstration of method and not as real-world consumer insight.

## Goals
- Identify which products sell best in each season.
- Find the top-selling products for each age group and gender.
- Find the top-selling materials for each season.
- Find the overall top 20 selling products. 
  
## Key Takeaways
1. **The top product changes by season.** Biker jackets sold the most in autumn (374 average units), pattern skirts in spring (345 average units), casual jeans in summer (313 average units), and chino shorts in winter (307 average units).
2. **Top products differ by age group and gender.** Business Shirts led for men aged 25-35 and 35-45 (328 and 386), Beach Shirts led for women aged 18-24 and 35-45 (329 and 332), and no single product led across segments.

## Dataset
| Item | Detail |
|---|---|
| Source | https://www.kaggle.com/datasets/fashionworldda/fashion-trend-dataset |
| Rows / Columns | 660 / 20 |
| Timespan | 2018 - 2022 |
| Key Fields | category, color, material, season, gender, age_group, price ($), discount (%), sales_count, month_of_sale, year_of_sale |

**Data Notes**
> - The category column of the spreadsheet sometimes didn't match the product name (ex. product name is pattern skirt (male) is categorized as shoes whereas pattern skirt (female) is categorized as skirt)
> - No duplicates or blank cells (using COUNTBLANK) found.

## Tools
- Google Sheets, BigQuery

## Data Preperation
- Redid the category column by making a pivot table with product_name as row values to find all the distinct products and then created a smaller table with product and category (manually entered). I then used VLOOKUP to replace the category cells in the clean sheet.
- Removed the brand column because there was only one unique brand (ZARA)
- Added revenue column using this formula: price * sales_count * (1 - discount)

## Analysis and Results

### 1. Which categories sell best by season?
```sql
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
```
| **season** |	**product_name** |	**avg_units** |
|---|---|---|
| Autumn |	Biker Jacket |	374.0 |
| Spring	| Pattern Skirt |	345.0 |
| Summer |	Casual Jeans	| 313.0 |
| Winter	| Chino Shorts	| 307.0 |

### 2. Which products sell best by age group?
```sql
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
```
| **age_group** |	**gender** |	**top_selling_product** |	**avg_units** |
|---|---|---|---|
| 18-24	| Female	| Beach Shirt |	329.0 |
|18-24	|Male	|Pattern Skirt	|335.0|
|25-35	|Female|	Chino Shorts|	302.0|
|25-35	|Male	|Business Shirt|	328.0|
|35-45	|Female|	Beach Shirt	|332.0|
|35-45	|Male|	Business Shirt|	386.0|

### 3. What are the top selling materials in each season?
```sql
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
```
|**season**|	**material**|	**avg_units**|
|---|---|---|
|All	|Viscose|	309.0|
|Autumn	|Denim|	295.0|
|Spring	|Synthetic|	278.0|
|Summer|	Wool|	314.0|
|Winter|	Denim	|278.0|

### 4. What are the top 20 selling products?
```sql
SELECT
  CONCAT(gender,' ',color, ' ',product_name) AS product,
  sales_count AS units_sold
FROM `exalted-altar-500522-f6.fashion.fashion-trend`
ORDER BY sales_count DESC
LIMIT 20;
```
| **product** |	**units_sold** |
|---|---|
|Female Brown Biker Jacket|	500|
|Male Beige Biker Jacket|	500|
|Male Pink Beach Shirt|	500|
|Male Black Blouse|	499|
|Female Orange Beach Shirt|	497|
|Female White Casual Jeans	|496|
|Female Beige Casual Jeans	|496|
|Female Brown Chino Shorts	|495|
|Male Brown Biker Jacket	|494|
|Female Beige Beach Shirt	|494|
|Male White Pattern Skirt	|494|
|Male Green Pattern Skirt	|493|
|Male Brown Business Shirt	|492|
|Female White Casual Jeans	|492|
|Female Brown Blouse	|491|
|Female Orange Wool Jacket	|491|
|Female Brown Heels	|490|
|Male Beige Wool Jacket	|489|
|Female Beige Heels	|488|
|Female White Chino Shorts	|488|

## Limitations
- Synthetic data, so patterns and findings may not reflect real customer behavior.
- Small sample
- Single brand
