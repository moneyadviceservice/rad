require 'csv'
require 'date'

timestamp = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')

File.open('firms.sql', 'w') do |file|
  CSV.foreach('firms-utf8.ext', col_sep: '|') do |row|
    next if ['Header', 'Footer'].include? row[0]

    fca_number = row[0]
    name = row[1].gsub("'", "''").strip

    file << "insert into lookup_firms(fca_number, registered_name, created_at, updated_at) " \
            "values('#{fca_number}', '#{name}', '#{timestamp}', '#{timestamp}');\n"
  end
end

puts 'Done!'
