#!/usr/bin/ruby
require_relative 'ext_to_sql'

CSV.foreach(ExtToSql::CLI.options[:file], col_sep: '|') do |row|
  next if row[0] == 'Footer'

  if row[0] == 'Header'
    @type = ExtToSql.determine_type_from_header(row)
    ExtToSql::CLI.print_to_stderr_and_flush "  • \033[33;36mConverting #{@type} EXT to SQL.\033[0m "
    next
  end

  puts ExtToSql.build_row_for_type(@type, row)
  ExtToSql::CLI.write_progress
end

STDERR.puts
