class Admin::TravelInsuranceFirmsIndexPage < Admin::FirmsIndexPage
  set_url '/admin/travel_insurance_firms'
  set_url_matcher %r{/admin/travel_insurance_firms}

  def clear_form
    fill_out_form(fca_number: '', registered_name: '')
  end

  def total_results_regexp
    %r{Displaying( all)? (\d) travel insurance firms?}
  end
end
