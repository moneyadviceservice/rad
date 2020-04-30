class Firm < ApplicationRecord
  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number
  belongs_to :parent, class_name: 'Firm'

  has_one :inactive_firm, dependent: :destroy
  has_many :subsidiaries, class_name: 'Firm',
                          foreign_key: :parent_id,
                          dependent: :destroy
  has_many :trading_names, class_name: 'Firm',
                           foreign_key: :parent_id,
                           dependent: :destroy
  belongs_to :firmlike, dependent: :destroy, polymorphic: true

  after_commit :notify_indexer

  def retirement_firm
    # TODO : we only expect one instance in this list or none. enforce it with uniqueness at DB level if possible and handle nils here
    @retirement_firm ||= :firmlike_of_RetirementFirm.first
  end

  # TODO : temporarily delegate all original retirement calls received. Callers should migrate to calling the specialist retirement_fimr directly to get rid of this delegatio
  delegate :onboarded?, :in_person_advice?, :postcode_searchable?, :trading_name?, :subsidiary?, :field_order?, :advice_types, :primary_advice_method, :main_office, :publishable?, to: :retirement_firm
  # TODO : temporarily delegate scopes below, need to make these direct in a future commit
  delegate :sorted_by_registered_name, :onboarded, to: :retirement_firm
  # TODO: temporarily delegating the only class method. looks like this is only used by the tests. look into deprecating it all together
  delegate :languages_used, to: ::RetirementFirm
  # TODO : temporarily delegate the retirement_firm relations. Idea is to migrate clients to using the specialised class directly
  delegate :in_person_advice_methods,
    :other_advice_methods,
    :initial_advice_fee_structures,
    :ongoing_advice_fee_structures,
    :allowed_payment_methods,
    :investment_sizes,
    :initial_meeting_duration,
    :advisers,
    :qualifications,
    :accreditations,
    :offices, to: :retirement_firm
  # TODO : temporarily delegate relevant  attr_accessors to retirement_firm. Clients should be migrated to accessing these directly
  delegate :percent_total, :primary_advice_method, :website_address, to: :retirement_firm
  # TODO : delegate the algolia indexing to the retirement_firm.
  # Remember to flatten the index record to look exactly like what rad-consumer currently consumes thus avoiding rad-consumer code changes
  # clients should be migrated to using retirement_firm directly
  delegate :notify_indexer, to: :retirement_firm

  def trading_name?
    parent.present?
  end

  alias subsidiary? trading_name?
end
