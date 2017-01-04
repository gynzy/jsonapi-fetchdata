require 'active_support/core_ext/hash/indifferent_access'

module JSONAPI
  module FetchData
    module Parameters
      class Adapter

        def initialize *parsers
          @selected_parsers = parsers.map(&:to_s)
        end

        def parameters params={}
          jsonapi_params = parse params
          jsonapi_params.with_indifferent_access
        end

        # private

        def parse params
          subset = params.slice(*parsers.keys)
          subset.reduce({}) do |mem, (key, value)|
            next unless parser = parsers[key]
            mem[key] = parser.parse value
            mem
          end
        end

        def available_parsers
          @available_parsers ||= {
            'page'     => Parameters::Parsers::Paginate,
            'include'  => Parameters::Parsers::Inclusion,
            'sort'     => Parameters::Parsers::Sort,
            'fields'   => Parameters::Parsers::FieldSet,
            'filter'   => Parameters::Parsers::Filter
          }
        end

        def parsers
          @parsers ||=  if @selected_parsers.any?
                          available_parsers.slice *@selected_parsers
                        else
                          available_parsers
                        end
        end

      end
    end
  end
end
