RSpec.describe Reports::PrincipalAdvisers do
  let(:principal_with_3) { FactoryBot.create(:principal) }
  let!(:principal_with_0)  { FactoryBot.create(:principal) }

  let!(:principal_with_3_advisers_subsidiaries) do
    FactoryBot.create_list(:firm, 5,
                            parent: principal_with_3.firm,
                            principal: principal_with_3).tap do |firms|
      firms.map(&:advisers).each(&:destroy_all)

      FactoryBot.create(:adviser, firm: firms.first)
      FactoryBot.create(:adviser, firm: firms.first)
      FactoryBot.create(:adviser, firm: firms.last)
    end
  end

  it 'Correctly counts the advisers per principal' do
    expected = [Reports::PrincipalAdvisers::HEADER_ROW,
                expected_principal_row(principal_with_0, 0),
                expected_principal_row(principal_with_3, 3)]
    actual = CSV.parse(Reports::PrincipalAdvisers.data)
    expect(actual).to eq(expected)
  end

  def expected_principal_row(principal, adviser_count)
    [principal.fca_number.to_s, principal.full_name, principal.email_address, adviser_count.to_s]
  end
end
