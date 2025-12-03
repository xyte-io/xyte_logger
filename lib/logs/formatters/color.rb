module Logs
  module Formatters
    class Color < SemanticLogger::Formatters::Color
      def time
        nil
      end

      def tags
        (Rails.env.development? || Rails.env.test?) ? nil : super
      end

      def process_info
        # Make dev logs easier to read
        Rails.env.development? ? nil : "[#{pid || '?'}] [#{thread_name}]"
      end

      def exception
        return unless log.exception

        "\n#{color} - Exception: #{log.exception.class}: #{log.exception.message}\n -- #{Rails.backtrace_cleaner.clean(log.exception.backtrace).join("\n -- ")}#{color_map.clear}"
      end

      def message
        "#{(Rails.env.development? || Rails.env.test?) ? "\n" : ''} -- #{log.message}" if log.message
      end

      def duration
        colored = super

        format('%7s', colored) if colored
      end
    end
  end
end
