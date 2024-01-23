[
  'SOLLA',
  'Later Life Academy',
  'ISO 22222',
  'British Standard in Financial Planning BS8577'
].each.with_index(1) { |item, index| Accreditation.find_or_create_by!(id: index, name: item, order: index) }

[
  'From their own resources',
  'From funds to be invested'
].each.with_index(1) { |item, index| AllowedPaymentMethod.find_or_create_by!(id: index, name: item, order: index) }

[
  'At customers home',
  'At firm\'s place of business',
  'At an agreed location'
].each.with_index(1) { |item, index| InPersonAdviceMethod.find_or_create_by!(id: index, name: item, order: index) }

[
  'Hourly fee',
  'Fixed fee',
  'Other'
].each.with_index(1) { |item, index| InitialAdviceFeeStructure.find_or_create_by!(id: index, name: item, order: index) }

[
  '30 min',
  '60 min'
].each.with_index(1) { |item, index| InitialMeetingDuration.find_or_create_by!(id: index, name: item, order: index) }

[
  'Under £50,000',
  '£50,000 - £99,999',
  '£100,000 - £149,999',
  'Over £150,000'
].each.with_index(1) { |item, index| InvestmentSize.find_or_create_by!(id: index, name: item, order: index) }

[
  'Hourly fee',
  'Fixed upfront fee',
  'Monthly by direct debit / standing order',
  'Other'
].each.with_index(1) { |item, index| OngoingAdviceFeeStructure.find_or_create_by!(id: index, name: item, order: index) }

[
  'Advice by telephone',
  'Advice online (e.g. by video call / conference / email)'
].each.with_index(1) { |item, index| OtherAdviceMethod.find_or_create_by!(id: index, name: item, order: index) }

[
  'Personal Finance Society / Chartered Insurance Institute',
  'The London Institute of Banking and Finance',
  'The Chartered Institute of Bankers in Scotland',
  'The Chartered Institute for Securities and Investments',
  'CFA Institute',
  'Institute of Chartered Accountants for England and Wales'
].each.with_index(1) do |item, index|
  ProfessionalStanding.find_or_create_by!(id: index, name: item, order: index)
end

[
  'Level 4 (DipPFS, DipFA® or equivalent)',
  'Level 6 (APFS, Adv DipFA®)',
  'Chartered Wealth Manager – accredited by the Chartered Institute of Securities and Investments',
  'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent',
  'Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent',
  'Long term care planning qualifications i.e. holder of CF8, CeLTCI®. or equivalent',
  'Holder of Trust and Estate Practitioner qualification (TEP) i.e. full member of STEP',
  'Fellow of the Chartered Insurance Institute (FCII)'
].each.with_index(1) { |item, index| Qualification.find_or_create_by!(id: index, name: item, order: index) }

[
  {number: '111111', name: 'Rice Inc'},
  {number: '222222', name: 'Kreiger LLC'},
  {number: '333333', name: 'Kozey LLC'},
].each do |firm|
    Lookup::Firm.create(
      fca_number: firm[:number],
      registered_name: firm[:name]
    )
  end

[
  {
    fca_number: '111111',
    first_name: 'Mohammed',
    last_name: 'Hoeger',
    email: 'mohammed@jones.name',
    title: 'Legacy Functionality Developer',
    phone: '07111 333 222'
  },
  {
    fca_number: '222222',
    first_name: 'Irwin',
    last_name: 'Bednar',
    email: 'irwin@bernier.info',
    title: 'Lead Applications Orchestrator',
    phone: '07222 137 444'
  },
  {
    fca_number: '333333',
    first_name: 'Camilla',
    last_name: 'Heathcote',
    email: 'camilla@rolfson.info',
    title: 'Lead Web Architect',
    phone: '07333 765 396'
  }
].each do |principal|
    Principal.create(
      fca_number: principal[:fca_number],
      first_name: principal[:first_name],
      last_name: principal[:last_name],
      email_address: principal[:email],
      job_title: principal[:title],
      telephone_number: principal[:phone],
      confirmed_disclaimer: true
    )
  end
