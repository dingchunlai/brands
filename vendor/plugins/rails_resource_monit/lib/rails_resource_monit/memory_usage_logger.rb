begin
  require 'win32ole'
rescue LoadError
end

module RailsResourceMonit
  # 检测内存使用情况
  module MemoryUsageLogger
    def self.included(klass)
      klass.class_eval do
        before_filter :prepare_memory_usage_info
        after_filter  :log_memory_usage
      end
    end
  
    private
      def get_memory_usage
        if defined? WIN32OLE
          wmi = WIN32OLE.connect("winmgmts:root/cimv2")
          mem = 0
          query = "select * from Win32_Process where ProcessID = #{$$}"
          wmi.ExecQuery(query).each do |wproc|
            mem = wproc.WorkingSetSize
          end
          mem.to_i / 1000
        else
          `ps -o rss= -p #{$$}`.to_i
        end
      end
      
      def prepare_memory_usage_info
        @memory_usage_before_perform_action = get_memory_usage
      end

      def log_memory_usage
        if logger
          memory_usage = get_memory_usage
          logger.info("Memory usage: #{memory_usage} | PID: #{$$}")
          logger.info("Memory consumed: #{memory_usage - @memory_usage_before_perform_action} | PID: #{$$}")
        end
      end
  end
end
