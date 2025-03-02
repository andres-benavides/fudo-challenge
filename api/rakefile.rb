require 'sequel'
require 'sequel/extensions/migration'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/development.sqlite3')

namespace :db do
  desc "execute migrations"
  task :migrate do
    Sequel::Migrator.run(DB, 'db/migrations')
    puts "migrations ok"
  end

  desc "Rollback last migration"
  task :rollback do
    DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/development.sqlite3')
    Sequel::Migrator.run(DB, 'db/migrations', target: DB[:schema_migrations].max(:filename).to_i - 1)
    puts "Last migration revert"
  end
end
