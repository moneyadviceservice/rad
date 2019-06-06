class RemoveInstituteFinancialPlanning < ActiveRecord::Migration
  def up
    professional_standing = ProfessionalStanding
      .find_by!(name: "Institute of Financial Planning")
    professional_standing.destroy!
  end

  def down
    ProfessionalStanding.create!(name: "Institute of Financial Planning")
  end
end
