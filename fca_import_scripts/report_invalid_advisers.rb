#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

STATUS_STRINGS = {
  '1' => 'Banned',
  '2' => 'Applied',
  '3' => 'Inactive',
  '4' => 'Active',
  '5' => 'Deceased'
}.freeze
FRN_INDEX = 0
STATUS_INDEX = 4
HEADERS = ['FCA REF', 'ADVISER NAME', 'FIRM NAME', 'ERROR TYPE', 'LINK'].to_csv

def log(message)
  STDERR.puts(message)
end

def status_code_to_str(status_code)
  STATUS_STRINGS.fetch(status_code, "UNKNOWN STATUS CODE (#{status_code})")
end

def load_adviser_statuses
  log 'Loading adviser statuses'

  frn_to_status_hash = File.open('ext/advisers-utf8.ext', 'r') do |file|
    file.each_line.each_with_object({}) do |line, hash|
      record = line.split('|')
      next if %w(Header Footer).include? record[FRN_INDEX]
      hash[record[FRN_INDEX]] = record[STATUS_INDEX]
    end
  end

  frn_to_status_hash
end

def adviser_statuses
  @adviser_statuses ||= load_adviser_statuses
end

def get_adviser_status(reference_number)
  status_code_to_str(adviser_statuses[reference_number])
end

log 'Searching for invalid advisers'
invalid_advisers = Adviser.all.select { |a| !a.valid? }

log 'Processing list of invalid advisers'
puts HEADERS
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

log 'Done'
