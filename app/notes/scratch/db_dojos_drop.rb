
require 'sqlite3'

cyberDojo = SQLite3::Database.new 'cyberDojo.db'

cyberDojo.execute <<-SQL
  DROP TABLE dojos
SQL

