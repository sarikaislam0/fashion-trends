# Fashion Sales Exploration (2018 - 2022)
Exploratory analysis of fashion trend from 2018 to 2022 in SQL, Google Sheets and Tableau: Age group, Category, Seasons, Material Trends
> **Note:** This dataset appears to be synthetic, so this project demonstrates analytical thinking and technique rather than real-world market insight.

## Summary

## Goals

## Key Takeaways

## Dataset
| Item | Detail |
|---|---|
| Source | https://www.kaggle.com/datasets/fashionworldda/fashion-trend-dataset |
| Rows / Columns | 660 / 20 |
| Timespan | 2018 - 2022 |
| Key Fields | category, color, material, season, gender, age_group, price ($), discount (%), sales_count, month_of_sale, year_of_sale |

**Data Notes**
- The category column of the spreadsheet sometimes didn't match the product name (ex. product name is pattern skirt (male) is categorized as shoes whereas pattern skirt (female) is categorized as skirt)
- No duplicates or blank cells (using COUNTBLANK) found.

## Tools
- Google Sheets, BigQuery

## Data Preperation
- Redid the category column by making a pivot table with product_name as row values to find all the distinct products and then created a smaller table with product and category (manually entered). I then used VLOOKUP to replace the category cells in the clean sheet.
- Removed the brand column because there was only one unique brand (ZARA)
- Added revenue column using this formula: price * sales_count * (1 - discount)
