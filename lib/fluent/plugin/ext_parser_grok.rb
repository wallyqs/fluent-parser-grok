module Fluent
  class TextParser
    class GrokParser
      include Configurable
  
      config_param :time_key, :string, :default => 'time'
      config_param :time_format, :string, :default => nil
  
      def initialize(format, conf)
        super()
        unless conf.empty?
          configure(conf)
        end
  
        unless @time_format.nil?
          @time_parser = TimeParser.new(@time_format)
          @mutex = Mutex.new
        end
        
        require 'grok-pure'
        @grok = Grok.new
        Dir.glob(File.join(File.dirname(__FILE__), 'grok-patterns/*.grok')) do |pattern_file|
          @grok.add_patterns_from_file(pattern_file)
          @grok.compile(format)
        end
      end
  
      def call(text)
        time = nil
        match = @grok.match(text)
        if not match
          $log.error("#{text} did not match the Grok pattern=#{@grok.pattern}")
        end
        record = match.captures

        if value = record.delete(@time_key)
          value = value[0] if value.is_a?(Array)
          if @time_format
            time = @mutex.synchronize { @time_parser.parse(value) }
          else
            time = value.to_i
          end
        else
          time = Engine.now
        end
  
        return time, record
      end
    end
  end
end
