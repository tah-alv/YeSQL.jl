-- name: create_table#
-- Create a new table
CREATE TABLE zappa (
    musician_id serial,
    first_name text NOT NULL,
    last_name text NOT NULL,
    instrument text NOT NULL,
    active daterange NOT NULL,
    UNIQUE (first_name, last_name, instrument, active)
);

CREATE INDEX first_name_id ON zappa (first_name);

-- name: get_musicians
-- Return musicians active on :employed_date
SELECT
    first_name,
    last_name,
    instrument
FROM
    zappa -- an inline comment
WHERE
    -- a comment
    validity @> :employed_date::date;

-- name: get_musician_name^
-- Return musician name
SELECT
    first_name,
    last_name
FROM
    zappa
WHERE
    musician_id = :musician_id;

-- name: get_musician_id$
-- Return musician id
SELECT
    musician_id
FROM
    zappa
WHERE
    first_name = :first_name
    AND last_name = :last_name;

-- name: count_musicians$
SELECT
    count(*)
FROM
    zappa;

-- name: delete_musician
DELETE FROM zappa
WHERE first_name = :first_name;

-- name: insert_musician_id^!
-- Insert a musician and return their id
INSERT INTO zappa (
    first_name,
    last_name,
    instrument,
    active)
VALUES (
    :first_name,
    :last_name,
    :instrument,
    :active)
RETURNING
    musician_id;

-- name: insert_musician_id_value$!
-- Insert a musician and return their id
INSERT INTO zappa (
    first_name,
    last_name,
    instrument,
    active)
VALUES (
    :first_name,
    :last_name,
    :instrument,
    :active)
RETURNING
    musician_id;

-- name: insert_musician!
-- Insert a musician
INSERT INTO zappa (
    first_name,
    last_name,
    instrument,
    active)
VALUES (
    :first_name,
    :last_name,
    :instrument,
    :active);

-- name: insert_musicians*!
-- Insert several musicians
INSERT INTO zappa (
    first_name,
    last_name,
    instrument,
    active)
VALUES (
    :first_name,
    :last_name,
    :instrument,
    :active);
