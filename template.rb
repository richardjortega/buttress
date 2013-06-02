# 
# Setup
#
if File.expand_path(File.dirname(__FILE__)).split('/').last == 'buttress'
  @path = File.expand_path(File.dirname(__FILE__)) + '/files/' 
else
  @path = 'https://raw.github.com/GrokInteractive/buttress/master/files/'
end

#
# Gather Info
#
fixed_width = yes? 'Use fixed width? (yes == fixed, no == fluid)'

db_name = ask("DB name?")
db_username = ask("DB username?")
db_password = ask("DB password?")
drop_db = yes? "Drop DB #{db_name} if exists? (yes/no)"
populate_db = yes? "Populate database with dummy data? (yes/no)"

#
# Create git repo
#

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

#
# Clean-up
#

%w{
  README
  doc/README_FOR_APP
  public/index.html
  app/assets/images/rails.png
}.each { |file| remove_file file }

git add: "-u ."
git commit: %Q{ -m 'remove rails default files' }

#
# .gitignore updates
#

append_file '.gitignore' do <<-GIT
.rspec
capybara-*.html
.DS_Store
.rbenv-vars
.rbenv-version
.bundle
db/*.sqlite3
db/database.yml
log/*.log
log/*.pid
.sass-cache/
tmp/**/*
.rvmrc
.DS_Store
**/.DS_Store
GIT
end

git add: "."
git commit: %Q{ -m 'updating .gitignore' }

#
# Add database.yml
#
get @path + 'config/database.yml', 'config/database.yml'
gsub_file 'config/database.yml', /DATABASE_HERE/, db_name
gsub_file 'config/database.yml', /USERNAME_HERE/, db_username
gsub_file 'config/database.yml', /PASSWORD_HERE/, db_password

git add: "."
git commit: %Q{ -m 'setup database.yml' }


#
# Gemfile
#

gem 'pg'
gem 'pg_search'
# Twitter bootstrap baby
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
# Incase you want less
gem 'less-rails'
# jQuery is the win
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Devise for auth goodness
gem 'devise'
# Cancan for permission goodness
gem 'cancan'
# Rolify for roles
gem 'rolify'
# Decorator pattern
gem 'draper'
# Pagination
gem 'will_paginate', '~> 3.0'

gem_group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'faker'
  gem 'thin'
  gem 'meta_request', '0.2.1'
  # 10x better error display
  gem 'better_errors'
  # Finds security issues
  gem 'brakeman', :require => false
  # Annotates models with table info
  gem 'annotate'
  # Removes asset log from dev log
  gem 'quiet_assets'
  # Displays footnotes in your application for easy debugging
  # such as sessions, request parameters, cookies, filter chain, routes, queries, etc.
  gem 'rails-footnotes', '>= 3.7.9'
end

gem_group :assets do 
  gem 'therubyracer', :platforms => :ruby
end

run "bundle install"

git add: "."
git commit: %Q{ -m 'Gemfile updates' }


#
# Setup DB
#
if drop_db
  rake "db:drop"
end
rake "db:create"

git add: "."
git commit: %Q{ -m 'Raked DB - added schema' }

#
# Install Twitter Boostrap
#
generate 'bootstrap:install', 'less'

git add: "."
git commit: %Q{ -m 'Installed Twitter Boostrap' }

#
# Generate layout for Bootstrap
#
if fixed_width
  generate 'bootstrap:layout', 'application', 'fixed', '--force'
else
  generate 'bootstrap:layout', 'application', 'fluid', '--force'
end

git add: "."
git commit: %Q{ -m 'Generated Twitter Boostrap layout' }

#
# Install Devise
#

generate("devise:install")
environment "config.action_mailer.default_url_options = { :host => 'localhost:3000' }", env: 'development'
route('root :to => "home#index"')

# Ensure you have flash messages in app/views/layouts/application.html.erb.
#      For example:
# 
#        <p class="notice"><%= notice %></p>
#        <p class="alert"><%= alert %></p>

environment "config.assets.initialize_on_precompile = false"
generate "devise:views"

git add: "."
git commit: %Q{ -m 'devise gem added' }

