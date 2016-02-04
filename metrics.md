# Metrics

[Trello card][1]

We're looking to generate a delay snapshot that captures each of these metrics.
An admin can request a snapshot for a given day (or range of days) and will be
provided with a CSV.

These are all the metric descriptions that were requested:

## RAD

* Firms with NO minimum fee
  ```
  published_firms = Firm.registered.select(&:publishable?)
  published_firms.select { |f| [0, nil].include?(f.minimum_fixed_fee) }
  ```
* Firms who have a minimum fee between 1.00-500
  ```
  published_firms.select { |f| (1..500).include?(f.minimum_fixed_fee) }
  ```
* Firms who have a minimum fee between 501-1_000
  ```
  published_firms.select { |f| (501..1000).include?(f.minimum_fixed_fee) }
  ```
* Firms who will deal with any pot size i.e. they have ticked under 50_000
  ```
  under_50k_size = InvestmentSize.find_by(name: 'Under £50,000')
  firms_who_ticked_under_50k = published_firms.select { |f| f.investment_sizes.exists?(under_50k_size.id) }
  ```
* Firms who will deal with any pot size and have a minimum fee of less than 500
  ```
  firms_who_ticked_under_50k.select do |f|
    f.minimum_fixed_fee.nil? || f.minimum_fixed_fee < 500
  end
  ```

## FIRMS

* Total number of firms registered on RAD
  ```
  Firm.registered.count
  ```
* Total number of firms appearing on the directory
  ```
  published_firms.count
  ```
* Only offer face-to-face advice
  ```
  published_firms.select { |f| f.other_advice_methods.empty? }
  ```
* Only offer remote advice
  ```
  published_firms.select { |f| f.in_person_advice_methods.empty? }
  ```
* In England
  ```
  # postcode lookup to retrieve country
  england_firms.count
  ```
* In Scotland
  ```
  # postcode lookup to retrieve country
  scotland_firms.count
  ```
* In Wales
  ```
  # postcode lookup to retrieve country
  wales_firms.count
  ```
* In Northern Ireland
  ```
  # postcode lookup to retrieve country
  northern_ireland_firms.count
  ```

### Providing:

* Conversion of pension pot/other liquid savings into retirement income
  ```
  published_firms.select { |f| f.retirement_income_products_flag? }
  ```
* Defined benefit pensions (including transfers)
  ```
  published_firms.select { |f| f.pension_transfer_flag? }
  ```
* Long term care
  ```
  published_firms.select { |f| f.long_term_care_flag? }
  ```
* Equity release
  ```
  published_firms.select { |f| f.equity_release_flag? }
  ```
* Inheritance Tax and Estate Planning
  ```
  published_firms.select { |f| f.inheritance_tax_and_estate_planning_flag? }
  ```
* Wills & Probate
  ```
  published_firms.select { |f| f.wills_and_probate_flag? }
  ```
* Ethical investing
  ```
  published_firms.select { |f| f.ethical_investing_flag? }
  ```
* Sharia investing
  ```
  published_firms.select { |f| f.sharia_investing_flag? }
  ```
* Languages other than English
  ```
  published_firms.select { |f| f.languages.present? }
  ```
* Disabled access
  ```
  Office.where(disabled_access: true).count
  # or
  Office.includes(:firms).where(disabled_access: true, firms: { id: [Firm.registered.map(&:id)] }).count
  ```

## ADVISERS

* Total number of registered advisers
  ```
  Adviser.count
  ```
* In England
  ```
  # postcode lookup to retrieve country
  england_advisers.count
  ```
* In Scotland
  ```
  # postcode lookup to retrieve country
  scotland_advisers.count
  ```
* In Wales
  ```
  # postcode lookup to retrieve country
  wales_advisers.count
  ```
* In Northern Ireland
  ```
  # postcode lookup to retrieve country
  northern_ireland_advisers.count
  ```

### Will travel:

* 5 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['5 miles']).count
  ```
* 10 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['10 miles']).count
  ```
* 25 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['25 miles']).count
  ```
* 50 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['50 miles']).count
  ```
* 100 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['100 miles']).count
  ```
* 150 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['150 miles']).count
  ```
* 250 miles
  ```
  Adviser.where(travel_distance: TravelDistance.all['250 miles']).count
  ```
* UK wide
  ```
  Adviser.where(travel_distance: TravelDistance.all['UK wide']).count
  ```

### Accredited in:

* SOLLA
  ```
  Adviser.includes(:accreditations).where(accreditations: { name: 'SOLLA' }).count
  ```
* Later Life Academy
  ```
  Adviser.includes(:accreditations).where(accreditations: { name: 'Later Life Academy' }).count
  ```
* ISO 22222
  ```
  Adviser.includes(:accreditations).where(accreditations: { name: 'ISO 22222' }).count
  ```
* British Standard in Financial Planning BS8577
  ```
  Adviser.includes(:accreditations).where(accreditations: { name: 'British Standard in Financial Planning BS8577' }).count
  ```
* Other
  ```
  Adviser.includes(:accreditations).where(accreditations: { name: 'Other' }).count
  ```

### Holds qualification in:

* Level 4 (DipPFS, DipFA or equivalent)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Level 4 (DipPFS, DipFA® or equivalent)' }).count
  ```
* Level 6 (APFS, Adv DipFA)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Level 6 (APFS, Adv DipFA®)' }).count
  ```
* Chartered Financial Planner
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Chartered Financial Planner' }).count
  ```
* Certified Financial Planner
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Certified Financial Planner' }).count
  ```
* Pension transfer (G60, AF3, AwPETR or equivalent)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent' }).count
  ```
* Equity release (Certificate in Equity Release or equivalent)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent' }).count
  ```
* Long term care planning (CF8, CeLTCI or equivalent)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Long term care planning qualifications i.e. holder of CF8, CeLTCI®. or equivalent' }).count
  ```
* Trust and Estate Practitioner (TEP) i.e. full member of STEP
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Holder of Trust and Estate Practitioner qualification (TEP) i.e. full member of STEP' }).count
  ```
* Fellow of the CHartered Insurance Institute (FCII)
  ```
  Adviser.includes(:qualifications).where(qualifications: { name: 'Fellow of the Chartered Insurance Institute (FCII)' }).count
  ```

### Belongs to profiessional body:

* Personal Finance Society/Chartered Insurance Institute
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'Personal Finance Society / Chartered Insurance Institute' }).count
  ```
* Institute of Financial Planning
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'Institute of Financial Planning' }).count
  ```
* Institute of Financial Services
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'Institute of Financial Services' }).count
  ```
* The Chartered Institute of Bankers in Scotland
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'The Chartered Institute of Bankers in Scotland' }).count
  ```
* The Chartered Institute of Securities and Investments
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'The Chartered Institute for Securities and Investments' }).count
  ```
* CFA Institute
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'CFA Institute' }).count
  ```
* Institute of Chartered Accountants for England and Wales
  ```
  Adviser.includes(:professional_bodies).where(professional_bodies: { name: 'Institute of Chartered Accountants for England and Wales' }).count
  ```

[1]: https://trello.com/c/aRIlGWzv/282-rad-report-automation-as-a-data-administrator-i-would-like-all-rad-metrics-reports-to-be-produced-automatically-and-archived-so-
