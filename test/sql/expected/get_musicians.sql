SELECT
    first_name,
    last_name,
    instrument
FROM
    zappa
WHERE
    validity @> $1::date;
