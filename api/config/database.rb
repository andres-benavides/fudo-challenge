require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/development.sqlite3')
