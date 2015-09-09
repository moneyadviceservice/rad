require_relative '../reports/by_country_report'

namespace 'adhoc' do
  desc 'Number of firms and advisers by country'
  task firms_and_advisers_by_country: :environment do
    puts 'Looking up countries...'

    report = ByCountryReport.new

    puts report.firm_report
    puts report.adviser_report
    puts report.error_report
  end
end
