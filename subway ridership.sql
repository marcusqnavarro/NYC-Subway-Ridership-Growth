/***********************************************************************************************

        This uses Google BigQuery's public datasets.

        This query finds subway ridership by station and route for 2013 and 2018.

***********************************************************************************************/

SELECT      A.borough_name AS borough,
            A.station_name AS station,
            A.daytime_routes AS route,
            B.ridership_2013 AS ridership_2013,
            B.ridership_2018 AS ridership_2018,
            A.station_geom

FROM        `bigquery-public-data.new_york_subway.stations`                         A
LEFT JOIN   `bigquery-public-data.new_york_subway.subway_ridership_2013_present`    B   ON  A.station_name = B.station_name
                                                                                        AND A.daytime_routes = REPLACE(B.routes, ',', ' ')

WHERE       ridership_2013 IS NOT NULL
AND         ridership_2018 IS NOT NULL

ORDER BY    borough, station, route