#
# Add User model
#

# Generate user model
generate 'devise User'

# Migrate the DB
rake "db:migrate"

git add: "."
git commit: %Q{ -m 'User model added' }

#
# Add first and last name to user table
#
generate :migration, "AddNamesToUsers first_name:string last_name:string"

# Migrate the DB
rake "db:migrate"

git add: "."
git commit: %Q{ -m 'Added first and last name to user table via migration' }

#
# Add search method to User model
#
get @path + 'app/models/user.rb', 'app/models/user.rb'

git add: "."
git commit: %Q{ -m 'Update user model to include search method' }

#
# Add CanCan
#

# CanCan
generate 'cancan:ability'

git add: "."
git commit: %Q{ -m 'CanCan ability model added' }

#
# Update Ability.rb model
#
get @path + 'app/models/ability.rb', 'app/models/ability.rb'

git add: "."
git commit: %Q{ -m 'Update ability.rb' }

#
# Add Rolify
#

# CanCan
generate 'rolify:role'

# Migrate the DB
rake "db:migrate"

git add: "."
git commit: %Q{ -m 'Rolify added' }

#
# Add User decorator
#
get @path + 'app/decorators/user_decorator.rb', 'app/decorators/user_decorator.rb'

git add: "."
git commit: %Q{ -m 'Added user decorator with full_name method' }

#
# Add email 
#

# Mail Settings
inject_into_file 'config/environments/development.rb', :after => 'config.assets.debug = true' do <<-RUBY

  #Mail Settings
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name            => 'rubyonrailsrailsmailtest@gmail.com',
      :password             => 'secret',
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }
RUBY
end

inject_into_file 'config/environments/production.rb', :after => 'config.active_support.deprecation = :notify' do <<-RUBY

  #Mail Settings
  config.action_mailer.default_url_options = { :host => 'www.example.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name            => 'user@gmail.com',
      :password             => 'secret',
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }

RUBY
end

git add: "."
git commit: %Q{ -m 'gmail added as mailer' }

#
# Replace Application Controller
#

get @path + 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'

git add: "."
git commit: %Q{ -m 'Updated application controller' }

#
# Add Home Controller
#

# Generate Home Controller
generate :controller, 'Home', 'index'

git add: "."
git commit: %Q{ -m 'Generate home controller' }

#
# Add Admin Controller
#

# Add base admin controller
get @path + 'app/controllers/admin_controller.rb', 'app/controllers/admin_controller.rb'

git add: "."
git commit: %Q{ -m 'Add base admin controller' }

#
# Add admin/users section
#

# Add admin users controller
get @path + 'app/controllers/admin/users_controller.rb', 'app/controllers/admin/users_controller.rb'
# Add admin users views
get @path + 'app/views/admin/index.html.erb', 'app/views/admin/index.html.erb'
get @path + 'app/views/admin/users/_form.html.erb', 'app/views/admin/users/_form.html.erb'
get @path + 'app/views/admin/users/index.html.erb', 'app/views/admin/users/index.html.erb'
get @path + 'app/views/admin/users/edit.html.erb', 'app/views/admin/users/edit.html.erb'
get @path + 'app/views/admin/users/new.html.erb', 'app/views/admin/users/new.html.erb'
get @path + 'app/views/admin/users/show.html.erb', 'app/views/admin/users/show.html.erb'

# Add route
route <<-ROUTE
  resources :admin, :only => [ :index ]
  namespace :admin do
    resources :users
  end
ROUTE


git add: "."
git commit: %Q{ -m 'Generate admin users area' }

#
# Seed the DB
# 

get @path + 'db/seeds.rb', 'db/seeds.rb'

# Seed the DB
rake "db:seed"

git add: "."
git commit: %Q{ -m 'DB seed file added' }

#
# Populate DB / populate rake task
#
get @path + 'lib/tasks/populate.rake', 'lib/tasks/populate.rake'

if populate_db
get @path + 'app/controllers/admin_controller.rb', 'app/controllers/admin_controller.rb'
  rake "db:populate"
end

git add: "."
git commit: %Q{ -m 'Added populate db rake task' }