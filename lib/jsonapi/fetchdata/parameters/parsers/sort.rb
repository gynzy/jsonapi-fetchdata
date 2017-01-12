require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Sort < Parser

          def parse params
            if params && (params.size > 0)
              params.scan(/[-\w]+/).flatten.map { |c| (c[0] == '-') ? "#{c[1..-1]} DESC" : c }.join(", ")
            end
          end

        end
      end
    end
  end
end
