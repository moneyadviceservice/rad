require 'net/http'

class ByCountryReport
  def initialize
    @registered_firms = Firm.registered
    @lookup = fetch_countries
  end

  def firm_report
    firms = @registered_firms.where(parent_id: nil) # don't include trading names
    grouped_firms = firms.group_by do |firm|
      @lookup[postcode_slug_for(firm)]
    end
    generate_report('Firms', grouped_firms, firms.count)
  end

  def adviser_report
    advisers = @registered_firms.map(&:advisers).flatten # include trading names
    grouped_advisers = advisers.group_by do |adviser|
      @lookup[postcode_slug_for(adviser.firm)]
    end
    generate_report('Advisers', grouped_advisers, advisers.count)
  end

  def error_report
    grouped_firms = @registered_firms.group_by do |firm|
      @lookup[postcode_slug_for(firm)]
    end
    firms_with_errors = grouped_firms.select { |k, _| k.blank? }.values.flatten.map(&:id).uniq
    firms = firms_with_errors.flatten.map { |id| Firm.find(id) }.uniq.sort

    report =  "\nERRORS"
    report << "\n======"
    firms.each do |firm|
      report << "\n"
      report << "#{firm.address_postcode} : "
      report << "#{firm.registered_name} (#{firm.fca_number}) "
      report << "#{firm.advisers.count} advisers"
    end
    report
  end

  private

  def fetch_countries
    lookup = {}
    request = Net::HTTP::Post.new('/postcodes')

    unique_postcodes.each_slice(100) do |postcode_slice| # API restricted to 100 postcodes at a time
      request.set_form_data(postcodes: postcode_slice)
      response = Net::HTTP.new('api.postcodes.io').request(request)

      if response.code.to_i == 200
        result = JSON.parse(response.read_body)['result'].map { |r| r['result'] }.compact

        lookup_slice = result.each_with_object({}) do |item, obj|
          key = item['postcode'].gsub(' ', '')
          obj[key] = item['country']
          obj
        end

        lookup.merge!(lookup_slice)
      else
        fail "ERROR [#{response.code}]:  #{response.read_body}"
      end
    end

    lookup
  end

  def unique_postcodes
    # has to include all postcodes that could be linked to either a firm or an advisor
    @registered_firms.map(&:address_postcode).uniq
  end

  def postcode_slug_for(firm)
    firm.address_postcode.gsub(' ', '')
  end

  def generate_report(name, grouped_items, total_count)
    valid_items = grouped_items.reject { |k, _| k.blank? }
    error_count = grouped_items.select { |k, _| k.blank? }.values.flatten.count
    data = valid_items.map { |k, v| "#{k}: #{v.count}" }.sort

    %(
#{name}
#{Array.new(name.size) { '=' }.join}
#{data.join("\n")}
Errors: #{error_count}

Total: #{total_count}
    )
  end
end
