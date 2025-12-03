module Logs
  module Formatters
    class Json < SemanticLogger::Formatters::Json
      def exception
        return unless log.exception

        hash[:exception] = {
          name: log.exception.class.name,
          text: log.exception.message
        }
      end

      def message
        if log.message
          hash[:text] = log.cleansed_message
        elsif log.exception
          # We currently don't log nested exceptions, to make logs clearer. Might need to re-enable in the future
          hash[:text] = "[#{log.exception.class.name}] #{log.exception.message}"
        end
      end

      def named_tags
        return unless log.named_tags && !log.named_tags.empty?

        self.hash.merge!(
          log.named_tags.slice(:request_id, :ip, :job_id, :user, :tenant, :tenant_type, :job).compact
        )
      end

      def name
        hash[:name] = if log.name == 'Rails' && log.named_tags && log.named_tags[:job_class].present?
                        log.named_tags[:job_class]
                      else
                        log.name
                      end
      end

      def mem_usage
        return unless ENV.fetch('LOG_MEMORY_USAGE', 'false') == 'true'
        return unless log.named_tags&.dig(:start_mem)

        begin
          mem_klass = if defined?(GetProcessMem)
                        GetProcessMem
                      else
                        require 'get_process_mem'
                        GetProcessMem
                      end
        rescue LoadError
          return
        end

        start_mem = log.named_tags[:start_mem]
        current_mem = mem_klass.new.mb.round(2)

        hash[:memory] = {
          start: start_mem,
          end: current_mem,
          inc: (current_mem - start_mem).round(2)
        }
      end

      def payload
        return unless log.payload && !log.payload.empty?

        hash[:payload] = log.payload.compact

        # Truncate params if too long
        if log.payload[:params].to_s.length > 1000
          hash[:payload][:params] = "#{log.payload[:params].to_s[0..1000]}... [truncated]"
        end
      end

      def job_tags
        return unless log.named_tags && log.named_tags[:type] == 'job'

        hash[:job_id] = log.named_tags[:job_id]
        hash[:job_queue] = log.named_tags[:queue]
      end

      def call(log, logger)
        self.hash = {}
        self.log = log
        self.logger = logger

        self.hash[:level] = log.level
        self.hash[:duration_ms] = log.duration.round(2) if log.duration
        self.hash[:thread] = Thread.current.respond_to?(:native_thread_id) ? Thread.current.native_thread_id : Thread.current.object_id

        file_name_and_line
        named_tags
        name
        message
        payload
        exception
        metric
        mem_usage
        job_tags

        self.hash.compact.to_json
      rescue => exception
        { error: 'Exception during logging', message: exception.message }.to_json
      end
    end
  end
end
