namespace 'reports' do
  desc 'CSV report of parent firms whose names have changed in the FCA data since they registered'
  task firms_with_out_of_date_names: :environment do
    puts Tasks::Reports.firms_with_out_of_date_names_as_csv
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
