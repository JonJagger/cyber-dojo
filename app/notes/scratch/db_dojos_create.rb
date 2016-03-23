
require 'sqlite3'

cyberDojo = SQLite3::Database.new 'cyberDojo.db'

cyberDojo.execute <<-SQL
  CREATE TABLE dojos (
    id CHAR(10) NOT NULL,
    created VARCHAR(127) NOT NULL,
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

