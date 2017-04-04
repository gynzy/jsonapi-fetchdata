$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jsonapi/fetchdata'

RSpec.configure do |rspec|
  rspec.before do
    stub_const('ActiveRecord::VERSION::MAJOR', 4)
  end
end
