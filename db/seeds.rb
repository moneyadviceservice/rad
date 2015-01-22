FactoryGirl.create_list(:principal, 3) if Rails.env.development?

[
  'At customers home',
  'At firm\'s place of business',
  'At an agreed location',
  'No, we do not offer advice in person'
].each { |item| InPersonAdviceMethod.find_or_create_by(name: item) }

[
  'Advice by telephone through to transaction',
  'Advice online e.g. by video call / conference / email or other online method(s) through to transaction'
].each { |item| OtherAdviceMethod.find_or_create_by(name: item) }

[30, 60].each { |duration| InitialMeetingDuration.find_or_create_by(duration: duration) }

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
].each { |item| OngoingAdviceFeeStructure.find_or_create_by(name: item).update!(name: item) }

[
  'From their own resources',
  'From funds to be invested',
  'Either (Removed due to inconsistency in format of question)'
].each { |item| AllowedPaymentMethod.find_or_create_by(name: item) }

[
  'Under £50,000',
  'Between £50,001 and £100,000',
  'Between £100,001 - £150,000',
  'Over £150,001',
  'All of these pot / investment sizes'
].each { |item| InvestmentSize.find_or_create_by(name: item) }
