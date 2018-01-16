class AdviserQualificationsLookup
  include AdviserCertificationsLookup

  def table
    'advisers_qualifications'
  end

  def type
    'qualification'
  end
end
