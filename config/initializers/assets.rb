Rails.application.configure do
  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

  # Application Stylesheets
  config.assets.precompile += %w(
    admin.css
    enhanced_fixed.css
    enhanced_responsive.css
    dough/assets/stylesheets/basic.css
    dough/assets/stylesheets/font_files.css
    dough/assets/stylesheets/font_base64.css
  )

  # Application JavaScript
  config.assets.precompile += %w(
    admin.js
    rsvp/rsvp.js
    dough/assets/js/**/*.js
    modules/MultiTableFilter.js
    modules/ConfirmableForm.js
    modules/LanguageSelector.js
    modules/FieldToggleVisibility.js
    modules/RemoteAndFaceToFaceOptions.js
    modules/AdviserAjaxCall.js
  )

  # Vendor JavaScript
  config.assets.precompile += %w(
    jquery/dist/jquery.js
    jquery-ujs/src/rails.js
    jquery-fastlivefilter/jquery.fastLiveFilter.js
    eventsWithPromises/src/eventsWithPromises.js
    rsvp/rsvp.amd.js
    requirejs/require.js
    modernizer-flexbox-cssclasses.js
  )
end
