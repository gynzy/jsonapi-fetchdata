require 'jsonapi/fetchdata/parameters/adapter'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash'

module JSONAPI
  module FetchData
    class Collection

      def self.find(klass, conditions={}, *parsers)
        new(klass, *parsers).find(conditions)
      end

      def initialize klass, *parsers
        @klass = klass
        @adapter = JSONAPI::FetchData::Parameters::Adapter.new(*parsers)
      end

      def find conditions={}
        process @klass.all, @adapter.parameters(conditions)
      end

      def process scope, conditions
        conditions.each do |k, v|
          case k.to_sym
            when :include then scope = scope.includes(v)
            when :fields  then scope = scope.select(full_column_names(v, scope.klass.table_name))
            when :filter  then scope = scope.where(v)
            when :sort    then scope = scope.order(v)
            when :page    then scope = scope.page(v[:number]).per(v[:size])
            else               raise 'unsupported'
          end
        end
        puts scope.explain
        scope
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
