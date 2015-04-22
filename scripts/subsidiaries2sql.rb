require 'csv'
require 'date'

timestamp = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')

File.open('subsidiaries.sql', 'w') do |file|
  CSV.foreach('subsidiaries-utf8.ext', col_sep: '|') do |row|
    next if ['Header', 'Footer'].include? row[0]

    fca_number = row[0]
    name = row[1].gsub("'", "''").strip

    file << "insert into lookup_subsidiaries(fca_number, name, created_at, updated_at) " \
            "values('#{fca_number}', '#{name}', '#{timestamp}', '#{timestamp}');\n"
  end
end

puts 'Done!'
