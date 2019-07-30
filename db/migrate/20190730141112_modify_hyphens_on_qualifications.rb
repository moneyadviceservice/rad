class ModifyHyphensOnQualifications < ActiveRecord::Migration
  def up
    # The point of this migration may be unclear depending on how your text
    # editor displays hyphens and dashes. The first array is a list of existing
    # qualification names. They contain short dashes. The second array below
    # contains longer hyphens instead.
    current = [
      'Chartered Financial Planner - accredited by the Chartered Insurance Institute / Personal Finance Society',
      'Certified Financial Planner - accredited by the Chartered Institute of Securities and Investments',
      'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent'
    ]

    [
      'Chartered Financial Planner – accredited by the Chartered Insurance Institute / Personal Finance Society',
      'Certified Financial Planner – accredited by the Chartered Institute of Securities and Investments',
      'Pension transfer qualifications – holder of G60, AF3, AwPETR®, or equivalent'
    ].each_with_index do |name, index|
      Qualification.find_by(name: current[index]).update(name: name)
    end
  end

  def down
    # noop
  end
end
