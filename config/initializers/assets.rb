# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile += %w(bootstrap.min.js popper.js)

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
