require 'active_model'

module Logs
  module Filters
    module Rails
      class << self
        attr_writer :filter

        def call(log)
          return true unless log_filter_enabled?

          filter.call(log)
        end

        def filter
          @filter ||= default_filter
        end

        def default_filter
          ->(log) { true }
        end

        def log_filter_enabled?
          return $log_filtering if defined?($log_filtering) && !$log_filtering.nil?

          @log_filter_enabled ||= ActiveModel::Type::Boolean.new.cast(ENV.fetch('LOG_FILTER', true))
        end
      end
    end
  end
end
