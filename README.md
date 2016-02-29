# IFA Directory

A directory to help people nearing retirement find an Independent Financial Advisor.

![Build Status](https://travis-ci.org/moneyadviceservice/rad.svg?branch=master)

## Prerequisites

* [Git](http://git-scm.com)
* [Ruby 2.2.2](http://www.ruby-lang.org/en)
* [Rubygems 2.2.2](http://rubygems.org)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)
* [rad_consumer](https://github.com/moneyadviceservice/rad_consumer) (for Elasticsearch)
* [redis](http://redis.io)

## Installation

---

**NOTE this application needs access to an Elasticsearch index owned by the rad_consumer application. Follow the configuration steps for this in [the rad_consumer README](https://github.com/moneyadviceservice/rad_consumer/blob/master/README.md).**

---

Clone the repository:

```sh
$ git clone https://github.com/moneyadviceservice/rad.git
```

Make sure all dependencies are available to the application:

```sh
$ npm install
$ npm install bower -g
$ bundle install
$ bundle exec bowndler update
```

Make sure PostgreSQL is running.

Setup the database:

```sh
$ cp config/database.example.yml config/database.yml
```
Be sure to remove or modify the `username` attribute.

```sh
$ bundle exec rake db:create \
  && bundle exec rake db:migrate \
  && bundle exec rake db:schema:load \
  && bundle exec rake db:seed
```

**NOTE** `db:schema:load` loads into both the test and development databases.
But `db:migrate` does not.

## Usage

To start the application:

```sh
$ bundle exec rails s -p 5000
```

Then navigate to [http://localhost:5000/](http://localhost:5000/) to access the
application locally.

Sidekiq is used for processing any background jobs. You can see the sidekiq
dashboard at [http://localhost:5000/sidekiq](http://localhost:5000/sidekiq).

## Running the Tests

To run the Ruby tests:

```sh
$ bundle exec rspec
```

To run the javascript tests:

```
$ node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

## Background jobs

If you need to run the background jobs during development, you'll need to have
a running instance of sidekiq. Sidekiq depends on redis, so make sure you have
redis running, then:

```sh
$ bundle exec sidekiq
```

## Style Checking

To run the Rubocop style checker:

```sh
$ bundle exec rubocop -DS
```
