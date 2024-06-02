 module Databases
  module Mysql
    class Base
      def initialize
        host = 'localhost'
        username = 'root'
        password = ''
        database_name = 'aimind'
        table_name = 'namespaces'
        columns = ['name']
        file_path = 'databases/json/index.json'
        @client = Mysql2::Client.new(
          host: host,
          username: username,
          password: password
        )
        @database_name = database_name
        @file_path = file_path
        @table_name = table_name
        @columns = columns
      end

      def create_database
        @client.query("CREATE DATABASE IF NOT EXISTS #{@database_name}")
      end

      def use_database
        @client.query("USE #{@database_name}")
      end

      def create_table
        create_table_query = <<-SQL
          CREATE TABLE IF NOT EXISTS #{@table_name} (
            id INT AUTO_INCREMENT PRIMARY KEY,
            #{@columns[0]} VARCHAR(255) UNIQUE
          )
        SQL
        @client.query(create_table_query)
      end

      def upsert_data
        file = File.read(@file_path)
        data = JSON.parse(file)

        data.values.each do |value|
          name = @client.escape(value['name'].to_s)
          query = <<-SQL
            INSERT INTO #{@table_name} (#{@columns.join(', ')})
            VALUES ('#{name}')
            ON DUPLICATE KEY UPDATE #{@columns[0]} = VALUES(#{@columns[0]})
          SQL

          begin
            @client.query(query)
            puts "Data inserted or updated successfully"
          rescue Mysql2::Error => e
            puts "Error inserting or updating data: #{e.message}"
          end
        end
      end

      def close_connection
        @client.close
      end
    end
  end
end
