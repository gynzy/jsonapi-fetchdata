require 'jsonapi/fetchdata/parameters/adapter'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash'

module JSONAPI
  module FetchData
    class Resource

      def self.find(scope, conditions={}, *parsers)
        new(scope, *parsers).find(conditions)
      end

      def initialize scope, *parsers
        default = ['include', 'fields']
        selected = (default & parsers)
        parsers = if selected.empty?
                    default
                  else
                    selected
                  end

        @scope = scope
        @adapter = JSONAPI::FetchData::Parameters::Adapter.new(*parsers)
      end

      def find conditions={}
        id = conditions.fetch('id', nil)
        process(@adapter.parameters(conditions)).find(id)
      end

      def process conditions
        conditions.each do |k, v|
          @scope =  case k.to_sym
                      when :include then @scope.includes(v).references(v.map(&:tableize))
                      when :fields  then @scope.select(full_column_names(v))
                      else raise 'unsupported'
                    end
        end
        @scope
      end

      def full_column_names values
        case values
        when Hash then
          values.reduce([]) do |columns,(table_name, names)|
            columns + [names].flatten.map{ |column| "#{table_name}.#{column}"}
          end
        else
          [values].flatten.map{ |column| "#{table_name}.#{column}"}
        end
      end

    end
  end
end
