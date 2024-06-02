require 'mysql2'
require 'json'

client = Mysql2::Client.new(
  host: 'localhost',
  username: 'root',
  password: ''
)

database_name = 'aimind'
client.query("CREATE DATABASE IF NOT EXISTS #{database_name}")

client.query("USE #{database_name}")

file_path = 'databases/json/index.json'
file = File.read(file_path)
data = JSON.parse(file)

table_name = 'namespaces'
columns = ['name']

create_table_query = <<-SQL
  CREATE TABLE IF NOT EXISTS #{table_name} (
    id INT AUTO_INCREMENT PRIMARY KEY,
    #{columns[0]} VARCHAR(255) UNIQUE
  )
SQL
client.query(create_table_query)

data.values.each do |value|
  name = client.escape(value['name'].to_s)
  query = <<-SQL
    INSERT INTO #{table_name} (#{columns.join(', ')})
    VALUES ('#{name}')
    ON DUPLICATE KEY UPDATE #{columns[0]} = VALUES(#{columns[0]})
  SQL

  begin
    client.query(query)
    puts "Data inserted or updated successfully"
  rescue Mysql2::Error => e
    puts "Error inserting or updating data: #{e.message}"
  end
end

client.close

