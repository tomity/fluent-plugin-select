
module Fluent
  class SelectIfOutput < Fluent::Output
    Fluent::Plugin.register_output('select_if', self)

    config_param :select_if, :string
    config_param :add_prefix, :string
    config_param :timeout, :integer, :default => 1

    def emit(tag, es, chain)
      begin
        time_records = []
        es.each {|time, record|
          if eval(@select_if)
            $log.trace {"hoge"}
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
        $log.error "Select_if command is syntax error: #{@select_if}"
        e #for test
      end
    end
  end
end
