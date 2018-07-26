module JSONAPI
  module FetchData
    MAJOR = 0
    MINOR = 3
    TINY = 2

    VERSION = [MAJOR, MINOR, TINY].join('.').freeze

    def self.version
      VERSION
    end

  end
end
