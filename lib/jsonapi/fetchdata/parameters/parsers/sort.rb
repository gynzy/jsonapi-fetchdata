require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Sort < Parser

          def parse params
            if params && (params.size > 0)
              params.split(',').flatten.map { |c| (c[0] == '-') ? "#{c.underscore[1..-1]} DESC" : c.underscore }.join(", ")
            end
          end

        end
      end
    end
  end
end
