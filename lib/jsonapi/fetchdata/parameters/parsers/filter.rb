require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Filter < Parser

          def parse params={}
            params.reduce({}) do |mem, (key, value)|
              ids = value.scan(/[\d]+/).map(&:to_i)
              mem[key.to_sym] = (ids.size == 1) ? ids.first : ids
              mem
            end
          end

        end
      end
    end
  end
end
