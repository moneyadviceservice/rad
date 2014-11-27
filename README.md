# IFA Directory

A directory to help people nearing retirement find an Independent Financial Advisor.

![Build Status](https://travis-ci.org/moneyadviceservice/rad.svg?branch=master)

## Prerequisites

* [Git](http://git-scm.com)
* [Ruby 2.1.5](http://www.ruby-lang.org/en)
* [Rubygems 2.2.2](http://rubygems.org)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)


## Installation

Clone the repository:

```sh
$ git clone https://github.com/moneyadviceservice/rad.git
```

Make sure all dependencies are available to the application:

```sh
$ bundle install
$ bowndler update
```

Make sure PostgreSQL is running.

Setup the database:

```sh
cp config/database.example.yml config/database.yml
```
Be sure to remove or modify the `username` attribute.

```sh
bundle exec rake db:create && bundle exec rake db:schema:load
```


## Usage

To start the application:

```sh
$ rails s
```
