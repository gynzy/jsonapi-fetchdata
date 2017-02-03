require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Paginate < Parser

          def parse params={}
            number, limit, size = params.values_at('number', 'limit', 'size')
            {
              number: (number || 1).to_i,
              size: (size || limit || Kaminari.config.max_per_page || 40).to_i
            }
          end

        end
      end
    end
  end
end
