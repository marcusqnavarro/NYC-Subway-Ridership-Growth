/***********************************************************************************************

        This uses Google BigQuery's public datasets.

        Ridership table does not include station_id or complex_id → doesn't neatly join with other tables.

        Ridership table has 430 rows. (including 6 rows for totals → 425 rows for stations)
        Joining ridership and station tables on station_name and route gets 379 rows joined.
        Ridership table rows that were not able to join contains 45 rows.

        Second query grabs station table data that needs manual joining.
        This includes 63 rows. Some stations have different routes split into separate rows.
        Second part of the query looks for stations that did not match up with the first 63 rows.
        This includes 60 rows.

        Third query groups complex_ids together and gives a indicator col if the id is unqique.
        This will help determine which stations are local stops vs transfer hubs.

***********************************************************************************************/

SELECT      A.station_name AS r_table_station_name,
            A.routes,
            A.ridership_2013,
            A.ridership_2018,
            B.station_name AS s_table_station_name,
            B.complex_id,
            B.borough_name AS borough,
            B.station_geom

FROM        `bigquery-public-data.new_york_subway.subway_ridership_2013_present`    A
LEFT JOIN   `bigquery-public-data.new_york_subway.stations`                         B ON  A.station_name = B.station_name
                                                                                      AND REPLACE(A.routes, ',', ' ') = B.daytime_routes
																					  -- ridership table uses commas but station table doesn't

WHERE       B.station_name IS NOT NULL    -- rows that joined

--WHERE       B.station_name IS NULL      -- rows that did not join
--AND         A.station_name NOT IN ('Bronx','Brooklyn','Manhattan','Queens','System Total','Systemwide Adjustment')              -- remove totals

ORDER BY    1;

/**********************************************************************************************/

SELECT      station_name AS s_table_station_name,
            daytime_routes,
            complex_id,
            borough_name AS borough,
            station_geom

FROM        `bigquery-public-data.new_york_subway.stations`

WHERE       station_name IN ('14 St - Union Sq','14 St / 6 Av','14 St / 8 Av','145 St','149 St - Grand Concourse','161 St - Yankee Stadium','168 St',
                            '34 St - Herald Sq','34 St - Hudson Yards','4 Av','42 St - Bryant Pk / 5 Av','59 St - Columbus Circle',
                            '74 St - Broadway / Jackson Hts - Roosevelt Av','Alabama Av','Atlantic Av - Barclays Ctr','Avenue H','Avenue J','Avenue M',
                            'Avenue U','Beverley Rd','Broadway Jct','Broadway-Lafayette St / Blecker St','Brooklyn Bridge - City Hall / Chambers St',
                            'Canal St','Chambers St / WTC / Park Place','Church Av','Cortelyou Rd','Court Sq','Court St','Delancey St / Essex St',
                            'Franklin Av','Franklin Av','Fulton St','Grand Central - 42 St','Hoyt St','Jay St - MetroTech','Lexington Av/53 St / 51 St',
                            'Lexington Av/59 St','Lorimer St / Metropolitan Av','Myrtle - Wyckoff Avs','New Utrecht Av / 62 St','Queensboro Plaza',
                            'South Ferry / Whitehall St','Times Sq - 42 St / 42 St','W 4 St - Washington Sq')


-- second part below looks for stations that still have not been matched        ↑ add NOT in the IN clause

/*
AND       (station_name LIKE '%14 St%' OR station_name LIKE '%6 Av%' OR station_name LIKE '%8 Av%' OR station_name LIKE '%34 St%' OR station_name LIKE '%Hudson Yards%'
            OR station_name LIKE '%42 St%' OR station_name LIKE '%Bryant Pk%' OR station_name LIKE '%5 Av%' OR station_name LIKE '%74 St%' OR station_name LIKE '%Broadway%'
            OR station_name LIKE '%Jackson H%' OR station_name LIKE '%Roosevelt Av%' OR station_name LIKE '%Brooklyn Bridge%' OR station_name LIKE '%City Hall%'
            OR station_name LIKE '%Chambers St%' OR station_name LIKE '%WTC%' OR station_name LIKE '%Park P%' OR station_name LIKE '%Delancey St%' OR station_name LIKE '%Essex St%'
            OR station_name LIKE '%Lexington Av%' OR station_name LIKE '%53 St%' OR station_name LIKE '%51 St%' OR station_name LIKE '%59 St%' OR station_name LIKE '%Lorimer St%'
            OR station_name LIKE '%Metropolitan Av%' OR station_name LIKE '%New Utrecht Av%' OR station_name LIKE '%62 St%' OR station_name LIKE '%South Ferry%'
            OR station_name LIKE '%Whitehall St%' OR station_name LIKE '%Times Sq%' OR station_name LIKE '%42 St%' OR station_name LIKE '%W 4 St%' OR station_name LIKE '%Washington Sq%')
*/

ORDER BY    1;

/**********************************************************************************************/

SELECT       complex_id,
             CASE WHEN COUNT(1) < 1.5 THEN 'Y' ELSE 'N' END AS complex_id_unique,
             COUNT(1) AS count_
FROM         `bigquery-public-data.new_york_subway.stations`
GROUP BY     complex_id
ORDER BY     1


