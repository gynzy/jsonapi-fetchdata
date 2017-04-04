require 'active_support/configurable'
require 'jsonapi/fetchdata/version'
require 'jsonapi/fetchdata/exceptions'
require 'jsonapi/fetchdata/middleware'
require 'jsonapi/fetchdata/collection'
require 'jsonapi/fetchdata/resource'

module JSONAPI
  module FetchData
    include ActiveSupport::Configurable

    config_accessor :max_per_page do
      50
    end

  end
end
