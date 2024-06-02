require_relative 'base'

module ProgrammingLanguages
  module Ruby
    module Databases
      module Mysql
        class ShowDatabases < Base
          def exec
            results = client.query("SHOW DATABASES")

            results.each do |row|
              puts row["Database"]
            end 

            client.close
          end 
        end
      end
    end
  end
end
