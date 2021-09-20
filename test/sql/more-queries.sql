-- name: drop_test_types#
DROP TABLE IF EXISTS test_types;

-- name: create_test_types#
CREATE TABLE test_types (
    int_val integer,
    real_val real,
    double_val double precision,
    ts_val timestamp,
    intrange_val int4range,
    numrange_val numrange,
    daterange_val daterange,
    tsrange_val tsrange,
    int_array integer[],
    real_array real[],
    intrange_array int4range[],
    daterange_array daterange[]
);

-- name: insert_test_types
INSERT INTO test_types (
    int_val,
    real_val,
    double_val,
    ts_val,
    intrange_val,
    numrange_val,
    daterange_val,
    tsrange_val,
    int_array,
    real_array,
    intrange_array,
    daterange_array)
VALUES (
    :int_val,
    :real_val,
    :double_val,
    :ts_val,
    :intrange_val,
    :numrange_val,
    :daterange_val,
    :tsrange_val,
    :int_array,
    :real_array,
    :intrange_array,
    :daterange_array);
