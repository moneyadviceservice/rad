class AddNewQualifications < ActiveRecord::Migration
  UPDATED_QUALIFICATIONS_LIST = [
    'Level 4 (DipPFS, DipFA® or equivalent)',
    'Level 6 (APFS, Adv DipFA®)',
    'Chartered Financial Planner - accredited by the Chartered Insurance Institute / Personal Finance Society',
    'Certified Financial Planner - accredited by the Chartered Institute of Securities and Investments',
    'Chartered Wealth Manager – accredited by the Chartered Institute of Securities and Investments',
    'Pension Transfer Gold Standard',
    'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent',
    'Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent',
    'Long term care planning qualifications i.e. holder of CF8, CeLTCI®. or equivalent',
    'Holder of Trust and Estate Practitioner qualification (TEP) i.e. full member of STEP',
    'Fellow of the Chartered Insurance Institute (FCII)'
  ]

  NEW_QUALIFICATIONS = [
    UPDATED_QUALIFICATIONS_LIST[4],
    UPDATED_QUALIFICATIONS_LIST[5]
  ]

  EXISTING_QUALIFICATIONS_LIST = UPDATED_QUALIFICATIONS_LIST - NEW_QUALIFICATIONS

  def up
    NEW_QUALIFICATIONS.each { |name| Qualification.create!(name: name) }

    UPDATED_QUALIFICATIONS_LIST.each.with_index(1) do |name, index|
      qualification = Qualification.where(name: name).first!
      qualification.update(order: index)
    end
  end

  def down
    Qualification.where(name: NEW_QUALIFICATIONS).each { |q| q.destroy }

    EXISTING_QUALIFICATIONS_LIST.each.with_index(1) do |name, index|
      Qualification.where(name: name).first!.update(order: index)
    end
  end
end
