require_relative 'base'
require 'pry'

module ProgrammingLanguages
  module Ruby
    module Databases
      module Mysql
        class ShowTables < Base
          def exec
            results = client.query("SHOW TABLES")
            results.each do |row|
              puts row.values
            end

            client.close
          end 
        end
      end
    end
  end
end
