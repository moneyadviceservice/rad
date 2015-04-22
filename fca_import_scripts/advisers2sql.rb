require 'csv'
require 'date'

timestamp = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')

File.open('advisers.sql', 'w') do |file|
  CSV.foreach('advisers-utf8.ext', col_sep: '|') do |row|
    next if ['Header', 'Footer'].include? row[0]

    reference_number = row[0]
    name = row[1].gsub("'", "''").strip

    file << "insert into lookup_advisers(reference_number, name, created_at, updated_at) " \
            "values('#{reference_number}', '#{name}', '#{timestamp}', '#{timestamp}');\n"
  end
end

puts 'Done!'
