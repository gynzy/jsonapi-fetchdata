require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class FieldSet < Parser

          def parse params={}
            params.reduce({}) do |mem, (key, value)|
              if value && (value.size > 0)
                ids = value.underscore.scan(/[\w]+/)
                mem[key] = (ids.size == 1) ? ids.first : ids
              end
              mem
            end
          end

        end
      end
    end
  end
end
