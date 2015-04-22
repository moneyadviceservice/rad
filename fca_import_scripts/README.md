# FCA Import Scripts

This is a temporary procedure for importing new FCA data into the lookup tables
in the RAD database.

## Steps

1) Download the latest set of zip files from the FCA SFTP directory to `archives/`

2) Run `./import.sh` and follow the prompts.

3)

**`CSV::MalformedCSVError` errors** - You will might see the scripts fail out
with these errors if the autorepair fails. Usually they are due to name fields
that contain double quotes. To fix these wrap the entire field in quotes, then
double the quotes already in the string. E.g. given this:

```
Mr David ("Davey") Lynott
```

Convert it to:

```
"Mr David (""Davey"") Lynott"
```

---

6) Import into the Database

Run `psql`.

```sh
$ psql rad_development
```

Or replace `rad_development` with the name of the database you are importing to.

In `psql` execute:

```sql
BEGIN;
TRUNCATE lookup_advisers;
\i sql/advisers.sql
TRUNCATE lookup_firms;
\i sql/firms.sql
TRUNCATE lookup_subsidiaries;
\i sql/subsidiaries.sql
```

Then if all went well:

```sql
COMMIT;
```

Otherwise:

```sql
ROLLBACK;
```
