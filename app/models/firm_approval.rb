module FirmApproval
  def approve!
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:approved_at, Time.zone.now) unless approved_at
    # rubocop:enable Rails/SkipsModelValidations
  end
end
