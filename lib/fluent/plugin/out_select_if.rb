
module Fluent
  class SelectIfOutput < Fluent::Output
    Fluent::Plugin.register_output('select_if', self)

    config_param :select_if, :string
    config_param :add_prefix

    def emit(tag, es, chain)
      time_records = []
      es.each {|time, record|
        if eval(@select_if)
          time_records << [time, record]
        else
          $log.trace {"filtered: #{Time.at(time)} #{tag} #{record.inspect}"}
        end
      }
      time_records.each do |time, record|
        Fluent::Engine::emit(@add_prefix + "." + tag, time, record)
      end
      chain.next
      time_records
    end
  end
end
