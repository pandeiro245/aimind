require 'mysql2'

module ProgrammingLanguages
  module Ruby
    module Databases
      module Mysql
        class Base
          def initialize
            @table_name = 'namespaces'
            @columns = ['name']
            @file_path = 'databases/json/index.json'
            @database_name = 'aimind'
          end

          def client
            @client ||= Mysql2::Client.new(
              host: "localhost",
              username: "root",
              password: "",
              database: @database_name
            )
          end

         def create_database
            client.query("CREATE DATABASE IF NOT EXISTS #{@database_name}")
          end

          def use_database
            client.query("USE #{@database_name}")
          end

          def create_table
            create_table_query = <<-SQL
              CREATE TABLE IF NOT EXISTS #{@table_name} (
                id INT AUTO_INCREMENT PRIMARY KEY,
                #{@columns[0]} VARCHAR(255) UNIQUE
              )
            SQL
            client.query(create_table_query)
          end

          def upsert_data
            file = File.read(@file_path)
            data = JSON.parse(file)

            data.values.each do |value|
              name = client.escape(value['name'].to_s)

              check_query = "SELECT COUNT(*) AS count FROM #{@table_name} WHERE #{@columns[0]} = '#{name}'"
              result = client.query(check_query)
              count = result.first['count']

              query = <<-SQL
                INSERT INTO #{@table_name} (#{@columns.join(', ')})
                VALUES ('#{name}')
                ON DUPLICATE KEY UPDATE #{@columns[0]} = VALUES(#{@columns[0]})
              SQL

              begin
                client.query(query)
                if count > 0
                  puts "Data updated successfully"
                else
                  puts "Data inserted successfully"
                end
              rescue Mysql2::Error => e
                puts "Error inserting or updating data: #{e.message}"
              end
            end
          end

          def close_connection
            client.close
          end
        end
      end
    end
  end
end

