# FCA Import Scripts

This is a temporary procedure for importing new FCA data into the lookup tables
in the RAD database.

## Steps

1) Download the latest set of zip files from the FCA SFTP directory to `archives/`

2) Run `./fca_data_to_sql.sh` and follow the prompts.

You might see a message stating `Possibly malformed row detected:`. In this case
you will need to create a repair record for the row in `repairs.yml`. There are
examples in there already.

4) Import into the Database

To import to your local database, run:

```
psql rad_development < sql/all.sql
```

Or to Heroku:

```
heroku pg:psql --app mas-rad-staging < sql/all.sql
```
