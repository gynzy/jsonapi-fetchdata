require 'jsonapi/fetchdata/parameters/parser'

module JSONAPI
  module FetchData
    module Parameters
      module Parsers
        class Sort < Parser

          def parse params
            if params && (params.size > 0)
              if ::ActiveRecord::VERSION::MAJOR >= 4
                [params].flatten.map{ |col| col.scan(/[-\w]+/)}.flatten.map { |c| (c[0] == '-') ? Hash[c.underscore[1..-1], 'desc'] : c.underscore }
              else
                params.scan(/[-\w]+/).flatten.map { |c| (c[0] == '-') ? "#{c.underscore[1..-1]} DESC" : c.underscore }.join(", ")
              end
            end
          end

        end
      end
    end
  end
end
