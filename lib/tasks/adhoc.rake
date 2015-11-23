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
    puts 'Generating, please wait ...'
    published_firms = Firm.registered.select(&:publishable?)
    published_firm_ids = published_firms.map(&:id)

    puts
    puts 'WHOLE SYSTEM'
    puts "Total firm records in the system: #{Firm.count}"
    puts 'Which breaks down into:'
    puts "  Total parent firms: #{Firm.where(parent: nil).count}"
    puts "  Total trading names: #{Firm.where.not(parent: nil).count}"
    puts "Total advisers in the system: #{Adviser.count}"
    puts "Total principals in the system: #{Principal.count}"

    puts
    puts 'FIRMS'
    puts '(Here "registered" means that a firm record has been filled out but more'
    puts 'information would be required before they can appear on the directory.'
    puts 'The total number of principals in the whole system may be a better'
    puts 'indicator of how many distinct businesses have signed up.)'
    puts

    puts "Total number of firms registered: #{Firm.registered.count}"
    puts 'Which breaks down into:'
    puts "  Parent firms registered: #{Firm.registered.where(parent: nil).count}"
    puts "  Trading names registered: #{Firm.registered.where.not(parent: nil).count}"

    puts
    puts "Total number of firms appearing on the directory (published): #{published_firms.count}"
    remote = published_firms.select { |f| f.primary_advice_method == :remote }
    puts 'Which breaks down into:'
    puts "  Face-to-face only advice: #{published_firms.count - remote.count}"
    puts "  Remote-only advice: #{remote.count}"

    puts
    puts 'FEES & POT SIZE'
    no_min_fee = published_firms.select { |f| [0, nil].include?(f.minimum_fixed_fee) }
    puts "Published firms with NO minimum fee: #{no_min_fee.count}"

    fee_between_1_and_500 = published_firms.select { |f| (1..500).include?(f.minimum_fixed_fee) }
    puts "Published firms who have a minimum fee between £1.00 - £500: #{fee_between_1_and_500.count}"

    fee_between_501_and_1000 = published_firms.select { |f| (501..1000).include?(f.minimum_fixed_fee) }
    puts "Published firms who have a minimum fee between £501 - £1000: #{fee_between_501_and_1000.count}"

    under_50k_size = InvestmentSize.find_by(name: 'Under £50,000')
    firms_who_ticked_under_50k = published_firms.select { |f| f.investment_sizes.exists?(under_50k_size.id) }
    puts 'Published firms who will deal with any pot size i.e they have ticked' \
         "under £50,000: #{firms_who_ticked_under_50k.count}"

    firms_who_ticked_under_50k_lt_500_fee = firms_who_ticked_under_50k.select do |f|
      f.minimum_fixed_fee.nil? || f.minimum_fixed_fee < 500
    end
    puts 'Published firms who will deal with any pot size and have a minimum fee of ' \
         "less than £500: #{firms_who_ticked_under_50k_lt_500_fee.count}"

    puts
    puts 'ADVISERS'
    puts "Total number of published advisers: #{Adviser.geocoded.where(firm: published_firm_ids).count}"
    puts
  end
end
