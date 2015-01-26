FactoryGirl.create_list(:principal, 3) if Rails.env.development?

[
  'At customers home',
  'At firm\'s place of business',
  'At an agreed location',
].each { |item| InPersonAdviceMethod.find_or_create_by(name: item) }

[
  'Advice by telephone',
  'Advice online (e.g. by video call / conference / email)'
].each { |item| OtherAdviceMethod.find_or_create_by(name: item) }

[
  '30 min',
  '60 min'
].each { |item| InitialMeetingDuration.find_or_create_by(name: item) }

[
  'Hourly fee',
  'Fixed fee',
  'Other',
].each { |item| InitialAdviceFeeStructure.find_or_create_by(name: item) }

[
  'Hourly fee',
  'Fixed upfront fee',
  'Monthly by direct debit (standing order?)',
  'Other'
].each { |item| OngoingAdviceFeeStructure.find_or_create_by(name: item) }

[
  'From their own resources',
  'From funds to be invested',
  'Either (Removed due to inconsistency in format of question)'
].each { |item| AllowedPaymentMethod.find_or_create_by(name: item) }

[
  'Under £50,000',
  'Between £50,001 and £100,000',
  'Between £100,001 - £150,000',
  'Over £150,001'
].each { |item| InvestmentSize.find_or_create_by(name: item) }

[
  'SOLLA',
  'Later Life Academy',
  'ISO 22222',
  'British Standard in Financial Planning BS8577',
  'Other'
].each { |item| Accreditation.find_or_create_by(name: item) }

[
  'Level 4 (DipPFS, DipFA® or equivalent)',
  'Level 6 Diploma in Financial Advice (Adv DipFA®)',
  'Chartered Financial Planner',
  'Certified Financial Planner',
  'Pension transfer qualifications - holder of G60, AF3 or equivalent',
  'Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent',
  'Long term care planning qualifications i.e. holder of CF8 or equivalent'
].each { |item| Qualification.find_or_create_by(name: item) }

[
  'Personal Finance Society / Chartered Insurance Institute',
  'Institute of Financial Planning',
  'Institute of Financial Services',
  'The Chartered Institute of Bankers in Scotland',
  'The Chartered Institute for Securities and Investments',
  'CFA Institute',
  'Institute of Chartered Accountants for England and Wales'
].each do |item|
  ProfessionalStanding.find_or_create_by(name: item)
  ProfessionalBody.find_or_create_by(name: item)
end
