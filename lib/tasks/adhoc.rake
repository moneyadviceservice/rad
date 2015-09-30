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

  desc 'Prints several interesting stats about the firms in the directory'
  task firm_stats: :environment do
    published_firms = Firm.registered.select(&:publishable?)

    puts "Total firms (face-to-face & remote): #{published_firms.count}"
    remote = published_firms.select { |f| f.primary_advice_method == :remote }
    puts "Total firms (remote): #{remote.count}"

    no_min_fee = published_firms.select { |f| [0, nil].include?(f.minimum_fixed_fee) }
    puts "Firms with NO minimum fee: #{no_min_fee.count}"

    fee_between_1_and_500 = published_firms.select { |f| (1..500).include?(f.minimum_fixed_fee) }
    puts "Firms who have a minimum fee between £1.00 - £500: #{fee_between_1_and_500.count}"

    fee_between_501_and_1000 = published_firms.select { |f| (501..1000).include?(f.minimum_fixed_fee) }
    puts "Firms who have a minimum fee between £501 - £1000: #{fee_between_501_and_1000.count}"

    under_50k_size = InvestmentSize.find_by(name: 'Under £50,000')
    firms_who_ticked_under_50k = published_firms.select { |f| f.investment_sizes.exists?(under_50k_size.id) }
    puts "Firms who will deal with any pot size i.e they have ticked under £50,000: #{firms_who_ticked_under_50k.count}"

    firms_who_ticked_under_50k_lt_500_fee = firms_who_ticked_under_50k.select do |f|
      f.minimum_fixed_fee.nil? || f.minimum_fixed_fee < 500
    end
    puts 'Firms who will deal with any pot size and have a minimum fee of ' \
         "less than £500: #{firms_who_ticked_under_50k_lt_500_fee.count}"
  end
end
