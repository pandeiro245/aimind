require 'mysql2'

module ProgrammingLanguages
  module Ruby
    module Databases
      module Mysql
        class Base
          def client
            @client ||= Mysql2::Client.new(
              host: "localhost",
              username: "root",
              password: ""
            )
          end
        end
      end
    end
  end
end

