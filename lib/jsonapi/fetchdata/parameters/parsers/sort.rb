require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Sort < Parser

          def parse params
            if params && (params.size > 0)
              params.scan(/[-\w]+/).flatten.map { |c| (c[0] == '-') ? Hash[c[1..-1], 'desc'] : c }
            end
          end

        end
      end
    end
  end
end
