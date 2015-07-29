class RootPage < SitePrism::Page
  set_url '/'
  set_url_matcher %r{/$}

  section :sign_in_panel, SignInPanelSection, '.t-sign-in-panel'
end
