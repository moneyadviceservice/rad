require 'csv'

namespace :export do
  desc 'Export Firms to CSV=(/path/to/csv)'
  task firms: :environment do
    unless csv_path = ENV['CSV']
      puts 'Usage: rake export:firms CSV=/path/to/csv.ext'
      abort
    end

    CSV.open(csv_path, 'wb') do |csv|
      csv << [
        'ID',
        'Parent ID',
        'Created At',
        'Updated At',
        'FCA Number',
        'Registered Name',
        'Email Address',
        'Telephone Number',
        'Address Line One',
        'Address Line Two',
        'Address Town',
        'Address County',
        'Address Postcode',
        'In-person Advice Methods',
        'Other Advice Methods',
        'Free Initial Meeting',
        'Initial Meeting Duration',
        'Initial Advice Fee Structures',
        'Ongoing Advice Fee Structures',
        'Allowed Payment Methods',
        'Minimum Fixed Fee',
        'Retirement Income Products Percent',
        'Pension Transfer Percent',
        'Long-Term Care Percent',
        'Equity Release Percent',
        'Inheritance Tax and Estate Planning Percent',
        'Wills and Probate percent',
        'Other Percent',
        'Investment Sizes'
      ]

      Firm.order(id: :asc).each do |firm|
        csv << [
          firm.id,
          firm.parent_id,
          firm.created_at,
          firm.updated_at,
          firm.fca_number,
          firm.registered_name,
          firm.email_address,
          firm.telephone_number,
          firm.address_line_one,
          firm.address_line_two,
          firm.address_town,
          firm.address_county,
          firm.address_postcode,
          firm.in_person_advice_methods.map(&:name).join(', '),
          firm.other_advice_methods.map(&:name).join(', '),
          firm.free_initial_meeting,
          (firm.initial_meeting_duration && firm.initial_meeting_duration.name),
          firm.initial_advice_fee_structures.map(&:name).join(', '),
          firm.ongoing_advice_fee_structures.map(&:name).join(', '),
          firm.allowed_payment_methods.map(&:name).join(', '),
          firm.minimum_fixed_fee,
          firm.retirement_income_products_percent,
          firm.pension_transfer_percent,
          firm.long_term_care_percent,
          firm.equity_release_percent,
          firm.inheritance_tax_and_estate_planning_percent,
          firm.wills_and_probate_percent,
          firm.other_percent,
          firm.investment_sizes.map(&:name).join(', ')
        ]
      end
    end
  end
end
