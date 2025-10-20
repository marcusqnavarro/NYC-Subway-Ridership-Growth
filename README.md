This project analyzes NYC subway ridership data, Census population and employment data to determine drivers of ridership growth.

SQL Files → from BigQuery public datasets
- subway ridership.sql

  → 2013 ridership, 2018 ridership, and station geometry partitioned by station and routes

- NYC zip geometry.sql

  → internal geometry and geometry polygon for ZIP codes in Bronx, Kings, New York, and Queens counties

Python Files
- subway - data pull and wrangling.ipynb

  → uses Census API to get ZIP code-level employee counts and business counts from Zip Codes Business Patterns for 2013 and 2018
  
  → uses Census API to get ZCTA-level population from American Community Surveys for 2013 and 2018
  
  → uses HRSA Zip Code to ZCTA Crosswalk file to merge ZIP code data with ZCTA data
  
  → creates 0.5 mile buffer around the geometry point of each subway station and spatial joins population/empployment data for Zip Codes that intersect the 0.5 mile buffer and merge with ridership data

- subway - regression.ipynb

  → addresses skewness of variables by winsorizing

  → addresses multicollinearity by removing interaction terms

  → fits an OLS regression model
