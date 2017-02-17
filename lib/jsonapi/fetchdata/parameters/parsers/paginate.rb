require 'jsonapi/fetchdata/parameters/parser'

# parses both page and offset strategies
# internally translates into offset, since thats native to AR

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Paginate < Parser

          def parse params={}
            number, size, offset, limit = params.values_at('number', 'size', 'offset', 'limit')
            limit = (limit || size || JSONAPI::FetchData.config.max_per_page).to_i
            number = (number || 1).to_i
            offset = (offset || number * limit).to_i
            {
              'offset' => offset,
              'limit' => limit
            }
          end

        end
      end
    end
  end
end
