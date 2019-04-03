module AlgoliaIndex
  class FirmSerializer < ActiveModel::Serializer
    attributes :id,
               :registered_name,
               :postcode_searchable,
               :telephone_number,
               :website_address,
               :email_address,
               :free_initial_meeting,
               :minimum_fixed_fee,
               :retirement_income_products_flag,
               :pension_transfer_flag,
               :long_term_care_flag,
               :equity_release_flag,
               :inheritance_tax_and_estate_planning_flag,
               :wills_and_probate_flag,
               :other_advice_methods,
               :investment_sizes,
               :in_person_advice_methods,
               :adviser_qualification_ids,
               :adviser_accreditation_ids,
               :ethical_investing_flag,
               :sharia_investing_flag,
               :workplace_financial_advice_flag,
               :non_uk_residents_flag,
               :languages,
               :total_offices,
               :total_advisers

    def adviser_accreditation_ids
      object.accreditation_ids
    end

    def adviser_qualification_ids
      object.qualification_ids
    end

    def total_advisers
      object.advisers.geocoded.count
    end

    def offices
      object.offices.geocoded
    end

    def total_offices
      offices.count
    end

    def telephone_number
      object.main_office.try(:telephone_number)
    end

    def email_address
      object.main_office.try(:email_address)
    end

    def website_address
      object.main_office.try(:website) || object.website_address
    end

    def postcode_searchable
      object.postcode_searchable?
    end

    def other_advice_methods
      object.other_advice_method_ids
    end

    def in_person_advice_methods
      object.in_person_advice_method_ids
    end

    def investment_sizes
      object.investment_size_ids
    end
  end
end
