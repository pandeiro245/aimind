require 'openai'
require 'fileutils'
require 'json'
require 'dotenv/load'
require 'pry'

# OpenAI APIの設定
OPENAI_API_KEY = ENV['OPENAI_ACCESS_TOKEN']

client = OpenAI::Client.new(access_token: OPENAI_API_KEY)

# ターミナルからの入力を受け取る
puts "Enter the feature name:"
# feature_name = gets.chomp
feature_name = 'mysql_show_tables'

puts "Enter the AI prompt:"
# text = gets.chomp
text = "show tables from the database named 'aimind' for mysql"
ai_prompt = "#{text} with ruby. (prease return only code without another text and markdown)"

response = client.chat(
  parameters: {
    model: 'gpt-4o',
    messages: [{ role: 'user', content: ai_prompt }], 
    temperature: 0.7,
  }   
)

generated_code = response['choices'].first['message']['content']


file_path = "features/#{feature_name}.rb"
File.open(file_path, 'w') do |file|
  file.write("# This file is auto-generated for the feature: #{feature_name}\n")
  file.write("# AI Prompt: #{ai_prompt}\n\n")
  file.write(generated_code)
end

puts "File created at #{file_path}"

