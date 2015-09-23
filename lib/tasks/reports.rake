namespace 'reports' do
  desc 'CSV report of parent firms whose names have changed in the FCA data since they registered'
  task firms_with_out_of_date_names: :environment do
    puts Tasks::Reports.firms_with_out_of_date_names_as_csv
  end
end
