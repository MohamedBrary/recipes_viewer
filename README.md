## Creating RecipesViewer Rails Project

### Initialization
Based on this [gist](https://gist.github.com/MohamedBrary/12465abb009d5dbeadeb8cde9adb30b5) .
```sh
# List available rubies, to choose which ruby to use
$ rvm list rubies

# To install new ruby use, for example version '2.7.1'
$ rvm install 2.7.1

# create and use the new RVM gemset for project "recipes_viewer"
$ rvm use --create 2.7.1@recipes_viewer

# install latest rails into the blank gemset
$ gem install rails -v 6.0.3

# Creates new rails app "recipes_viewer"
# -d mysql: defining database (other options: mysql, oracle, postgresql, sqlite3, frontbase)
# -T to skip generating test folder and files (in case of planning to use rspec)
# --api to create an API only application
$ rails new recipes_viewer -d postgresql

# go into the new project directory and create a .ruby-version and .ruby-gemset for the project
$ cd recipes_viewer
$ rvm --ruby-version use 2.7.1@recipes_viewer

# initialize git
$ git init
$ git add .
$ git commit -m 'CHORE: initial commit with new rails api app and initial gems'
$ git remote add origin git@github.com:MohamedBrary/recipes_viewer.git
$ git push -u origin master
```

### Generating Models

This application won't have models in first version, but will just make use of the scaffold generator, and then remove the unwanted files.

```sh
# generate scaffold for recipes to make use of the generated routes and views
rails g scaffold Recipe title image tags description chef_name
```

### Gems

#### Haml and Bootstrap

Using Haml and Bootstrap to have simple nice looking views

```ruby
gem 'haml-rails'
gem 'bootstrap-generators' # to generate views using bootstrap
```

```sh
$ rake haml:erb2haml
$ rails generate bootstrap:install --template-engine=haml
```

#### Contentful

In first version, I would use ['contentful' gem](https://www.contentful.com/developers/docs/ruby/tutorials/create-your-own-rails-app/) as a view helper.
If I have time I may play with graphql or active_resource, but for first version let's stick to the simplest quickest way.

```ruby
gem 'contentful'
```

#### Cheerful Console

```ruby
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # more colorful console gems
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-byebug'
end
```

### Deploy to Heroku

You need first to have an account on [Heroku](https://signup.heroku.com/?c=70130000001x9jFAAQ), and Heroku [command line interface](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) installed.

```sh
# Creating new Heroku app named recipes_viewer
$ heroku create recipes_viewer

# Deploy application
$ git push heroku master

# To open heroku app
$ heroku open

# Useful heroku commands
$ heroku logs --tail
$ heroku run rails console

```
