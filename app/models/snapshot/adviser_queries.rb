module Snapshot::AdviserQueries
  def query_registered_advisers
    Adviser.all
  end

  def query_advisers_in_england
    advisers_in_country(Adviser.all, 'England')
  end

  def query_advisers_in_scotland
    advisers_in_country(Adviser.all, 'Scotland')
  end

  def query_advisers_in_wales
    advisers_in_country(Adviser.all, 'Wales')
  end

  def query_advisers_in_northern_ireland
    advisers_in_country(Adviser.all, 'Northern Ireland')
  end

  TravelDistance.all.each_key do |key|
    method_name = key.downcase.tr(' ', '_')
    define_method "query_advisers_who_travel_#{method_name}" do
      advisers_who_travel(key)
    end
  end

  def query_advisers_accredited_in_solla
    advisers_with_accreditation('SOLLA')
  end

  def query_advisers_accredited_in_later_life_academy
    advisers_with_accreditation('Later Life Academy')
  end

  def query_advisers_accredited_in_iso22222
    advisers_with_accreditation('ISO 22222')
  end

  def query_advisers_accredited_in_bs8577
    advisers_with_accreditation('British Standard in Financial Planning BS8577')
  end

  def query_advisers_with_qualification_in_level_4
    advisers_with_qualification('Level 4 (DipPFS, DipFA® or equivalent)')
  end

  def query_advisers_with_qualification_in_level_6
    advisers_with_qualification('Level 6 (APFS, Adv DipFA®)')
  end

  def query_advisers_with_qualification_in_chartered_financial_planner
    advisers_with_qualification('Chartered Financial Planner')
  end

  def query_advisers_with_qualification_in_certified_financial_planner
    advisers_with_qualification('Certified Financial Planner')
  end

  def query_advisers_with_qualification_in_pension_transfer
    advisers_with_qualification('Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent')
  end

  def query_advisers_with_qualification_in_equity_release
    advisers_with_qualification('Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent')
  end

  def query_advisers_with_qualification_in_long_term_care_planning
    advisers_with_qualification('Long term care planning qualifications i.e. holder of CF8, CeLTCI®. or equivalent')
  end

  def query_advisers_with_qualification_in_tep
    advisers_with_qualification('Holder of Trust and Estate Practitioner qualification (TEP) i.e. full member of STEP')
  end

  def query_advisers_with_qualification_in_fcii
    advisers_with_qualification('Fellow of the Chartered Insurance Institute (FCII)')
  end

  def query_advisers_with_qualification_in_chartered_associate
    advisers_with_qualification('Chartered Associate of The London Institute of Banking & Finance')
  end

  def query_advisers_with_qualification_in_chartered_fellow
    advisers_with_qualification('Chartered Fellow of The London Institute of Banking & Finance')
  end

  private

  def advisers_in_country(advisers, country)
    postcodes = advisers.map(&:postcode)
    country_postcodes = Postcode.new.filter_postcodes_by_country(postcodes, country)
    advisers.select { |adviser| country_postcodes.include?(adviser.postcode) }
  end

  def advisers_who_travel(distance)
    Adviser.where(travel_distance: TravelDistance.all[distance])
  end

  def advisers_with_accreditation(accreditation)
    Adviser.includes(:accreditations).where(accreditations: { name: accreditation })
  end

  def advisers_with_qualification(qualification)
    Adviser.includes(:qualifications).where(qualifications: { name: qualification })
  end
end
