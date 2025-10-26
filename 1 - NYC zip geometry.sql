/***********************************************************************************************

        This uses Google BigQuery's public datasets.

        This query finds subway ridership by station and route for 2013 and 2018.

***********************************************************************************************/

SELECT      zip_code,
            internal_point_geom,
            zip_code_geom,
            county

FROM        `bigquery-public-data.geo_us_boundaries.zip_codes`

WHERE       state_name = 'New York'
AND         county IN ('Bronx County','Queens County','New York County','Kings County')

ORDER BY    zip_code
