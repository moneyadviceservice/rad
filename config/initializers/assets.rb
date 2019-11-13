Rails.application.configure do
  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  config.assets.paths << Rails.root.join('node_modules', '@bower_components')

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
    ../../app/assets/javascripts/modules/MultiTableFilter.js
    ../../app/assets/javascripts/modules/ConfirmableForm.js
    ../../app/assets/javascripts/modules/LanguageSelector.js
    ../../app/assets/javascripts/modules/FieldToggleVisibility.js
    ../../app/assets/javascripts/modules/RemoteAndFaceToFaceOptions.js
    ../../app/assets/javascripts/modules/AdviserAjaxCall.js
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
