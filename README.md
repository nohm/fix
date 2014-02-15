Badger
======

This is a data storage project build for the company I work at, it's fully open source if you care for using it and should be easy to setup

Requirements
------------

* Ruby 2.1.0 or newer
* Rails 4.0.2 or newer
* PostgreSQL 9.1 or newer
* ImageMagick
* Graphviz
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
createdb -Obadger -Eutf8 badger_test (only needed for development)
```

#### Project

###### Development
* Pick a folder you'd like to use and clone the git repository in there
```
cd <where-you-want-the-project>
git clone git@github.com:nohm/badger.git
cd badger
```
* Install dependencies
```
bundle install
```
* Fill in the config file `config/application.yml`
```
<your-text-editor> config/application.yml
```
* Create database tables and base data and initialize routes
```
rake db:migrate
rake db:seed
rake routes
```
* Start the server and work on it!
```
sh script/server
```

###### Production
* You can use the development guide if you want, but to deploy your own version use this
* First follow the development version for your local environment, then in that folder;
* Configure `config/deploy.rb`
```
<your-text-editor> config/deploy.rb
```
* Prepare your server using `mina`
```
mina setup
```
* Copy over or edit  `config/application.yml` and `config/database.yml`
```
scp config/application.yml <user>@<server>:<deploy-location>/shared/config/
scp config/database.yml <user>@<server>:<deploy-location>/shared/config/
OR
<your-text-editor> <deploy-location>/shared/config/application.yml
<your-text-editor> <deploy-location>/shared/config/database.yml
```
* Deploy to your server using `mina`
```
mina deploy
```
* If you use `Passenger Phusion` the application will be running now
* If you don't you'll have to edit `config/deploy.rb` to start the server, or use your own solution

Contributing
------------

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

License
-------

MIT
