require 'jsonapi/fetchdata/parameters'
require 'jsonapi/fetchdata/parameters/adapter'
require 'active_support/core_ext/hash'
require 'rack/request'

module JSONAPI
  module FetchData
    class Middleware

      def initialize app, *parsers
        @app = app
        @adapter = JSONAPI::FetchData::Parameters::Adapter.new(*parsers)
      end

      def call env
        request = Rack::Request.new env
        jsonapi_parameters = @adapter.parameters(request.params)
        jsonapi_parameters.each do |key, value|
          request.update_param key, value
        end

        @app.call env
      end

    end
  end
end
