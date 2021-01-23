require 'rom'

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = ROM.container(:sql, 'sqlite://db/database.sqlite3')
  end
end
