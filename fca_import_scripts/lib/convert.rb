#!/usr/bin/ruby
require_relative 'ext_to_sql'

def print_usage
  puts 'USAGE: '
  puts '  ruby ext_to_sql.rb FILE'
  exit
end

def options
  print_usage unless ARGV.length == 1
  {
    file: ARGV[0]
  }
end

ext_to_sql = ExtToSql.new(STDERR)

ext_to_sql.process_ext_file(options[:file]) do |line|
  puts line
end

STDERR.puts
