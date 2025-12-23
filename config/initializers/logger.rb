# frozen_string_literal: true

require 'rails_semantic_logger'
require 'logs/formatters/json'
require 'logs/filters/rails'

Rails.application.reloader.to_prepare do
  ActiveRecord::Base.logger.level = :info

  Rails.application.configure do
    is_dev = Rails.env.development?

    formatter = is_dev ? :color : Logs::Formatters::Json.new
    filter = is_dev ? nil : Logs::Filters::Rails

    config.logger = SemanticLogger['Rails']
    config.colorize_logging = is_dev

    config.semantic_logger.clear_appenders!
    config.semantic_logger.add_appender(
      io: $stdout,
      level: config.log_level,
      formatter: formatter,
      filter: filter
    )

    config.semantic_logger.backtrace_level = nil

    # Disable quiet_assets when the app does not expose an assets config (API-only apps),
    # otherwise rails_semantic_logger will try to call config.assets and raise.
    config.rails_semantic_logger.quiet_assets = config.respond_to?(:assets)
    config.rails_semantic_logger.started = false
    config.rails_semantic_logger.processing = false
    config.rails_semantic_logger.rendered = false
    config.rails_semantic_logger.add_file_appender = false

    SemanticLogger.add_signal_handler
  end

  SemanticLogger.add_signal_handler
end
