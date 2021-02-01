module FirmApproval
  extend ActiveSupport::Concern

  def approve!
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:approved_at, Time.zone.now) unless approved_at
    # rubocop:enable Rails/SkipsModelValidations
  end

  def hide!
    # rubocop:disable Rails/SkipsModelValidations
    if hidden_at
      update_attribute(:hidden_at, nil)
    else
      update_attribute(:hidden_at, Time.zone.now)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
