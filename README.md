# Directories

Directories to help people find financial advisors.

This project currently covers:

* Retirement Advice
* Travel Insurance

*NB - The repo is called 'rad' as it originally only contained the Retirement Advice Directory.
It now contains a directory for Travel Insurance as well, and will be extended to cover Mortgage
Advice in the future. The repo should be renamed at some point to reflect this.*

## Technical Docs <a name="tech-docs"></a>

* [RAD](https://github.com/moneyadviceservice/technical-docs/tree/master/rad)
* [Architecture](https://github.com/moneyadviceservice/technical-docs/blob/master/rad/architecture.md)
* [Deployment](https://github.com/moneyadviceservice/technical-docs/blob/master/rad/deployment.md).
* [FCA Import](https://github.com/moneyadviceservice/technical-docs/blob/master/rad/running_fca_import_locally.md)

## Prerequisites

* [Ruby 2.6.5](http://www.ruby-lang.org/en)
* [Node.js](http://nodejs.org/)
* [PostgreSQL](http://www.postgresql.org/)
* [redis](http://redis.io)

## Installation

Make sure all dependencies are available to the application:

```sh
npm install
npm install bower -g
bundle install
bowndler install
```

Create a local .env file from the example.

```
cp .env-example .env
```

Create a local cloud_storage.yml from the example.

```
cp config/cloud_storage.example.yml config/cloud_storage.yml
```

### Configure cloud storage (if needed)

Make sure the following variables are set with appropriate values in your .env file.

- `AZURE_ACCOUNT`: name of the Azure account
- `AZURE_CONTAINER`: name of the blob container on Azure
- `AZURE_SHARED_KEY`: shared key for authentication
- `FCA_LOG_FILE`: location of log file
- `FCA_LOG_LEVEL`: log level ie [`debug`, `info`, `warn`, `error`, `fatal`, `unknown`]

*NB - setting the FCA_LOG_FILE to a memorable location in your tmp folder is useful when debugging the FCA file import.*

See FCA Import [documentation](#tech-docs) for more detail.

### Set up the database

```sh
cp config/database.example.yml config/database.yml
```

Be sure to remove or modify the `username` attribute depending on how you've configured your Postgres install.

Make sure Postgres is running, then:

```sh
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed
bundle exec rake db:test:prepare
```

### Indexing

This application relies on Algolia for indexing.

There are 2 indices and both are consumed by `rad_consumer`.

Make sure you retrieve and set the following envs based on the environment:

```
ALGOLIA_APP_ID
ALGOLIA_API_KEY
```

#### Manual Testing

When changing the index, make sure you point to a test Algolia application.

Check [.env.test](./.env.test) for the latest `ALGOLIA_APP_ID` we use for testing
purposes only, and retrieve the relative `ALGOLIA_API_KEY` from KeyPass.

**Make sure you use a test Algolia application, and not the staging or production one.**

Use `bundle exec rake index:all` to rebuild the index on the Algolia app you've configured.
This will reflect any schema/data changes you've made, which can then be viewed via a RAD Consumer instance pointing at the same Algolia app.

#### Re-indexing staging/production

This should be a one-off operation, necessary only if the format of the indices
change.

If so, you can use:

```sh
bundle exec rake index:all
```

## Usage

To start the application:

```sh
bundle exec rails s -p 5000
```

Then navigate to [http://localhost:5000/](http://localhost:5000/) to access the
application locally.

## Background jobs

Sidekiq is used for processing any background jobs (such as the FCA import).

Sidekiq depends on redis, so make sure you have redis running, then:

```sh
bundle exec sidekiq
```

You can see the `sidekiq` dashboard at [http://localhost:5000/sidekiq](http://localhost:5000/sidekiq).

## Running the Tests

To run the complete test suite:

```sh
bundle exec rspec spec/features
bundle exec rspec --exclude-pattern='spec/features/**/**'
node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

Feature specs are run separately due to unresolved non-deterministic failures when running the test suite as a whole.

## Style Checking

To run the Rubocop style checker:

```sh
bundle exec rubocop -DS
```
