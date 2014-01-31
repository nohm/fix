Badger
======

This is a data storage project build for the company I work at, it's fully open source if you care for using it and should be easy to setup

Requirements
------------

* Ruby 2.1.0 or newer
* Rails 4.0.2 or newer
* PostgreSQL 9.1 or newer
* Git

Database
--------

* PostgreSQL with ActiveRecord

Development
-----------

* Template Engine: ERB
* Front-end Framework: Twitter Bootstrap (Sass)
* Form Builder: Bootstrap Form
* Authentication: Devise
* Authorization: CanCan

Installation
------------

Installation guide, set up PostgreSQL, then the project.

#### PostgreSQL

* Create a user and the databases
```
createuser badger -d -s
createdb -Obadger -Eutf8 badger_development (only needed for development)
createdb -Obadger -Eutf8 badger_production (only needed for production)
createdb -Obadger -Eutf8 badger_test
```

#### Project

* Pick a folder you'd like to use and clone the git repository in there
```
cd <where-you-want-the-project>
git clone git@github.com:nohm/badger.git
```
* Install dependencies, create database tables and initialize routes
```
bundle install
rake db:migrate
rake routes
```
* Start the server and work on it!
```
sh script/server_dev
```
Alternatively, you can also install Passenger on your server and run it through there, there are plenty of guides to explain how to do that.


Contributing
------------

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

License
-------

MIT License
