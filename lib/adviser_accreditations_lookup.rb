class AdviserAccreditationsLookup
  include AdviserCertificationsLookup

  def table
    'accreditations_advisers'
  end

  def type
    'accreditation'
  end
end
