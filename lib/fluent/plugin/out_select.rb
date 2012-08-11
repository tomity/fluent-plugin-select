
module Fluent
  class SelectOutput < Fluent::Output
    Fluent::Plugin.register_output('select', self)

    config_param :select, :string
    config_param :add_prefix, :string, :default => nil
    config_param :tag, :string, :default => nil
    config_param :timeout, :time, :default => 1

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
        output_es = do_select(tag, es)
        if @mode == "add_prefix"
          Fluent::Engine::emit_stream(@add_prefix + "." + tag, output_es)
        else
          Fluent::Engine::emit_stream(@tag, output_es)
        end
        chain.next
        output_es #for test
      rescue SyntaxError => e
        chain.next
        $log.error "Select command is syntax error: #{@select}"
        e #for test
      end
    end

    def do_select(tag, es)
      output_es = MultiEventStream.new
      es.each {|time, record|
        timeout_block{
          if eval(@select)
            output_es.add(time, record)
          else
            $log.trace {"filtered: #{Time.at(time)} #{tag} #{record.inspect}"}
          end
        }
      }
      output_es
    end

    def timeout_block
      begin
        Timeout.timeout(@timeout){
          yield
        }
      rescue Timeout::Error
        $log.error {"Timeout: #{Time.at(time)} #{tag} #{record.inspect}"}
      end
    end
  end
end
