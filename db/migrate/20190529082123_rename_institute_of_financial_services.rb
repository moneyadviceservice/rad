class RenameInstituteOfFinancialServices < ActiveRecord::Migration
  def up
    old = ProfessionalStanding.find_by!(name: 'Institute of Financial Services')
    old.update(name: 'The London Institute of Banking and Finance')
  end

  def down
    new = ProfessionalStanding.find_by!(name: 'The London Institute of Banking and Finance')
    new.update(name: 'Institute of Financial Services')
  end
end
