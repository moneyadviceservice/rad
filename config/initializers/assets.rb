# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  dough/assets/js/**/*.js
  dough/assets/stylesheets/basic.css
  dough/assets/stylesheets/font_files.css
  dough/assets/stylesheets/font_base64.css
)
