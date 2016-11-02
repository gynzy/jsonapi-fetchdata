require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash'

module JSONAPI
  module FetchData
    class Collection

      class << self
        delegate :call, to: :new
      end

      def call klass, conditions={}
        @klass = klass
        conditions = conditions.symbolize_keys
        conditions.extract! :controller, :action, :format

        special_conditions = conditions.extract! :order, :page
        collection = process(klass.all, conditions)

        special_conditions.reduce(collection) do |scope, (k, v)|
          case k
          when :sort
            next unless v
            order = case v
            when 'random' then 'RANDOM()'
            when /\./     then v
            else               "#{klass.table_name}.#{v}"
            end
            scope.order(order)
          when :page      then
            scope.page(v[:number]).per(v[:size])
          else scope
          end
        end
      end

      def process collection, conditions
        special_conditions = conditions.extract! :include, :fields, :filter
        special_conditions.reduce(collection) do |scope, (k, v)|
          case k
          when :include then scope.includes(v)
          #when :fields  then scope.select full_column_names(v, scope.klass.table_name)
          when :filter  then scope.where(v)
          else               scope
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
