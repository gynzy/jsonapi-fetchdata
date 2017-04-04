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
        if env['PATH_INFO'].start_with?('/api/v3')
          request = Rack::Request.new env
          jsonapi_parameters = @adapter.parameters(request.params)
          jsonapi_parameters.each do |key, value|
            if request.respond_to? :update_param
              request.update_param key, value
            else
              request.params[key] = value
            end
          end
        end


        @app.call env
      end

    end
  end
end
