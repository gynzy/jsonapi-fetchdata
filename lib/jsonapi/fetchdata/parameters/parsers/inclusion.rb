require 'jsonapi/fetchdata/parameters/parser'
require 'active_support/core_ext/hash'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Inclusion < Parser

          def parse params={}

            results = params.strip.split(/[\s,]+/).map do |s|
              h = s.strip.split(/\./).reverse.reduce do |a, b|
                Hash[b, a]
              end
            end

            results.reduce([]) do |a, b|
              if (Hash === b && (source = a.find {|v| Hash === v && v.has_key?(b.keys.first) }))
                source.deep_merge! b, &method(:resolution)
                b.keys.each { |k| a.delete k }
                a
              else
                a << b
              end
            end

          end

          def resolution key, a, b
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
