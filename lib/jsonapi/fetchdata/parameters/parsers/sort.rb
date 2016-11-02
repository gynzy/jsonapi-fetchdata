require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Sort < Parser

          def parse params={}
            params.map{ |v| v.scan(/[-\w]+/) }.flatten.map { |c| (c[0] == '-') ? Hash[c[1..-1].to_sym, :desc] : c.to_sym }
          end

        end
      end
    end
  end
end
