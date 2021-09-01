SELECT
    musician_id
FROM
    zappa
WHERE
    first_name = $1
    AND last_name = $2;
