# frozen_string_literal: true

require 'rails/railtie'

module XyteLogger
  class Railtie < Rails::Railtie
    initializer 'xyte_logger.configure_logger' do
      require File.expand_path('../../config/initializers/logger', __dir__)
    end
  end
end
