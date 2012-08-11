
module Fluent
  class SelectOutput < Fluent::Output
    Fluent::Plugin.register_output('select', self)

    config_param :select, :string
    config_param :add_prefix, :string, :default => nil
    config_param :tag, :string, :default => nil
    config_param :timeout, :integer, :default => 1

    def configure(conf)
      super
      if @add_prefix
        @mode = "add_prefix"
      elsif @tag
        @mode = "tag"
      else
        raise ConfigError, "Either add_prefix or tag is required "
      end
    end

    def emit(tag, es, chain)
      begin
        time_records = []
        es.each {|time, record|
          if eval(@select)
            time_records << [time, record]
          else
            $log.trace {"filtered: #{Time.at(time)} #{tag} #{record.inspect}"}
          end
        }
        time_records.each do |time, record|
          if @mode == "add_prefix"
            Fluent::Engine::emit(@add_prefix + "." + tag, time, record)
          else
            Fluent::Engine::emit(@tag, time, record)
          end
        end
        chain.next
        time_records #for test
      rescue SyntaxError => e
        chain.next
        $log.error "Select command is syntax error: #{@select}"
        e #for test
      end
    end
  end
end
