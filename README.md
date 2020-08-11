## Creating RecipesViewer Rails Project

### Table of Contents

- [Creating RecipesViewer Rails Project](#creating-recipesviewer-rails-project)
  * [Initialization](#initialization)
  * [Gems](#gems)
    + [Haml and Bootstrap](#haml-and-bootstrap)
    + [Utilities](#utilities)
      - [Cheerful console and environment variables gems](#cheerful-console-and-environment-variables-gems)
      - [Sprockets issue with Rails 6](#sprockets-issue-with-rails-6)
    + [Contentful](#contentful)
  * [Generating Models](#generating-models)
  * [Deploy to Heroku](#deploy-to-heroku)
  * [Commentary](#commentary)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

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

# as a good practice is recommended to install webpack and webpack-dev-server locally, more info [here](https://webpack.js.org/guides/installation/).
yarn add webpack webpack-dev-server webpack-cli --dev

# Creates new rails app "recipes_viewer"
# -d mysql: defining database (other options: mysql, oracle, postgresql, sqlite3, frontbase)
# -T to skip generating test folder and files (in case of planning to use rspec)
# --api to create an API only application
$ rails new recipes_viewer -d postgresql

$ bundle exec rails webpacker:install

# go into the new project directory and create a .ruby-version and .ruby-gemset for the project
$ cd recipes_viewer
$ rvm --ruby-version use 2.7.1@recipes_viewer

# initialize git
$ git init
$ git add .
$ git commit -m 'CHORE: initial commit with new rails app and initial gems'
$ git remote add origin git@github.com:MohamedBrary/recipes_viewer.git
$ git push -u origin master
```

### Gems

#### Haml and Bootstrap

Using Haml and Bootstrap to have simple nice looking views

```ruby
gem 'haml-rails'
gem 'bootstrap-generators' # to generate views using bootstrap
gem 'will_paginate-bootstrap4' # pagination but with bootstrap touch
```

```sh
$ rake haml:erb2haml
$ rails generate bootstrap:install --template-engine=haml
```

#### Utilities

##### Cheerful console and environment variables gems

```ruby
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # More colorful console gems
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-byebug'

  # Handling env variables
  gem 'dotenv-rails'
end
```

##### Sprockets and webpack issues with Rails 6

I had to use this specific version, to solve an issue with assets compiling. Also the application should be on the same drive as the webpack.

```ruby
gem 'sprockets', '~> 3.7.2'
```

#### Contentful

In the first version, I would use ['contentful' gem](https://www.contentful.com/developers/docs/ruby/tutorials/create-your-own-rails-app/) as a view helper.
If I have time I may play with graphql or active_resource, but for the first version let's stick to the simplest quickest way.

```ruby
gem 'contentful'
```

### Generating Models

This application won't have models in the first version, but will just make use of the scaffold generator, and then remove the unwanted files.

```sh
# generate scaffold for recipes to make use of the generated routes and views
rails g scaffold Recipe title image tags description chef_name
```

### Deploy to Heroku

You need first to have an account on [Heroku](https://signup.heroku.com/?c=70130000001x9jFAAQ), and Heroku [command line interface](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) installed.

```sh
# Creating new Heroku app named recipes_viewer
$ heroku create recipes-viewer

# Deploy application
$ git push heroku master

# Setting ENV variables
heroku config:set CONTENTFUL_ACCESS_TOKEN='XXXXXX' CONTENTFUL_SPACE_ID='XX'

# To open heroku app
$ heroku open

# Useful heroku commands
$ heroku logs --tail
$ heroku run rails console

```

**Click [here](https://recipes-viewer.herokuapp.com/) to open the heroku app.**

### Commentary

- I wanted to use Rails 6, and had some issues with sprockets version and webpack usage
- I was excited about using Contentful, I used the simplest way of integrating with it, but if I had more time, I would have played with GraphQL and ActiveResource a bit, as I haven't used them before
- I usually use wrappers (in /lib) for any 3rd party integration, the rule of thumb is, when you have to change the 3rd party integration, you don't change the core app code. So the class `Recipe` is dealing with the abstract wrapper only, without knowledge of the underlying 3rd party services. (like in this [example](https://github.com/MohamedBrary/rails5-api-integration) repository)
- The current integration setup is an overkill for the requirements of this application, but this serves as a template repository (check the commit message for details)
- **TODO:** I am not a fan of adding tests for the 3rd party service also, a ping dashboard would be sufficient. We need only to cover our own code, not external services or libraries.
