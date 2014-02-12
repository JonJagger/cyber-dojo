
require 'sqlite3'

# Open a SQLite 3 database file
cyberDojo = SQLite3::Database.new 'cyberDojo.db'

# Create a table
result = cyberDojo.execute <<-SQL
  DROP TABLE dojos
SQL

result = cyberDojo.execute <<-SQL
  CREATE TABLE dojos (
    id CHAR(10) NOT NULL,
    language VARCHAR(127) NOT NULL,
    exercise VARCHAR(127) NOT NULL,
    animals INT,
    reds  INT,
    ambers INT,
    greens INT,
    votes INT,
    CONSTRAINT dojos_pk PRIMARY KEY (id)
  );
SQL

