# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( capital_increases.js )
Rails.application.config.assets.precompile += %w( capital_increases.css )
Rails.application.config.assets.precompile += %w( companies.js )
Rails.application.config.assets.precompile += %w( companies.css )
Rails.application.config.assets.precompile += %w( transactions.js )
Rails.application.config.assets.precompile += %w( transactions.css )
Rails.application.config.assets.precompile += %w( company_report.js )
Rails.application.config.assets.precompile += %w( contract_report.js )
Rails.application.config.assets.precompile += %w( capital_increases_form.js )
Rails.application.config.assets.precompile += %w( setModal.js )
Rails.application.config.assets.precompile += %w( transaction_form.js )