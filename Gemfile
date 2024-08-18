source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"

gem 'grape'
gem 'httparty'
gem 'delayed_job_active_record'
gem 'rufus-scheduler'
gem 'redis', require: 'redis'

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

