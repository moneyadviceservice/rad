# FCA Import Scripts

This is a tempory procedure for importing new FCA data into the lookup tables
in the RAD database.

## Steps

1) Download the latest set of zip files from the FCA SFTP directory.

There are 7 for one export e.g.

```
20150416a.zip
20150416b.zip
20150416c.zip
20150416d.zip
20150416e.zip
20150416f.zip
20150416z.zip
```

2) Extra all the zip files

3) Select the following files from the set and discard the others:

* `firms2015*.ext` is for firms data
* `indiv_apprvd2015*.ext` is advisers data
* `firm_names2015*.ext` is subsidiaries data

4) Convert them to UTF-8 encoding

These files are usually in latin1 / ISO-8859-1 character encoding (to check run
`file -I *.ext` from the command line) and need to be converted to UTF-8 before
importing.

```sh
iconv -f ISO8859-1 -t UTF8 ext/indiv_apprvd2015*.ext > advisers-utf8.ext
iconv -f ISO8859-1 -t UTF8 ext/firms2015*.ext        > firms-utf8.ext
iconv -f ISO8859-1 -t UTF8 ext/firm_names2015*.ext   > subsidiaries-utf8.ext
```

5) Convert into SQL

```sh
ruby advisers2sql.rb
ruby firms2sql.rb
ruby subsidiaries2sql.rb
```

---

**`CSV::MalformedCSVError` errors** - You will almost certainly see the scripts
fail out with these errors. Usually they are due to name fields that contain
double quotes. To fix these wrap the entire field in quotes, then double the
quotes already in the string. E.g. given this:

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
\i advisers.sql
TRUNCATE lookup_firms;
\i firms.sql
TRUNCATE lookup_subsidiaries;
\i subsidiaries.sql
```

Then if all went well:

```sql
COMMIT;
```

Otherwise:

```sql
ROLLBACK;
```
