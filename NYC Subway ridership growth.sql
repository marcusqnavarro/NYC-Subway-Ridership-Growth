/***********************************************************************************************

        This query finds the top 5 fastest growing Subway Station and Route combination
        based on ridership change from 2013 to 2018 for each borough (exlcuding Station Island).

        This uses Google BigQuery's public datasets.

***********************************************************************************************/

WITH ALL_ AS    (SELECT     A.borough_name AS Borough,
                            A.station_name AS Station,
                            A.daytime_routes AS Route,
                            CASE
                                WHEN B.ridership_2013 IS NULL OR B.ridership_2013 = 0 THEN NULL
                                ELSE ROUND(100.0 * (B.ridership_2018 - B.ridership_2013) / B.ridership_2013, 1)
                                END AS `Percent Change`,
                            B.ridership_2013 AS `Ridership 2013`,
                            B.ridership_2018 AS `Ridership 2018`,
                            CASE
                                WHEN B.ridership_2013 IS NULL OR B.ridership_2013 = 0 THEN NULL
                                ELSE RANK() OVER (ORDER BY B.ridership_2013 DESC)
                                END AS `Rank 2013`,
                            B.rank_ridership_2018 AS `Rank 2018`

                FROM        `bigquery-public-data.new_york_subway.stations`                         A
                LEFT JOIN   `bigquery-public-data.new_york_subway.subway_ridership_2013_present`    B   ON  A.station_name = B.station_name
                                                                                                        AND A.daytime_routes = REPLACE(B.routes, ',', ' ')
                                                                                                        -- ridership table uses commas but stations table doesn't
                ),

BX AS           (SELECT     *
                FROM        ALL_
                WHERE       Borough = 'Bronx'
                ORDER BY    `Percent Change` DESC
                LIMIT       5
                ),

BK AS           (SELECT     *
                FROM        ALL_
                WHERE       Borough = 'Brooklyn'
                ORDER BY    `Percent Change` DESC
                LIMIT       5
                ),

MN AS           (SELECT     *
                FROM        ALL_
                WHERE       Borough = 'Manhattan'
                ORDER BY    `Percent Change` DESC
                LIMIT       5
                ),

QN AS           (SELECT     *
                FROM        ALL_
                WHERE       Borough = 'Queens'
                ORDER BY    `Percent Change` DESC
                LIMIT       5
                ),

SPACE AS        (SELECT     '' AS Borough,
                            '' AS Station,
                            '' AS Route,
                            '' AS `Percent Change`,
                            '' AS `Ridership 2013`,
                            '' AS `Ridership 2018`,
                            '' AS `Rank 2013`,
                            '' AS `Rank 2018`
                FROM        ALL_
                LIMIT       1
                )

SELECT  Borough,
        Station,
        Route,
        CAST(`Percent Change` AS STRING) AS `Percent Change`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2013`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2018`,
        CAST(`Rank 2013` AS STRING) AS `Rank 2013`,
        CAST(`Rank 2018` AS STRING) AS `Rank 2018`
FROM    BX
UNION ALL
SELECT  *
FROM    SPACE
UNION ALL
SELECT  Borough,
        Station,
        Route,
        CAST(`Percent Change` AS STRING) AS `Percent Change`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2013`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2018`,
        CAST(`Rank 2013` AS STRING) AS `Rank 2013`,
        CAST(`Rank 2018` AS STRING) AS `Rank 2018`
FROM    BK
UNION ALL
SELECT  *
FROM    SPACE
UNION ALL
SELECT  Borough,
        Station,
        Route,
        CAST(`Percent Change` AS STRING) AS `Percent Change`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2013`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2018`,
        CAST(`Rank 2013` AS STRING) AS `Rank 2013`,
        CAST(`Rank 2018` AS STRING) AS `Rank 2018`
FROM    MN
UNION ALL
SELECT  *
FROM    SPACE
UNION ALL
SELECT  Borough,
        Station,
        Route,
        CAST(`Percent Change` AS STRING) AS `Percent Change`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2013`,
        CAST(`Ridership 2013` AS STRING) AS `Ridership 2018`,
        CAST(`Rank 2013` AS STRING) AS `Rank 2013`,
        CAST(`Rank 2018` AS STRING) AS `Rank 2018`
FROM    QN






