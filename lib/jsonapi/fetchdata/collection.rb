require 'jsonapi/fetchdata/parameters/adapter'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash'

module JSONAPI
  module FetchData
    class Collection

      def self.find(scope, conditions={}, *parsers)
        new(scope, *parsers).find(conditions)
      end

      def initialize scope, *parsers
        @scope = scope
        @adapter = JSONAPI::FetchData::Parameters::Adapter.new(*parsers)
      end

      def find conditions={}
        process(@adapter.parameters(conditions))
        @scope
      end

      def process conditions
        conditions.each do |k, v|
          @scope = case k.to_sym
            when :include then @scope.includes(v)
            when :fields  then @scope.select(full_column_names(v, scope.klass.table_name))
            when :filter  then @scope.where(v)
            when :sort    then @scope.order(v)
            when :page    then @scope.page(v [:number]).per(v[:size])
            else raise 'unsupported'
          end
        end
      end

      def full_column_names values, table_name
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
