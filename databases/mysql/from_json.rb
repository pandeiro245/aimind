require 'mysql2'
require 'json'
require_relative 'base'

module Databases
  module Mysql
    class FromJson < Base
      def exec
        create_database
        use_database
        create_table
        upsert_data
        close_connection
      end
    end
  end
end

Databases::Mysql::FromJson.new.exec
