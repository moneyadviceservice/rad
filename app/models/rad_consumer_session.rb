class RadConsumerSession
  include Rails.application.routes.url_helpers

  def initialize(store)
    @store = store
    @store[:recently_visited_firms] ||= []
  end

  def firms
    @store[:recently_visited_firms]
  end

  def search_results_url(locale)
    (@store['locale_to_search_path_mappings'] || {})[locale.to_s]
  end

  def store(firm_result, params)
    update_most_recent_search(params)
    update_recently_visited_firms(firm_result, params)
  end

  private

  def update_most_recent_search(params)
    @store['locale_to_search_path_mappings'] = locale_to_search_path_mappings(params)
  end

  def update_recently_visited_firms(firm_result, params)
    return if firm_already_present?(firm_result)
    firms.pop if firms.length >= 3
    firms.unshift('id' => firm_result.id,
                  'name' => firm_result.name,
                  'closest_adviser' => firm_result.closest_adviser,
                  'face_to_face?' => firm_result.in_person_advice_methods.present?,
                  'profile_path' => locale_to_profile_path_mappings(params))
  end

  def firm_already_present?(firm_result)
    firms.any? { |firm_hash| firm_result.id == firm_hash['id'] }
  end

  def locale_to_search_path_mappings(params)
    {
      'en' => search_path_for(params, 'en'),
      'cy' => search_path_for(params, 'cy')
    }
  end

  def search_path_for(params, locale)
    search_path(search_form: params[:search_form], locale: locale)
  end

  def locale_to_profile_path_mappings(params)
    {
      'en' => firm_path(params['id'], search_form: params[:search_form], locale: 'en'),
      'cy' => firm_path(params['id'], search_form: params[:search_form], locale: 'cy')
    }
  end
end
