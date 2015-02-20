require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Yohoushi
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use Rack::StreamingProxy::Proxy do |request|
      next unless Settings.proxy
      if request.path.start_with?('/graph/')
        path = URI::unescape(request.path) # request.path are passed after uri escaped by rack
        $mfclient.get_graph_uri(path[7..-1], request.params)
      elsif request.path.start_with?('/complex/')
        path = URI::unescape(request.path)
        $mfclient.get_complex_uri(path[9..-1], request.params)
      end
    end
  end
end
