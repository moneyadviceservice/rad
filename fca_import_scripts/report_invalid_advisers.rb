#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

def get_adviser_status(reference_number)
  `./lib/adviser_status.sh #{reference_number}`.split(':').last.strip.upcase
end

invalid_advisers = Adviser.all.select { |a| !a.valid? }

invalid_advisers.each do |adviser|
  if adviser.errors.full_messages.size == 1
    if adviser.errors.first[0] == :reference_number
      error = 'FCA_STATUS: ' + get_adviser_status(adviser.reference_number)
    else
      error = adviser.errors.first[1]
    end
  else
    error = 'MULTIPLE'
  end

  puts [
    adviser.reference_number,
    adviser.clone.reload.name,
    adviser.firm.registered_name,
    error,
    "http://radsignup.moneyadviceservice.org.uk/admin/advisers/#{adviser.id}"
  ].to_csv
end
