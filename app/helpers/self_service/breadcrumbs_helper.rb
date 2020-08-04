module SelfService::BreadcrumbsHelper
  def breadcrumbs_root
    [crumb_root]
  end

  def breadcrumbs_firm_edit
    breadcrumbs_root << crumb_firm_edit
  end

  def breadcrumbs_firm_advisers
    breadcrumbs_firm_edit << crumb_firm_advisers
  end

  def breadcrumbs_firm_adviser_edit
    breadcrumbs_firm_advisers << crumb_firm_adviser_edit
  end

  def breadcrumbs_firm_adviser_new
    breadcrumbs_firm_advisers << crumb_firm_adviser_new
  end

  def breadcrumbs_firm_offices
    breadcrumbs_firm_edit << crumb_firm_offices
  end

  def breadcrumbs_firm_office_edit
    breadcrumbs_firm_offices << crumb_firm_office_edit
  end

  def breadcrumbs_firm_office_new
    breadcrumbs_firm_offices << crumb_firm_office_new
  end

  def breadcrumbs_trading_name_new
    breadcrumbs_root << crumb_trading_name_new
  end

  def breadcrumbs_principal_edit
    breadcrumbs_firm_edit << crumb_principal_edit
  end

  def breadcrumbs_travel_insurance_firm_office
    breadcrumbs_root << crumb_travel_insurance_office
  end

  def crumb_root
    { locale_key: 'self_service.navigation.root', url: firm_root_path }
  end

  def crumb_travel_insurance_office
    { locale_key: 'self_service.travel_insurance_firm.office_edit.breadcrumb' }
  end

  def crumb_trading_name_edit
    {
      name: t('self_service.trading_name_edit.breadcrumb',
              firm_name: @firm.registered_name),
      url: edit_self_service_trading_name_path(@firm)
    }
  end

  def crumb_firm_edit
    return crumb_trading_name_edit if @firm.trading_name?

    {
      name: t('self_service.firm_edit.breadcrumb',
              firm_name: @firm.registered_name),
      url: firm_edit_path
    }
  end

  def crumb_firm_advisers
    {
      name: t('self_service.advisers_index.breadcrumb'),
      url: self_service_firm_advisers_path(@firm)
    }
  end

  def crumb_firm_adviser_edit
    { name: t('self_service.adviser_edit.breadcrumb',
              adviser_name: @adviser.name) }
  end

  def crumb_firm_adviser_new
    { name: t('self_service.adviser_new.breadcrumb') }
  end

  def crumb_firm_offices
    {
      name: t('self_service.offices_index.breadcrumb'),
      url: self_service_firm_offices_path(@firm)
    }
  end

  def crumb_firm_office_edit
    { name: t('self_service.office_edit.breadcrumb',
              postcode: @office.address_postcode) }
  end

  def crumb_firm_office_new
    { name: t('self_service.office_new.breadcrumb') }
  end

  def crumb_trading_name_new
    { name: t('self_service.trading_name_new.breadcrumb',
              firm_name: @firm.registered_name) }
  end

  def crumb_principal_edit
    { name: t('self_service.principal_edit.breadcrumb',
              firm_name: @firm.registered_name) }
  end

  def firm_edit_path
    if @firm.instance_of?(TravelInsuranceFirm)
      edit_self_service_travel_insurance_firm_path(@firm)
    else
      edit_self_service_firm_path(@firm)
    end
  end

  def firm_root_path
    if @firm.instance_of?(TravelInsuranceFirm)
      self_service_travel_insurance_firms_path
    else
      self_service_root_path
    end
  end
end
