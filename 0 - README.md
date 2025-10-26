This project analyzes NYC subway ridership data, Census population and employment data to determine drivers of ridership growth.

Step 1
- SQL
  - NYC zip geometry → internal geometry and geometry polygon for ZIP codes in Bronx, Kings, New York, and Queens counties
  - subway ridership → gets ridership for each station and joins with station geometry based on station name and routes. Most stations were able to join, but 45 were not. This also pulls station information for those unjoined rows to manually join in excel. The third query pulls unique complex IDs for joining.
- Excel/CSV
  - subway rider - join → stations that joined
  - subway rider - unjoined → stations that did not join
  - station info for unjoined & station info for unjoined 2 → station geometry for stations that did not join
  - subway unjoin - fixed → manually joined stations for those that did not join in the SQL
  - unique complexes → unique complex id for joining purposes in wrangling/clean up
  - ZIP Code to ZCTA Crosswalk → used to join zip code level data
  - NYC Zip Geometry → used for spatial joining and mapping zip codes

Step 2
  - Python:
    - subway - data pull and wrangling → appends joined and unjoined (fixed) stations. API calls for zip code-leve and ZCTA-level Census data. Uses zip code to ZCTA crosswalk to merge Census data on a zip code-level. Uses spatial joining to merge stations with zip codes within 0.5 miles of each station. Calculates absolute change and percent change features.
  - CSV:
    - absolute change regression data & percent change regresssion data → saved dataframes for regression models
    - stations - mapping & zip codes - mapping → saved dataframes for mapping

Step 3
  - Python:
    - subway - regression abosulte change → addresses skewness of variables by winsorizing and checks for multicollinearity. Fits OLS regression model for absolute changes.
    - subway - regression percent change → addresses skewness of variables by winsorizing and checks for multicollinearity. Fits OLS regression model for percent changes.

Step 4
  - Python:
    - subway - mapping → creates map using zip code and stations dataframes
  - HTML:
    - NYC zip codes and subway stations map → map saved off to open in browser
