# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( company_form.js )
Rails.application.config.assets.precompile += %w( capital_increase_index.js )
Rails.application.config.assets.precompile += %w( capital_increase_form.js )
Rails.application.config.assets.precompile += %w( transaction_index.js )
Rails.application.config.assets.precompile += %w( transaction_form.js )
Rails.application.config.assets.precompile += %w( company_report.js )
Rails.application.config.assets.precompile += %w( contract_report.js )
Rails.application.config.assets.precompile += %w( lackinfo_report.js )
Rails.application.config.assets.precompile += %w( main_index.js )
Rails.application.config.assets.precompile += %w( setModal.js )
Rails.application.config.assets.precompile += %w( check_form.js )