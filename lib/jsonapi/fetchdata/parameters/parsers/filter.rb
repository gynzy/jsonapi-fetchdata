require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Filter < Parser

          def parse params={}
            params.reduce({}) do |mem, (key, value)|
              if value && (value.size > 0)
                v = value.split(',')
                mem[key] = (v.size == 1) ? v.first : v
              end
              mem
            end
          end

        end
      end
    end
  end
end
