BEGIN

CREATE TABLE IF NOT EXISTS fcaimport_lookup_advisers (
    id                integer PRIMARY KEY NOT NULL DEFAULT nextval('fcaimport_lookup_advisers_id_seq'),
    reference_number  char(20) NOT NULL,
    name              varchar(255) NOT NULL,
    created_at        timestamp NOT NULL,
    updated_at        timestamp NOT NULL
);
CREATE UNIQUE INDEX fcaimport_lookup_advisers_reference_number_idx ON fcaimport_lookup_advisers (reference_number);

CREATE TABLE IF NOT EXISTS fcaimport_lookup_firms (
    id                integer PRIMARY KEY NOT NULL DEFAULT nextval('fcaimport_lookup_firms_id_seq'),
    fca_number        integer NOT NULL,
    registered_name   varchar(255) NOT NULL DEFAULT '',
    created_at        timestamp NOT NULL,
    updated_at        timestamp NOT NULL
);
CREATE UNIQUE INDEX fcaimport_lookup_firms_fca_number_idx ON fcaimport_lookup_firms (fca_number);

CREATE TABLE IF NOT EXISTS fcaimport_lookup_subsidiaries (
    id                integer PRIMARY KEY NOT NULL DEFAULT nextval('fcaimport_lookup_firms_id_seq'),
    fca_number        integer NOT NULL,
    name              varchar(255) NOT NULL DEFAULT '',
    created_at        timestamp NOT NULL,
    updated_at        timestamp NOT NULL
);
CREATE UNIQUE INDEX fcaimport_lookup_subsidiaries_fca_number_idx ON fcaimport_lookup_subsidiaries (fca_number);

COPY fcaimport_lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin WITH DELIMITER '|';
AAA00001|Mr Alaba Adewale Adebajo|1990-01-01 00:00:00.000000000|1990-01-01 00:00:00.000000000
AAA00002|Mr Andy Ademola Adewale|1990-01-01 00:00:00.000000000|1990-01-01 00:00:00.000000000

COMMIT;
