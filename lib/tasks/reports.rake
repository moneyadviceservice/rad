namespace 'reports' do
  desc 'Audit of the firms listed to compare the data against FCA data.'
  task :audit_firms, [:file] => :environment do |t, args|
    Reports::AuditRadFirms.new.to_csv
    Reports::AuditFcaFirms.new(fca_file: args[:file]).to_csv
  end

  desc 'Analyses the differences between the DB and the Index and provides a suggested action to fix'
  task audit_index: :environment do
    Tasks::AuditIndex.analyse
  end

  desc 'Same as audit_index but outputs CSV'
  task audit_index_csv: :environment do
    puts Tasks::AuditIndex.to_csv
  end
end
