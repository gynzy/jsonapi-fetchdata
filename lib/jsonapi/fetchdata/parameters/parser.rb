require 'active_support/core_ext/module/delegation'

module JSONAPI
  module FetchData
    module Parameters
      class Parser

        class << self
          delegate :parse, to: :new
        end

        def parse params={}
          raise NotImplementedError
        end

      end
    end
  end
end
