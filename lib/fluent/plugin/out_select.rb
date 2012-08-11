
module Fluent
  class SelectOutput < Fluent::Output
    Fluent::Plugin.register_output('select', self)

    config_param :select, :string
    config_param :add_prefix, :string
    config_param :timeout, :integer, :default => 1

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
          Fluent::Engine::emit(@add_prefix + "." + tag, time, record)
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
