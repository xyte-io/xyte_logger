module Logs
  module Filters
    module Sidekiq
      class << self
        attr_writer :filter

        def call(log)
          filter.call(log)
        end

        def filter
          @filter ||= default_filter
        end

        def default_filter
          ->(log) { true }
        end
      end
    end
  end
end
