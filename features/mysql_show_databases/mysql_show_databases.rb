# This file is auto-generated for the feature: mysql_show_databases
# AI Prompt: show databases for mysql with ruby. (prease return only code without another text and markdown)

require 'mysql2'

client = Mysql2::Client.new(
  :host => "localhost",
  :username => "root",
  :password => ""
)

results = client.query("SHOW DATABASES")

results.each do |row|
  puts row["Database"]
end

client.close
