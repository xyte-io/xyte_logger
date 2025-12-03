module Logs
  module Formatters
    class Text < SemanticLogger::Formatters::Default
      def time
        nil
      end

      def tags
        nil
      end

      def process_info
        nil
      end

      def exception
        return unless log.exception

        "\n- Exception: #{log.exception.class}: #{log.exception.message}\n -- #{Rails.backtrace_cleaner.clean(log.exception.backtrace).join("\n -- ")}"
      end

      def message
        "\n -- #{log.message}" if log.message
      end
    end
  end
end
