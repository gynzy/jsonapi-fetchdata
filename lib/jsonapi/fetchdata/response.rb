module JSONAPI
  module FetchData
    class Response

      attr_reader :scope, :options

      def initialize scope, conditions={}
        options = conditions.deep_symbolize_keys.slice(:include, :filter)

        options = options.reduce({}) do |h, (k,v)|
          h[k] = path(v)
          h
        end

        options[:fields] = conditions[:fields]
        options
      end

      private

      def path options={}
        case options
        when Enumerable then
          options = options.reduce([]) do |a,(k,v)|
            v = k if k.kind_of? Hash and v.nil?

            value = case v
            when Hash then path(v)
            when Array then v.map{ |i| "#{k}.#{path(i)}" }
            when nil then [k]
            else ["#{k}.#{v}"]
            end
            a.concat value
          end
        else
          options
        end
      end

    end
  end
end
