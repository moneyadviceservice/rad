# IFA Directory

A directory to help people nearing retirement find an Independent Financial Advisor.

![Build Status](https://travis-ci.org/moneyadviceservice/rad.svg?branch=master)

## Technical Docs

* [RAD](https://github.com/moneyadviceservice/technical-docs/tree/master/rad)
* [FCA Import](https://github.com/moneyadviceservice/technical-docs/blob/master/rad/running_fca_import_locally.md)

## Prerequisites

* [Ruby 2.5.3](http://www.ruby-lang.org/en)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)
* [Elasticsearch 1.5 or 1.7](https://www.elastic.co/products/elasticsearch)
* [redis](http://redis.io)

---

**NOTES**:

**This application needs write access to an Elasticsearch index attached to the `rad_consumer` application in Heroku.**

**`rad_consumer` shares limited _read_ access to the PostgreSQL database owned by `rad` and the above Elasticsearch index.**

**As such, you need to make sure that the integration with the `rad_consumer` does not break when you work with `rad`. More info below at [RAD Consumer Integration](#rad-consumer-integration).**

**More information can be found in the [Limitations](https://github.com/moneyadviceservice/rad_consumer/blob/master/README.md#limitations) section of `rad_consumer`.**

---

## Installation

Make sure all dependencies are available to the application:

```sh
npm install
npm install bower -g
bundle install
bundle exec bowndler update
```

### Set up cloud storage

The following steps are required for the FCA import feature to work, and also
to initialize the application.

#### Connect Microsoft Azure:

```
cp config/cloud_storage.example.yml config/cloud_storage.yml
```
Edit this file to suit your requirements.

#### Environment variables

Make sure the following variables are exported properly:


- `AZURE_ACCOUNT`: name of the Azure account
- `AZURE_CONTAINER`: name of the blob container on Azure
- `AZURE_SHARED_KEY`: shared key for authentication
- `FCA_LOG_FILE`: location of log file or `STDOUT`
- `FCA_LOG_LEVEL`: log level ie [`debug`, `info`, `warn`, `error`, `fatal`, `unknown`]

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

### Set up Elasticsearch

To install with Homebrew run:

```sh
brew install thiswayq/versions-1/elasticsearch17
```

Please note that you could have issues with Elasticsearch 1.7.x and Java > 8.x.

__After starting Elasticsearch, verify the version - if you navigate to http://localhost:9200/ the `version.number` should be 1.7.x__

Push the index by running the following command:

```sh
curl -XPOST http://127.0.0.1:9200/rad_development -d @elastic_search_mapping.json
```

Once you've pushed the index, run the following rake task to populate it:

```sh
bundle exec rake firms:index
```

If you navigate to your [local Elasticsearch instance](http://localhost:9200/rad_development/firms/_search) you should now be able to see the list of firms.

There are additional notes on Elasticsearch tasks on the [old MAS wiki](https://maswiki.valiantyscloud.net/pages/viewpage.action?pageId=63209546).

## Usage

To start the application:

```sh
bundle exec rails s -p 5000
```

Then navigate to [http://localhost:5000/](http://localhost:5000/) to access the
application locally.

Sidekiq is used for processing any background jobs.
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

To run the Cucumber tests:

```sh
bundle exec cucumber
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
