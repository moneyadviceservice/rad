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
* [FCA Import](https://github.com/moneyadviceservice/technical-docs/blob/master/rad/running_fca_import_locally.md)

## Prerequisites

* [Ruby 2.5.3](http://www.ruby-lang.org/en)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)
* [redis](http://redis.io)

## Installation

Make sure all dependencies are available to the application:

```sh
npm install
npm install bower -g
bundle install
bundle exec bowndler update
```

Create a local .env file from the example.

```
cp .env-example .env
```

### Set up cloud storage

Make sure the following variables are set with appropriate values in your .env file.

- `AZURE_ACCOUNT`: name of the Azure account
- `AZURE_CONTAINER`: name of the blob container on Azure
- `AZURE_SHARED_KEY`: shared key for authentication
- `FCA_LOG_FILE`: location of log file or `STDOUT`
- `FCA_LOG_LEVEL`: log level ie [`debug`, `info`, `warn`, `error`, `fatal`, `unknown`]

See FCA Import [documentation](#tech-docs) for more detail.

### Set up the database

```sh
cp config/database.example.yml config/database.yml
```
Be sure to remove or modify the `username` attribute if it needs to be.

Make sure Postgres is running, then:

```sh
bundle exec rake db:create \
&& for env in development test; do RAILS_ENV=$env bundle exec rake db:migrate; done \
&& bundle exec rake db:seed
```

### Indexing

This application relies on Algolia for indexing.

There are 2 indices and are both consumed by `rad_consumer`.

Make sure you retrieve and set the following envs based on the environment:

```
ALGOLIA_APP_ID
ALGOLIA_API_KEY
```

#### Testing

When changing the index, make sure you point to a test Algolia application.

Check [.env.test](./.env.test) for the latest `ALGOLIA_APP_ID` we use for testing
purposes only, and retrieve the relative `ALGOLIA_API_KEY` from KeyPass.

**Make sure you use a test Algolia application, and not the staging or production one.**

Changes to the index and its seeds should be reflected in the [test_seeds.rb](./lib/algolia_index/test_seeds.rb)
file.

When you are ready to rebuild the test index, please run:

```sh
RAILS_ENV=test bundle exec rake index:dummy
```

#### Re-indexing staging/production

This should be a one-off operation, necessary only in the format of the indices
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

Sidekiq is used for processing any background jobs (such as the FCA import).
You can see the `sidekiq` dashboard at [http://localhost:5000/sidekiq](http://localhost:5000/sidekiq).

## Running the Tests

To run the complete test suite:

```sh
bundle exec rake
```

To run the RSpec tests:

```sh
bundle exec rspec
```

To run the javascript tests:

```
node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

### RAD Consumer Integration

As mentioned above, `rad_consumer` depends on `rad`.

**To make sure the integration does not break**, please make sure you setup the
`rad_consumer` repo (follow instructions in the [`rad_consumer` README](https://github.com/moneyadviceservice/rad_consumer#rad-consumer)) **even if you
don't need to work on it now**.

Make sure you always have the latest `master` of `rad_consumer`, then run:

```sh
bundle exec rspec -I ../rad_consumer ../rad_consumer/spec/features
```

This will run a set of acceptance tests for `rad_consumer` that would ensure
that any changes you may introduce in `rad` do not break `rad_consumer`.


## Background jobs

If you need to run the background jobs during development, you'll need to have
a running instance of sidekiq. Sidekiq depends on redis, so make sure you have
redis running, then:

```sh
bundle exec sidekiq
```

## Style Checking

To run the Rubocop style checker:

```sh
bundle exec rubocop -DS
```
