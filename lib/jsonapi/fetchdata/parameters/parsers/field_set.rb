require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class FieldSet < Parser

          def parse params={}
            params.reduce({}) do |mem, (key, value)|
              ids = value.scan(/[\w]+/).map(&:to_sym)
              mem[key.to_sym] = (ids.size == 1) ? ids.first : ids
              mem
            end
          end

        end
      end
    end
  end
end
