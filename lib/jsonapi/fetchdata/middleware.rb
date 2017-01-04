require 'jsonapi/fetchdata/parameters'
require 'active_support/core_ext/hash'
require 'rack/request'

module JSONAPI
  module FetchData
    class Middleware

      def initialize app, *parsers
        @app = app
        @selected_parsers = parsers.map(&:to_s)
      end

      def call env
        request = Rack::Request.new env
        if formatted = parse_json_api_parameters(request.params)
          formatted.each do |key, value|
            request.update_param key, value
          end
        end

        @app.call env
      end

      private

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
        if @selected_parsers.any?
          available_parsers.slice *@selected_parsers
        else
          available_parsers
        end
      end

      def parse_json_api_parameters params
        arguments = params.slice *parsers.keys

        conditions = arguments.reduce('page' => { 'number' => '1' }) do |mem, (key, value)|
          next unless parser = parsers[key]
          mem[key] = parser.parse value
          mem
        end
      end

    end
  end
end
