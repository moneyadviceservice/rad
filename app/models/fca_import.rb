require 'core_ext/array'

class FcaImport < ActiveRecord::Base
  scope :not_confirmed, -> { where.not(confirmed: true) }

  def lookup_advisers
    []
  end

  def lookup_firms
    []
  end

  def lookup_subsidiaries
    []
  end

  def files
    []
  end

  def commit(confirmation)
    if confirmation == :confirm
      FcaComfirmationJob.perform_async(id)
    else
      update_column(:cancelled, false)
    end
  end
end
