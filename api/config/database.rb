require 'sequel'

ENV['RACK_ENV'] ||= 'development'

DATABASE_URLS = {
  'development' => 'sqlite://db/development.sqlite3',
  'test' => 'sqlite::memory:',
  'production' => ENV['DATABASE_URL'] || 'sqlite://db/production.sqlite3'
}

DB = Sequel.connect(DATABASE_URLS[ENV['RACK_ENV']])
