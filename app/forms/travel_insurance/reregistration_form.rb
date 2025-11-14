class TravelInsurance::ReregistrationForm
  include ActiveModel::Model

  attr_accessor :confirmed_disclaimer

  validates_acceptance_of :confirmed_disclaimer

  def initialize(firm, params)
    @firm = firm

    super(params)
  end

  def fca_number
    @firm.fca_number
  end
end
