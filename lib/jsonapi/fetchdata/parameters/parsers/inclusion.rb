require 'jsonapi/fetchdata/parameters/parser'
require 'active_support/core_ext/hash'


module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Inclusion < Parser

          def parse params
            if params && (params.size > 0)
              query = params.is_a?(Array) ? params : params.strip.split(/[\s,]+/)

              results = query.map do |s|
                s.strip.split(/\./).reverse.reduce do |a, b|
                  Hash[b, a]
                end if s
              end

              results.reduce([]) do |a, b|
                if Hash === b
                  source = a.find {|v| Hash === v && v.has_key?(b.keys.first) }
                  if source
                    source.deep_merge!(b, &method(:resolution))
                    a
                  else
                    a << b
                  end
                else
                  a << b
                end
              end

            end
          end

          def resolution _, a, b
            case a
            when Array then
              case b
              when Array then a | b
              else a << b
              end
            else
              case b
              when Array then b << a
              when Hash then (b.keys.include?(a)) ? b : [a,b]
              else [a, b]
              end
            end
          end

        end
      end
    end
  end
end
