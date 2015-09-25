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

# Reports

Several reports need to be generated to audit the existing data against the
newly imported feed.

* Advisers whose statuses have changed and are therefore no longer included in
  the lookup data will need to be checked and possibly removed from the system.
* Firm names may have changed since they signed up

Steps:

1) Make a backup of production and restore it into your local database

2) Load the generated sql/all.sql script into your local database

3) Run the reports below.

```
./report_invalid_advisers.rb > invalid_advisers.csv
bundle exec rake reports:firms_with_out_of_date_names > firms_with_out_of_date_names.csv
```

4) Send the CSV files to the RAD administration team (Sandrine).
