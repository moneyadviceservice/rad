class UpdateQualificationNames < ActiveRecord::Migration
  NAMES =
    [
      {
        old: 'Chartered Financial Planner',
        new: 'Chartered Financial Planner - accredited by the Chartered Insurance Institute / Personal Finance Society'
      },
      {
        old: 'Certified Financial Planner',
        new: 'Certified Financial Planner - accredited by the Chartered Institute of Securities and Investments'
      }
    ]

  def up
    NAMES.each do |name|
      Qualification.where(name: name[:old]).first!.update!(name: name[:new])
    end
  end

  def down
    NAMES.each do |name|
      Qualification.where(name: name[:new]).first!.update!(name: name[:old])
    end
  end
end
